# System Admin

## Type 1 hypervisor
* Hypervisors that don't work
There are plenty of type one hypervisor such as KVM, Xen Server, Xen Project, VMware EXSI, XCP-ng and more. Xen server and KVM are both great hypervisors but each have their caveot. KVM is not fully a type 1 hypervisor, having an easer interface and a less isolated architecture than Xen server. The issue with Xen server is that it is owned by Microsoft, and is focused more towards profit.

https://forums.lawrencesystems.com/t/xen-vs-xenserver-vs-kvm-vs-proxmox/14256

* My chosen Hypervisor
Proxmox seems to be the best choice. It is slightly bloated, but it seems to simply work out of the gate, is fully open source and free, plus has an excellent UI. I would choose Xen to do my hypervisors since it is the most secure hypervisor, but it takes to much work. 

https://youtu.be/GMAvmHEWAMU
https://www.reddit.com/r/selfhosted/comments/wu8y7s/hypervisor_options_xen_vs_proxmox/



## Firewall
Pfsense is a free, opensource fire wall with a nightly build version that has features earlier but costs money, that one is called pfsense CE. Has all the features that could be desired for a firewall. https://www.youtube.com/watch?v=0bTjibLYSOo


## Intrusion Detection System
Pfense helps to integrate Snort within its firewall system, allowing traffic analysis. Snort is an open source IDS.

## Intrusion Prevention System


## Router
Software defined networking allows for the router to be a seperate entity from all other devices within a network. The router is used for fowarding packets along different IP addresses. 

### Potential Routers
- The netgate premade router but its expensive, and does not allow a lot of customization.

- The Zimaboard seems fine and can have pf sense installed within it, but it seems to be best as a swiss army knife for small pi projects rather than a device that can handle proxmox with pfsense, PiHole, and PiVPN/Wireguard VPN.

- Used mini PC's seem good and all, however security risk of firmware being compromised, lack of upgradability, and majority of them seem to not have reliable vendors.

- Self made mini PC seems to be the best option as of now, need to do further research though.

Currently it might prove itself to be most useful to just buy the mid range zimbaboard and use it only for pfsense. Seperately use another device to run PiHole and PiVPN.

## Access Point


## Switch


## Modem
The modem is the hardware which takes the raw signals provided by ISP and translate it into analog. Can change but not for now.


## DNS
Pi
https://youtu.be/FnFtWsZ8IP0


## Kubernetes
Would be good and definitly something I should persue in the future. But as of right now it would be to much to handle

https://www.qubes-os.org/


## Network Vids
https://youtu.be/_IzyJTcnPu8
https://youtu.be/hdoBQNI_Ab8
https://youtu.be/8QTdW0Q8U3E
https://youtu.be/lUzSsX4T4WQ

## Potential Router
https://www.ebay.com/itm/256050026761?mkcid=16&mkevt=1&mkrid=711-127632-2357-0&ssspo=aY7OL6JIRbO&sssrc=2047675&ssuid=&widget_ver=artemis&media=COPY 


## Access points
https://store.ui.com/collections/unifi-network-wireless/products/u6-lite-us 
