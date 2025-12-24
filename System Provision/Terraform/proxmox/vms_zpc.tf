
locals {
  vm_description = <<-EOT
            ### What Template Has
            [Video I followed](https://www.youtube.com/watch?v=t3Yv4OOYcLs)
            
            1). Sudo
            
            2). Essential users and passwds
            
            
            ### What Needs to be done
            
            1). Set static IP address with [this](https://www.tecmint.com/set-add-static-ip-address-in-linux/) tutorial 
            
               a). nano /etc/network/interfaces 
            
               b). systemctl restart networking
            
            3). Reserve static IP in router
            
            2). Copy ssh keys
        EOT
}

resource "proxmox_virtual_environment_vm" "dashy" {
    node_name = "zpc"
    vm_id = 301
    name = "Dashy"

    migrate                 = true
    scsi_hardware           = "virtio-scsi-single"

    protection              = true
    tags                    = ["infra"]
    description             = local.vm_description

    cpu {
        cores      = 1
        type       = "x86-64-v2-AES"
    }

    disk {
        backup            = true
        interface         = "scsi0"
        iothread          = true
        path_in_datastore = "vm-301-disk-0"
        size              = 11
    }

    initialization {
        datastore_id = "local-lvm"
        interface    = "ide0"

        user_account {
            keys = []
            username = "zeke"
        }
    }

    memory {
        dedicated      = 2048
    }

    network_device {
        firewall     = true
        mac_address  = "BC:24:11:9B:56:AB"
    }

    operating_system {
        type = "l26"
    }
}

resource "proxmox_virtual_environment_vm" "pihole" {
    node_name = "zpc"
    vm_id = 300
    name = "Pihole"

    migrate                 = true
    scsi_hardware           = "virtio-scsi-single"

    protection              = true
    tags                    = ["infra"]
    description             = "Set the router DNS to this IP address and it should work on all devices. For some reason with the current router it doesn't but that's how it goes I guess."
    
    cpu {
        cores      = 2
        type       = "x86-64-v2-AES"
    }

    disk {
        backup            = true
        interface         = "scsi0"
        iothread          = true
        path_in_datastore = "vm-300-disk-0"
        size              = 10
    }

    initialization {
        datastore_id = "local-lvm"
        interface    = "ide0"

        user_account {
            keys = []
            username = "zeke"
        }
    }

    memory {
        dedicated      = 4096
    }

    network_device {
        firewall     = true
        mac_address  = "BC:24:11:06:21:9E"
    }

    operating_system {
        type = "l26"
    }
}

resource "proxmox_virtual_environment_vm" "monitor" {
    node_name = "zpc"
    vm_id = 302
    name = "Monitor"

    migrate                 = true
    scsi_hardware           = "virtio-scsi-single"

    protection              = true
    tags                    = ["kubernetes"]

    cpu {
        cores      = 3
        type       = "x86-64-v2-AES"
    }

    disk {
        backup            = true
        interface         = "scsi0"
        datastore_id      = "hdd"
        iothread          = true
        path_in_datastore = "vm-302-disk-0"
        size              = 32
    }

    memory {
        dedicated      = 10240
    }

    network_device {
        firewall     = true
        mac_address  = "BC:24:11:4F:7F:B2"
    }

    operating_system {
        type = "l26"
    }
}

resource "proxmox_virtual_environment_vm" "longhorn" {
    node_name = "zpc"
    vm_id = 500
    name = "ZPC-Longhorn"

    migrate                 = true
    scsi_hardware           = "virtio-scsi-single"

    protection              = true
    tags                    = ["kubernetes"]

    cpu {
        cores      = 2
        type       = "x86-64-v2-AES"
    }

    disk {
        backup            = true
        interface         = "scsi0"
        datastore_id      = "hdd"
        iothread          = true
        path_in_datastore = "vm-500-disk-0"
        size              = 42
    }

    memory {
        dedicated      = 4096
    }

    network_device {
        firewall     = true
        mac_address  = "BC:24:11:4F:FE:C3"
    }

    operating_system {
        type = "l26"
    }
}
