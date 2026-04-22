import subprocess
import os
import time
from datetime import datetime, timezone, timedelta
import py7zr
from dataclasses import dataclass
import boto3
import json
from slack_sdk.webhook import WebhookClient

@dataclass(frozen=True)
class DbBackupSpec:
    db_type: str   # "postgres" or "mysql"
    host: str
    port: int
    user: str
    password: str
    remote_backup: bool
    aws_key: str   # S3 key for the server's archive (e.g. "prod-postgres.7z")

#########################################
#           Modify This Section         #
#########################################

BACKUPS = [
    DbBackupSpec(db_type="postgres", host="localhost", port=5432, user="postgres", password="secret", remote_backup=True,  aws_key="postgres.7z"),
    DbBackupSpec(db_type="mysql",    host="localhost", port=3306, user="root",     password="secret", remote_backup=True,  aws_key="mysql.7z"),
]

ENV_FILE_PATH = ""

# Destination directory for dumps and zips
DEST_DIR = "/volume1/@home/ezequiel/backups"
dumps_dir = f"{DEST_DIR}/dumps"
all_zips_folder = f"{DEST_DIR}/zips"

#!-------------------------------------------!#

ENCRYPT_PASSWORD = ""
AWS_ACCESS_KEY = ""
AWS_SECRET_KEY = ""
BUCKET_NAME = ""


def dump_all_postgres(spec: DbBackupSpec, output_path: str) -> None:
    """Run pg_dumpall to export all databases, roles, and tablespaces."""
    env = os.environ.copy()
    env["PGPASSWORD"] = spec.password
    cmd = [
        "pg_dumpall",
        "-h", spec.host,
        "-p", str(spec.port),
        "-U", spec.user,
        "-f", output_path,
        "-c" # clean, drop everything on cluster that uses this to recover
    ]
    print(subprocess.run(cmd, check=True, env=env))


def dump_all_mysql(spec: DbBackupSpec, output_path: str) -> None:
    """Run mysqldump --all-databases to export all databases, users, and privileges."""
    env = os.environ.copy()
    env["MYSQL_PWD"] = spec.password
    cmd = [
        "mysqldump",
        "-h", spec.host,
        "-P", str(spec.port),
        "-u", spec.user,
        # Clean recovery, drops everything before it gets recovered --
        "--add-drop-database",
        "--add-drop-table",
        "--add-drop-trigger",
        #--
        "--dump-date",
        "--all-databases",
        "--single-transaction", # Begin statement, ensures dump is in one transaction and safe
        "--routines",
        "--triggers",
        "--events",
        "--skip-ssl"
    ]
    with open(output_path, "w") as f:
        print(subprocess.run(cmd, check=True, stdout=f, env=env))


def zip_file(src_file: str, output_dir: str) -> str:
    """Zip a single file with timestamp into output_dir, then delete the source file."""
    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    file_name = os.path.basename(src_file)
    zip_path = f"{output_dir}/{file_name}_{timestamp}.7z"

    config = [{'id': py7zr.FILTER_BZIP2, 'preset': 7, 'mt': True}, {'id': py7zr.FILTER_CRYPTO_AES256_SHA256}]
    with py7zr.SevenZipFile(zip_path, mode="w", password=ENCRYPT_PASSWORD, filters=config) as archive:
        archive.write(src_file, arcname=file_name)
    os.remove(src_file)
    return zip_path


def cleanup_old_backups(backup_path: str, max_age_days=7) -> None:
    """Remove zip files older than max_age_days from the destination folder."""
    cutoff_time = time.time() - (max_age_days * 86400)
    for file in os.listdir(backup_path):
        file_path = f"{backup_path}/{file}"
        if os.path.isfile(file_path) and (".zip" in file_path or ".7z" in file_path):
            if os.path.getmtime(file_path) < cutoff_time:
                print(f"[OLD] {file_path} is older than {max_age_days} days")
                os.remove(file_path)


