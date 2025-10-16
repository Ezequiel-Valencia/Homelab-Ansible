import subprocess
import os
import time
from datetime import datetime
import shutil

# List of source directories to sync
SOURCE_DIRS = [
    "/volume1/k8data/storage/ai",
    "/volume1/k8data/storage/media-config",
    "/volume1/k8data/storage/mobilizon",
    "/volume1/k8data/default-storage/bots-karakeep-storage-claim-pvc-559d7cd8-182b-4190-a616-78cd8bfb1501",
    "/volume1/k8data/default-storage/monitoring-alertmanager-homelab-alertmanager-db-alertmanager-homelab-alertmanager-0-pvc-88c4fe46-635b-405a-b94c-8a07d3d0614e"
]

# Destination directory for rsync and zips
DEST_DIR = "/volume1/@home/ezequiel/backups"
rsync_folder_cache = f"{DEST_DIR}/rsync"
all_zips_folder = f"{DEST_DIR}/zips"

# Age limit for old files (14 days = 2 weeks)
MAX_AGE_DAYS = 14

def run_rsync(src, dest):
    """Run rsync to sync a directory to the destination."""
    os.makedirs(dest, exist_ok=True)
    cmd = ["rsync", "-ah", "--delete", src, dest]
    print(subprocess.run(cmd, check=True))


def zip_directory(src_dir, output_dir):
    """Zip the synced folder with timestamp."""
    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    folder_name = os.path.basename(os.path.normpath(src_dir))
    zip_name = f"{folder_name}_{timestamp}"
    match folder_name.split():
        case x if "karakeep" in x:
            zip_name = f"karakeep_{timestamp}"
        case x if "alertmanager" in x:
            zip_name = f"alertmanager_{timestamp}"
    zip_path = f"{output_dir}/{zip_name}"
    shutil.make_archive(zip_path, 'zip', src_dir)
    return zip_path + ".zip"


def cleanup_old_backups(backup_path, max_age_days=14):
    """Check for files older than max_age_days in the destination folder."""
    cutoff_time = time.time() - (max_age_days * 86400)  # seconds in days
    files = os.listdir(backup_path)
    for file in files:
        file_path = f"{backup_path}/{file}"
        if os.path.isfile(file_path) and ".zip" in file_path:
            mtime = os.path.getmtime(file_path)
            if mtime < cutoff_time:
                print(f"[OLD] {file_path} is older than {max_age_days} days")
                os.remove(file_path)


def main():
    for src in SOURCE_DIRS:
        folder_name = os.path.basename(os.path.normpath(src))
        rsync_cache_path = f"{rsync_folder_cache}/{folder_name}"

        print(f"Syncing {src} -> {rsync_cache_path}")
        run_rsync(src, rsync_cache_path)

        zip_path = f"{all_zips_folder}/{folder_name}"
        print(f"Zipping {rsync_cache_path}")
        zip_file = zip_directory(rsync_cache_path, zip_path)
        print(f"Created: {zip_file}\n")

        print("Checking for old backups...")
        cleanup_old_backups(f"{all_zips_folder}/{folder_name}", MAX_AGE_DAYS)


if __name__ == "__main__":
    main()
