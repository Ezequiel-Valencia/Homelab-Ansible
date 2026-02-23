# Proxmox PCI/GPU Passthrough Ansible Role

This role automates the host configuration required to pass physical PCIe devices (like GPUs or Network Cards) into KVM Virtual Machines on Proxmox VE. 

**Based on:**
* [Proxmox PCI Passthrough Wiki](https://pve.proxmox.com/wiki/PCI_Passthrough)
* [Ultimate Beginner's Guide to GPU Passthrough (Reddit)](https://www.reddit.com/r/homelab/comments/b5xpua/the_ultimate_beginners_guide_to_gpu_passthrough/)

## Requirements
* A Proxmox VE Host utilizing the **GRUB** bootloader (If using `systemd-boot` on ZFS, GRUB changes will not apply; you must edit `/etc/kernel/cmdline` manually).
* Hardware that supports VT-d (Intel) or AMD-Vi (AMD) and Interrupt Remapping.
* UEFI / IOMMU enabled in your motherboard's BIOS settings.

## Example Playbook

```yaml
---
- hosts: proxmox_nodes
  become: yes
  roles:
    - role: pci_passthrough
      vars:
        pve_cpu_vendor: "amd" # or "intel"
        # Example to bind a GTX 1070 and its audio device directly to vfio
        pve_vfio_pci_ids: "10de:1b81,10de:10f0"
        pve_acs_override: false