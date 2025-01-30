### 403 Error

If it seems that everything is okay but the PiHole instance is throwing an error then it can be because the path being taken in the URL is not /admin.


### PiHole VM
By having the PiHole in a VM there's first an added layer of security since if it was in a linux container then it would be closer to the Proxmox OS.

Also by having it's own seprate VM there would be no conflicts with other services that may be running on the VM, plus security increase.

PiHole in docker container is so that it's easier to keep all of the services requirements neatly inside a box, thus if anything happens it's easier to diagnose and manage what occurs.


### Local DNS Not Resolving

If local DNS is not resolving then the following could be the problem.

1. The router DNS is not set to PiHole, with DHCP it also servers whats the default DNS server so that needs to be set
2. For linux machines systemd-resolved may need to be restarted

    1.  Some links to help. [1](https://askubuntu.com/questions/1012641/dns-set-to-systemds-127-0-0-53-how-to-change-permanently) [2](https://unix.stackexchange.com/questions/612416/why-does-etc-resolv-conf-point-at-127-0-0-53)

    2. Set global options but use "resolvectl status" instead of the command in this [link](https://notes.enovision.net/linux/changing-dns-with-resolve) 

    2. If you want to read the logs of this service use [journalctl](https://unix.stackexchange.com/questions/328131/how-to-troubleshoot-dns-with-systemd-resolved) 

3. Manually put the DNS resolver within the device


### Add Block List
https://avoidthehack.com/best-pihole-blocklists