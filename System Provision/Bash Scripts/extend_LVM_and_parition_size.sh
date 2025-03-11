#!/bin/bash

# Date: 2024, Apr 21st
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
    printf "${CYAN}============\nEnsure Parted Tool is Installed\n============\n${NORMAL}"
    apt install parted

    printf "${CYAN}============\nDisplaying Disk Partitions\n============\n${NORMAL}"

    fdisk -l

    printf "${CYAN}============\nDisplaying Disks\n============\n${NORMAL}"

    lsblk

    CHOSEN_DISK=0
    printf "${MAGENTA}============\nInput Disk Where Resizing Parition Is (Usually /dev/sda): ${NORMAL}" && read CHOSEN_DISK
    printf "${RED}If the parition being resized is not at the end of the disk, quit this script and check other scripts for help\n${Normal}"
    printf "${CYAN}(Hint: Choose the type logical end partitian usually. Use 'print' to discover, 'resizepart # 100 (percent sign)' for full resize first with usually 2 then 5, and 'quit' to exit.)\n============\n${NORMAL}"
    parted $CHOSEN_DISK

    pvdisplay 
    printf "${MAGENTA}============\nInput the PV Name Wanting to be Resized (Usually ends with the number chosen previously): ${NORMAL}" && read CHOSEN_PV
    printf "${LIME_YELLOW}Executing Test of Command\n============\n${NORMAL}"
    pvresize -tv $CHOSEN_PV

    printf "${MAGENTA}Execute Command (y/n): ${NORMAL}" && read EXECUTE_PV_COMMAND
    
    if [ "${EXECUTE_PV_COMMAND}" == "y" ]; then
        pvresize $CHOSEN_PV
        
        printf "${CYAN}============\nDisplaying Logical Volumes to Resize\n============\n${NORMAL}"
        lvdisplay

        printf "${MAGENTA}Which LV Path Is Adding All Available Space: ${NORMAL}" && read LV_PATH

        lvresize --extents +100%FREE --resizefs $LV_PATH

        lvdisplay

        df -h

        printf "${CYAN}EXTENDED $LV_PATH \n${NORMAL}"


    else
        printf "Exited Script"
        exit 2
    fi

else
    printf "Only root may resize disks."
    exit 2
fi


