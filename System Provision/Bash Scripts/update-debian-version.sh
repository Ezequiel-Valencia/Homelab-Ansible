#!/bin/bash

apt update
apt -y upgrade
apt -y dist-upgrade

apt clean
apt autoremove

apt --fix-broken install

cat /etc/os-release

df -h

read -p "Continue Update, Should Have at Least 1 Gigabyte Free(y/N): " continue

if [[ $continue == "y" ]]; then
    sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
    find /etc/apt/sources.list.d -name "*.list" -exec sed -i 's/bookworm/trixie/g' {} \;
    apt update
    apt -y upgrade
    # Choose main disk for grub (usually /dev/sda)
    apt dist-upgrade
    cat /etc/os-release
fi


