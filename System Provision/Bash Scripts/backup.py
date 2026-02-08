import subprocess
import os
import time
from datetime import datetime
import py7zr

# List of source directories to sync
SOURCE_DIRS = [
    "/volume1/k8data/storage/bots",
    "/volume1/k8data/storage/ai",
    "/volume1/k8data/storage/media-config",
    "/volume1/k8data/storage/mobilizon"
]

ENCRYPT_PASSWORD=""

# Destination directory for rsync and zips
DEST_DIR = "/volume1/@home/ezequiel/backups"
rsync_folder_cache = f"{DEST_DIR}/rsync"
all_zips_folder = f"{DEST_DIR}/zips"


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


def main():
    for src in SOURCE_DIRS:
        folder_name: str = os.path.basename(os.path.normpath(src))
        apps_cache: str = f"{rsync_folder_cache}/{folder_name}"
        zip_path = f"{all_zips_folder}/{folder_name}"

        print(f"Syncing {src} -> {rsync_folder_cache}")
        run_rsync(src=src, dest=rsync_folder_cache)

        print(f"Zipping {apps_cache}")
        zip_file = zip_directory(src_dir=apps_cache, output_dir=zip_path)
        print(f"Created: {zip_file}\n")

        print("Checking for old backups...")
        cleanup_old_backups(backup_path=zip_path)


if __name__ == "__main__":
    main()
