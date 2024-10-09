#!/bin/bash

# Date: 2023, Dec 27th
# Manual Interaction
# 1). Execute script
    # a). Currently just copy the script into machines that will run it
# 2). Deal with ssh keys
    # a). Generate keys for the server "ssh-keygen -f ~/.ssh/tatu-key-ecdsa -t ed25519"
    # b). Copy over ssh keys "ssh-copy-id -i ~/.ssh/tatu-key-ecdsa user@host"
        # i). If can not copy ssh, look into /etc/ssh/sshd_config file and turn on password authentication
        # ii). ssh-copy-id -o PubkeyAuthentication=no -p 5320 -i ~/.ssh/homelab zeke@10.0.0.8
# 3). Execute ansible script
    # a). Install sudo if the machine doesn't already have it
# 4). If the system already had previous users then remove them with "userdel -r username"

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

ADMIN_GROUP=admin

if [ $(id -u) -eq 0 ]; then
    printf "${CYAN}Making users and adding them to groups\n${NORMAL}"

    groupadd $ADMIN_GROUP

    for user in ansible zeke
    do
        printf "${MAGENTA}\nDealing with user $user\n${NORMAL}"
        if [ $(id "$user" | grep -c "$user") == 0 ]; then
            printf "${LIME_YELLOW}Making user $user\n${NORMAL}"
            useradd -m "$user"
            chsh --shell "/bin/bash" "$user"
            passwd "$user"
        elif [ $(id "$user" | grep -c "$user") == 1 ]; then
            printf "${GREEN}User $user already exists on this machine\n${NORMAL}"
        else
            printf "${RED}Number of users is strange, checkout user $user\n${NORMAL}"
        fi

        for group in $ADMIN_GROUP sudo
        do
            if [ $(id "$user" | grep -c "$group") == 0 ]; then
                printf "${LIME_YELLOW}Adding user $user to $group group\n${NORMAL}"
                usermod -aG "$group" "$user"
            elif [ $(id "$user" | grep -c "$adminGroup") == 1 ]; then
                printf "${GREEN}User $user already in $group group on this machine\n${NORMAL}"

            else
                printf "${RED}User added to $group group is strange, checkout user $user\n${NORMAL}"
            fi
        done
    done

else
    printf "Only root may add a user to the system"
    exit 2
fi


