
terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
    }
  }
}

provider "proxmox" {
  # Configuration options
  
}

resource "proxmox_vm_qemu" "Workspace" {
  
    name = "Workspace"
    desc = "Ubuntu server where I do all my coding projects"
    target_node = "proxmox"

    agent = 1

    clone = "iso"
    cores = 2
    sockets = 1
    cpu = "host"
    memory = 4028 #4 Gigs

    network {
      
    }

    disk {
      
    }

    
}