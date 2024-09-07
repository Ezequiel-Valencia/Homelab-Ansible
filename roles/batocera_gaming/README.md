### Get Batocera Up

1. Boot from USB stick with Star bios
    1. Trying to install into hard drive is not worth it way to difficult.

2. Set static IP address. [link](https://wiki.batocera.org/network_issues) [network file](https://www.tecmint.com/set-add-static-ip-address-in-linux/)

3. Add entry to PiHole

4. Do PCIe passthrough
   1. Needed to turn on VT-D on motherboard and reconnect proxmox-boot-tool. [kpartx](https://forum.proxmox.com/threads/how-can-i-mount-a-partition-of-a-vm-lvm.8280/#post-46823) [redo boot](https://wiki.batocera.org/troubleshooting)

5. Set [security](https://wiki.batocera.org/security) for Batecora

6. Add essential users and change root passwd

7. Ansible


### Config

Batocera is a custom compilation of the linux kernel which is similar to Arch.
Batocera contains pacman as it's package manager so it requires pacman reposetories to be included so that custom software can be installed within Batocera.

[Pacman update](https://forum.batocera.org/d/4852-official-pacman-repository/3)

Lost cause for keyring though.


### Cron Jobs
A cron job needs to be made that executes everytime batocera starts up and sets it's IP address to a static one predetermined.