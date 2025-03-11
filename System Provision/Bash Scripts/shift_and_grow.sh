#!/bin/bash

# Date: 2025, Feb 3rd
# Script made to extend the partitians, physical volumes, and logical volume groups
# in a Proxmox VM that's Debian, and is only extending its size

# https://pve.proxmox.com/wiki/Resize_disks


BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)


if [ $(id -u) -eq 0 ]; then
    printf "${CYAN}============\nDisplaying Disk Partitions\n============\n${NORMAL}"

    sfdisk -l

    CHOSEN_DISK=0
    CHOSEN_PARTITION=5
    printf "${RED}Ensure the disk is UNMOUNTED beforehand!!!${Normal}"
    printf "${MAGENTA}============\nInput Disk You Want to Shift Right(Usually /dev/sda): ${NORMAL}" && read CHOSEN_DISK
    printf "${MAGENTA}============\nInput Partition Number You Want to Shift Right(Ex. For /dev/sda5 it would be 5): ${NORMAL}" && read CHOSEN_PARTITION

    printf "${CYAN}============\nDisplaying Free Sectors\n============\n${NORMAL}"
    sfdisk -F

    SECTORS_TO_BE_MOVED=0
    printf "${MAGENTA}============\nCopy and paste the 'Sectors' displayed: ${NORMAL}"
    printf "${CYAN}\n============\n(It's the number of sectors that the partition will be moved.)\n============\n${NORMAL}"
    read SECTORS_TO_BE_MOVED
    
    printf "${MAGENTA}Execute Command (y/n): ${NORMAL}" && read EXECUTE_PV_COMMAND
    
    if [ "${EXECUTE_PV_COMMAND}" == "y" ]; then
        echo "+${SECTORS_TO_BE_MOVED}" | sfdisk --move-data $CHOSEN_DISK -N $CHOSEN_PARTITION
    else
        printf "Exited Script"
        exit 2
    fi

    

else
    printf "Only root may shift paritions."
    exit 2
fi

# First attempt backup VM. https://pve.proxmox.com/wiki/Resize_disks https://www.youtube.com/watch?v=Kyz9x71gEPI

# There are only two main partitions on Debian. Swap and boot.
# 1. Backup partition table
# 1. Turn off swap partition, https://superuser.com/questions/1627851/how-to-move-linux-swap-partition-gparted
# 2. Move it all the way to the right, https://unix.stackexchange.com/questions/744069/move-a-partition-to-the-right-using-command-line-tools
# 3. Unallocated space is available to append to boot partition.
# 4. Append unallocated space, https://unix.stackexchange.com/questions/67095/how-to-expand-ext4-partition-size-using-command-line
# 4. Verify with slfdisk 
# 5. Turn swap back on


