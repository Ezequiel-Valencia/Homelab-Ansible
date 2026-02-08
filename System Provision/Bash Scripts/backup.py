import subprocess
import os
import time
from datetime import datetime, timezone, timedelta
import py7zr
from dataclasses import dataclass
import boto3
import json

@dataclass(frozen=True)
class BackupSpec:
    dir_path: str
    remote_backup: bool
    aws_key: str

#########################################
#           Modify This Section         #
#########################################

# List of source directories to sync
BACKUPS = [
    BackupSpec(dir_path="/volume1/k8data/storage/bots", remote_backup=True, aws_key="bots.7z"),
    BackupSpec(dir_path="/volume1/k8data/storage/ai", remote_backup=False, aws_key=""),
    BackupSpec(dir_path="/volume1/k8data/storage/media-config", remote_backup=True, aws_key="media.7z"),
    BackupSpec(dir_path="/volume1/k8data/storage/mobilizon", remote_backup=False, aws_key="")
]

ENV_FILE_PATH = ""

# Destination directory for rsync and zips
DEST_DIR = "/volume1/@home/ezequiel/backups"
rsync_folder_cache = f"{DEST_DIR}/rsync"
all_zips_folder = f"{DEST_DIR}/zips"


#!-------------------------------------------!#

ENCRYPT_PASSWORD=""
AWS_ACCESS_KEY=""
AWS_SECRET_KEY=""
BUCKET_NAME=""

def run_rsync(src: str, dest: str) -> None:
    """Run rsync to sync a directory to the destination."""
    os.makedirs(dest, exist_ok=True)
    cmd = ["rsync", "-ah", "--delete", src, dest]
    print(subprocess.run(cmd, check=True))


def zip_directory(src_dir: str, output_dir: str) -> str:
    """Zip the synced folder with timestamp."""
    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    folder_name = os.path.basename(os.path.normpath(src_dir))
    zip_path = f"{output_dir}/{folder_name}_{timestamp}.7z"
    
    config = [{'id': py7zr.FILTER_BZIP2, 'preset': 7, 'mt': True}, {'id': py7zr.FILTER_CRYPTO_AES256_SHA256}]
    with py7zr.SevenZipFile(zip_path, mode="w", password=ENCRYPT_PASSWORD, filters=config) as archive:
        archive.writeall(src_dir, arcname=folder_name)
    return zip_path


def cleanup_old_backups(backup_path: str, max_age_days=14) -> None:
    """Check for files older than max_age_days in the destination folder."""
    cutoff_time = time.time() - (max_age_days * 86400)  # seconds in days
    files = os.listdir(backup_path)
    for file in files:
        file_path = f"{backup_path}/{file}"
        is_file = os.path.isfile(file_path)
        zip_or_7z = ".zip" in file_path or ".7z" in file_path
        if is_file and zip_or_7z:
            mtime = os.path.getmtime(file_path)
            if mtime < cutoff_time:
                print(f"[OLD] {file_path} is older than {max_age_days} days")
                os.remove(file_path)


def should_upload_happen(s3_client, backup: BackupSpec) -> tuple[bool, str]:
    try:
        two_weeks_ago = datetime.now(timezone.utc) - timedelta(weeks=2)
        response = s3_client.head_object(Bucket=BUCKET_NAME, Key=backup.aws_key)
        last_modified = response['LastModified']
        
        if last_modified < two_weeks_ago:
            print(f"Old file found (Modified: {last_modified}). Moving to old...")
            copy_source = {'Bucket': BUCKET_NAME, 'Key': backup.aws_key}
            s3_client.copy_object(Bucket=BUCKET_NAME, Key=f"{backup.aws_key}.old", CopySource=copy_source)
            return True, "Last upload is over two weeks old."
        else:
            return False, "Current archive is less than 2 weeks old. Skipping upload."
    except s3_client.exceptions.ClientError as e:
        if e.response["ResponseMetadata"]["HTTPStatusCode"] == 404:
            return True, "No existing zip file found in bucket. Proceeding..."


def remote_backup(backup: BackupSpec, archive_file_path: str):
    s3 = boto3.client('s3', region_name="us-east-1", aws_access_key_id=AWS_ACCESS_KEY, aws_secret_access_key=AWS_SECRET_KEY)
    try:
        should_upload, reason = should_upload_happen(s3_client=s3, backup=backup)
        print(reason)
        if should_upload:
            print(f"Uploading {archive_file_path} to S3 bucket {BUCKET_NAME}...")
            s3.upload_file(archive_file_path, BUCKET_NAME, backup.aws_key)
    except Exception as e:
        print(f"An error occurred: {e}")


def main():
    for backup in BACKUPS:
        print("=======================================")
        src = backup.dir_path
        folder_name: str = os.path.basename(os.path.normpath(src))
        apps_cache: str = f"{rsync_folder_cache}/{folder_name}"
        zip_path = f"{all_zips_folder}/{folder_name}"

        print(f"Syncing {src} -> {rsync_folder_cache}")
        run_rsync(src=src, dest=rsync_folder_cache)

        print(f"Zipping {apps_cache}")
        zip_file = zip_directory(src_dir=apps_cache, output_dir=zip_path)
        print(f"Created: {zip_file}")

        print("Checking for old backups...")
        cleanup_old_backups(backup_path=zip_path)
        
        if backup.remote_backup:
            print("\n******************************")
            print(f"Starting Remote Backup for {zip_file} as key {backup.aws_key}")
            remote_backup(backup=backup, archive_file_path=zip_file)

        print("\n=======================================\n")

if __name__ == "__main__":
    with open(ENV_FILE_PATH, "r") as env:
        sec = json.load(env)
        BUCKET_NAME = sec["bucket_name"]
        AWS_ACCESS_KEY = sec["aws_access_key"]
        AWS_SECRET_KEY = sec["aws_secret_key"]
        ENCRYPT_PASSWORD = sec["encrypt_password"]
    main()
