# Home-Network
 Internal home network architeture. Everything here is only for internal network and does not have any external connection, other than a singualr port that a VPN connection is required for.
 https://superuser.com/questions/1324710/why-do-end-device-need-to-support-vlans

 ## Applications
The applications that will be ran on top of the OS that are installed within the hypervisor, and the management interface for all of these applications.


## Work Enviroment


 ## System Admin
 Consists of Firewall, intrusion detection system (IDS), intrusion prevention system (IPS), type one hypervisor, and DNS.



# Whole Picture



An amazing web series that I found to late, but seems to be very informational. https://youtube.com/playlist?list=PLjLkaXQ353210citr52k74DWb3IOzHWL7

# What I still need to do manually

## Provision Containers and VMs
- Add public key to containers
- Add user to containers
- Check VPN connection
- Modify qbittorent download location
- Create additional hard drive for media VM


# Ansible
Ansible playbooks are executed within some host device, and then usually through ssh, Ansible tries to connect to remote servers listed within its host variable that can be in a seperate file.

These remote servers then have all the tasks within Ansible excuted in a order, **however** for critical tasks that require one to be done prior to the other specify it within playbook itself.

Use "ansible-playbook {playbook name that is desired} --check" to make peform a dry run of ansible playbooks.

## Ansible Modules
Ansible modules are the API's that allow for execution of tasks related to applications desired. Ansibles actual syntax is very sparse,
all of its functionality seems to come from its modules.


### Kubernetes
To automatically install non-control servers with kubernetes there is kubespray.
Create a few config files for kubespray myself, then just clone the repo and execute it with my config files.


### Execution structure
Playbook runs all everything, checking if these roles are affiliated with the set of hosts. For each role, the sub-tasks executed are checked to make sure the hostname is what their expected sub-task affiliated with, allowing two layers of filtering. One layer is for general theme, the second is for specfic devices.


### Commands
- Dry run
    - ansible-playbook ./p*/init_home_lab.ansible.yml --check--ask-vault-pass
- Helpful docker commands
    - dock rm
    - dock compose up
    - docker exec sonnar curl ifconfig.me (checks what public IP is)
    - docker exec "container name" hostname -i (find internal IP address, setting up qbit and jack)
    - docker log "container name"
- Fixing storage issues
    - df -h
    - lvs
    - fdisk
    - lsblk


# Errors
If "Missing privilege separation directory: /run/sshd\r\n" error than add the directory, than everything is fine.

The docker_compose module works for creating containers, the other one bugs out.

For some reason trying to set the network to container when composing it, it just bugs out.

Docker run does not have itempotency

GLUETUN DOES NOT WORK.
Every time I try to use wireguard gluetun it does not work

So what I had to do was read the logs for the gluetun container. Turns out that errors have been being raised within the container and I have not been able to read them. Makes sense why other networking related problems would occur, there was no container network to connect to since it kept on failing.
Also it has to use a VM, cause other wise there is not TUN in containers which is required.


Qbit not downloading or super duper slow, its due to file permissions. Make the external directory where its data stored permissions accesible recursively.

Having really low stoarge because the lvm parition for the VM was only 100GB in total for some reason, and even when I increased it manually docker did not increase the size of the volumes. The fix to this was to create a small virtual disk for the bootable drive, then a completely empty other disk that had all of the storage. Then format this empty disk and put all of the volumes within it. Overlay is simply a driver for the file system that is being used within the OS, and can not increase its size if the file systems parition is not large either!


LVM not avialable what seemed to be due to the metadata getting fucked up. Most likely because of the constant turning off and on the prox machine manually instead of through the GUI. The fix I used was 
- lvconvert --repair pve/data
    - https://forum.proxmox.com/threads/task-error-activating-lv-pve-data-failed-activation-of-logical-volume-pve-data-is-prohibited-while-logical-volume-pve-data_tdata-is-active.106225/

some other possible links for future problems are
https://forum.proxmox.com/threads/local-lvm-not-available-after-kernel-update-on-pve-7.97406/page-3

https://forum.proxmox.com/threads/check-of-pool-pve-data-failed-status-1-manual-repair-required.100588/

Should buy some extra nvme to have the Proxmox OS mirrored so that if any errors persist I can just revert back to previous versions.
