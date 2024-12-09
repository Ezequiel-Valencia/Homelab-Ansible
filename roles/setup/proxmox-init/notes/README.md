### Proxmox SSH

Proxmox requires [root ssh](https://forum.proxmox.com/threads/pve-cluster-can-i-safely-turn-off-ssh-permitrootlogin-passwordauthentication-and-usepam.122958/) for now, and it seems to require [port 22](https://pve.proxmox.com/wiki/Cluster_Manager#:~:text=An%20SSH%20tunnel%20on%20TCP%20port%2022%20between%20nodes%20is%20required) to be used.

### Method for Network protection

Since these two requirements are needed, what can be done is:

1. Install fail2ban to prevent repeated attempts
2. Add a firewall that will allow for only proxmox nodes to communicate with each other


### GPU Passthrough

- Get proxmox boot tool working: [Forum Post](https://forum.proxmox.com/threads/update-initramfs-no-etc-kernel-pve-efiboot-uuids-found.121056/), [Spec](https://pve.proxmox.com/wiki/Host_Bootloader)

- GPU Passthrough: [Reddit Post](https://www.reddit.com/r/homelab/comments/b5xpua/the_ultimate_beginners_guide_to_gpu_passthrough/), [Spec](https://pve.proxmox.com/wiki/PCI_Passthrough)