def should_upload_happen(s3_client, aws_key: str) -> tuple[bool, str]:
    try:
        one_week_ago = datetime.now(timezone.utc) - timedelta(weeks=1)
        response = s3_client.head_object(Bucket=BUCKET_NAME, Key=aws_key)
        last_modified = response['LastModified']

        if last_modified < one_week_ago:
            print(f"Old file found (Modified: {last_modified}). Moving to old...")
            copy_source = {'Bucket': BUCKET_NAME, 'Key': aws_key}
            s3_client.copy_object(Bucket=BUCKET_NAME, Key=f"{aws_key}.old", CopySource=copy_source)
            return True, "Last upload is over one week old."
        else:
            return False, "Current archive is less than 1 week old. Skipping upload."
    except s3_client.exceptions.ClientError as e:
        if e.response["ResponseMetadata"]["HTTPStatusCode"] == 404:
            return True, "No existing zip file found in bucket. Proceeding..."


def remote_backup(aws_key: str, archive_file_path: str):
    s3 = boto3.client('s3', region_name="us-east-1", aws_access_key_id=AWS_ACCESS_KEY, aws_secret_access_key=AWS_SECRET_KEY)
    try:
        should_upload, reason = should_upload_happen(s3_client=s3, aws_key=aws_key)
        print(reason)
        if should_upload:
            print(f"Uploading {archive_file_path} to S3 bucket {BUCKET_NAME} as {aws_key}...")
            s3.upload_file(archive_file_path, BUCKET_NAME, aws_key)
    except Exception as e:
        print(f"An error occurred: {e}")


def main():
    os.makedirs(dumps_dir, exist_ok=True)
    os.makedirs(all_zips_folder, exist_ok=True)

    for spec in BACKUPS:
        print("=======================================")
        server_id = f"{spec.db_type}"
        print(f"Server: {spec.db_type}://{spec.host}:{spec.port}")

        zip_folder = f"{all_zips_folder}/{server_id}"
        os.makedirs(dumps_dir, exist_ok=True)
        os.makedirs(zip_folder, exist_ok=True)

        dump_file = f"{dumps_dir}/{server_id}.sql"

        print("Dumping all databases...")
        if spec.db_type == "postgres":
            dump_all_postgres(spec, dump_file)
        elif spec.db_type == "mysql":
            dump_all_mysql(spec, dump_file)
        else:
            raise ValueError(f"Unknown db_type: {spec.db_type!r}")

        print(f"Zipping {dump_file}")
        archive = zip_file(src_file=dump_file, output_dir=zip_folder)
        print(f"Created: {archive}")

        print("Checking for old backups...")
        cleanup_old_backups(backup_path=zip_folder)

        if spec.remote_backup:
            print(f"\nUploading as S3 key: {spec.aws_key}")
            remote_backup(aws_key=spec.aws_key, archive_file_path=archive)

        print("=======================================\n")


def _produce_slack_message(color, title, text, priority):
    return {
            "color": color,
            "author_name": "Database Backup",
            "author_icon": "",
            "title": title,
            "title_link": "",
            "text": text,
            "fields": [
                {
                    "title": "Priority",
                    "value": priority,
                    "short": "false"
                }
            ],
            "footer": "Database Backup",
        }


if __name__ == "__main__":
    with open(ENV_FILE_PATH, "r") as env:
        sec = json.load(env)
        BUCKET_NAME = sec["bucket_name"]
        SLACK_WEBHOOK = sec["slack_webhook"]
        AWS_ACCESS_KEY = sec["aws_access_key"]
        AWS_SECRET_KEY = sec["aws_secret_key"]
        ENCRYPT_PASSWORD = sec["encrypt_password"]
        slack_webhook = WebhookClient(SLACK_WEBHOOK)
    try:
        main()
        slack_webhook.send(attachments=[
            _produce_slack_message("#3F704D", "Database Backup Completed", "", "Low")
        ])
    except Exception as e:
        slack_webhook.send(attachments=[
            _produce_slack_message("#ab1a13", "Database Application Backup Error", f"{e}", "High")
        ])
