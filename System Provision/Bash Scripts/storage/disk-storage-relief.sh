#!/bin/bash

# Script for immediate storage relief on Debian-based systems
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

    printf "${CYAN}Starting storage cleanup...\n${NORMAL}"

    # Update package lists and remove unnecessary packages
    printf "${GREEN}Cleaning up package cache...\n${NORMAL}"
    apt update && apt autoremove -y && apt clean

    # Clear system logs, https://askubuntu.com/questions/1012912/systemd-logs-journalctl-are-too-large-and-slow
    printf "${GREEN}Clearing system logs...\n${NORMAL}"
    journalctl --vacuum-size=400M  # Reduce logs to 400MB

    # Remove temporary files
    printf "${GREEN}Removing temporary files...\n${NORMAL}"
    rm -rv /tmp/* /var/tmp/* 2>/dev/null;
    if [ $? -ne 0 ]; then
        printf "${RED}Can't remove temp files\n${NORMAL}"
    fi

    # If K8 machine remove unused images
    # https://github.com/k3s-io/k3s/issues/1900#issuecomment-644453072
    if which k3s &> /dev/null; then
        printf "${POWDER_BLUE}Cleaning dead images\n${NORMAL}"
        k3s crictl rmi --prune
    fi

    printf "${MAGENTA}Storage cleanup completed!\n${NORMAL}"

else
    printf "Only root may perform storage relief.\n"
    exit 2
fi

