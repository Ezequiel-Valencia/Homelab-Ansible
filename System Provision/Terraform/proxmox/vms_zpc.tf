
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
    on_boot                 = true
    reboot                  = false
    started                 = true
    reboot_after_update     = true

    bios                    = "seabios"
    scsi_hardware           = "virtio-scsi-single"
    acpi                    = true // power settings cli https://www.geeksforgeeks.org/acpi-command-in-linux-with-examples/
    template                = false

    stop_on_destroy         = false
    tablet_device           = true

    protection              = true
    keyboard_layout         = "en-us"
    tags                    = ["infra"]
    description             = local.vm_description

    timeout_clone           = 1800
    timeout_create          = 1800
    timeout_migrate         = 1800
    timeout_reboot          = 1800
    timeout_shutdown_vm     = 1800
    timeout_start_vm        = 1800
    timeout_stop_vm         = 300
    

    cpu {
        cores      = 1
        flags      = [] 
        hotplugged = 0
        limit      = 0
        numa       = false
        sockets    = 1
        type       = "x86-64-v2-AES"
        units      = 1024
    }

    disk {
        aio               = "io_uring"
        backup            = true
        cache             = "none"
        datastore_id      = "local-lvm"
        discard           = "ignore"
        file_format       = "raw"
        interface         = "scsi0"
        iothread          = true
        path_in_datastore = "vm-301-disk-0"
        replicate         = true
        size              = 11
        ssd               = false
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
        floating       = 0
        keep_hugepages = false
        shared         = 0
    }

    network_device {
        bridge       = "vmbr0"
        disconnected = false
        enabled      = true
        firewall     = true
        mac_address  = "BC:24:11:9B:56:AB"
        model        = "virtio"
        mtu          = 0
        queues       = 0
        rate_limit   = 0
        vlan_id      = 0
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
    on_boot                 = true
    reboot                  = false
    started                 = true
    reboot_after_update     = true

    bios                    = "seabios"
    scsi_hardware           = "virtio-scsi-single"
    acpi                    = true // power settings cli https://www.geeksforgeeks.org/acpi-command-in-linux-with-examples/
    template                = false

    stop_on_destroy         = false
    tablet_device           = true

    protection              = true
    keyboard_layout         = "en-us"
    tags                    = ["infra"]
    description             = "Set the router DNS to this IP address and it should work on all devices. For some reason with the current router it doesn't but that's how it goes I guess."

    timeout_clone           = 1800
    timeout_create          = 1800
    timeout_migrate         = 1800
    timeout_reboot          = 1800
    timeout_shutdown_vm     = 1800
    timeout_start_vm        = 1800
    timeout_stop_vm         = 300
    

    cpu {
        cores      = 1
        flags      = [] 
        hotplugged = 0
        limit      = 0
        numa       = false
        sockets    = 1
        type       = "x86-64-v2-AES"
        units      = 1024
    }

    disk {
        aio               = "io_uring"
        backup            = true
        cache             = "none"
        datastore_id      = "local-lvm"
        discard           = "ignore"
        file_format       = "raw"
        interface         = "scsi0"
        iothread          = true
        path_in_datastore = "vm-300-disk-0"
        replicate         = true
        size              = 10
        ssd               = false
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
        floating       = 0
        keep_hugepages = false
        shared         = 0
    }

    network_device {
        bridge       = "vmbr0"
        disconnected = false
        enabled      = true
        firewall     = true
        mac_address  = "BC:24:11:06:21:9E"
        model        = "virtio"
        mtu          = 0
        queues       = 0
        rate_limit   = 0
        vlan_id      = 0
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
    on_boot                 = true
    reboot                  = false
    started                 = true
    reboot_after_update     = true

    bios                    = "seabios"
    scsi_hardware           = "virtio-scsi-single"
    acpi                    = true // power settings cli https://www.geeksforgeeks.org/acpi-command-in-linux-with-examples/
    template                = false

    stop_on_destroy         = false
    tablet_device           = true

    protection              = true
    keyboard_layout         = "en-us"
    tags                    = ["infra"]

    timeout_clone           = 1800
    timeout_create          = 1800
    timeout_migrate         = 1800
    timeout_reboot          = 1800
    timeout_shutdown_vm     = 1800
    timeout_start_vm        = 1800
    timeout_stop_vm         = 300
    

    cpu {
        cores      = 2
        flags      = [] 
        hotplugged = 0
        limit      = 0
        numa       = false
        sockets    = 1
        type       = "x86-64-v2-AES"
        units      = 1024
    }

    disk {
        aio               = "io_uring"
        backup            = true
        cache             = "none"
        datastore_id      = "hdd"
        discard           = "ignore"
        file_format       = "raw"
        interface         = "scsi0"
        iothread          = true
        path_in_datastore = "vm-302-disk-0"
        replicate         = true
        size              = 32
        ssd               = false
    }

    memory {
        dedicated      = 8192
        floating       = 0
        keep_hugepages = false
        shared         = 0
    }

    network_device {
        bridge       = "vmbr0"
        disconnected = false
        enabled      = true
        firewall     = true
        mac_address  = "BC:24:11:4F:7F:B2"
        model        = "virtio"
        mtu          = 0
        queues       = 0
        rate_limit   = 0
        vlan_id      = 0
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
    on_boot                 = true
    reboot                  = false
    started                 = true
    reboot_after_update     = true

    bios                    = "seabios"
    scsi_hardware           = "virtio-scsi-single"
    acpi                    = true // power settings cli https://www.geeksforgeeks.org/acpi-command-in-linux-with-examples/
    template                = false

    stop_on_destroy         = false
    tablet_device           = true

    protection              = true
    keyboard_layout         = "en-us"
    tags                    = ["infra"]

    timeout_clone           = 1800
    timeout_create          = 1800
    timeout_migrate         = 1800
    timeout_reboot          = 1800
    timeout_shutdown_vm     = 1800
    timeout_start_vm        = 1800
    timeout_stop_vm         = 300
    

    cpu {
        cores      = 2
        flags      = [] 
        hotplugged = 0
        limit      = 0
        numa       = false
        sockets    = 1
        type       = "x86-64-v2-AES"
        units      = 1024
    }

    disk {
        aio               = "io_uring"
        backup            = true
        cache             = "none"
        datastore_id      = "hdd"
        discard           = "ignore"
        file_format       = "raw"
        interface         = "scsi0"
        iothread          = true
        path_in_datastore = "vm-500-disk-0"
        replicate         = true
        size              = 42
        ssd               = false
    }

    disk {
        aio               = "io_uring"
        backup            = true
        cache             = "none"
        datastore_id      = "hdd"
        discard           = "ignore"
        file_format       = "raw"
        interface         = "scsi1"
        iothread          = true
        path_in_datastore = "vm-500-disk-1"
        replicate         = true
        size              = 32
        ssd               = false
    }

    memory {
        dedicated      = 4096
        floating       = 0
        keep_hugepages = false
        shared         = 0
    }

    network_device {
        bridge       = "vmbr0"
        disconnected = false
        enabled      = true
        firewall     = true
        mac_address  = "BC:24:11:4F:FE:C3"
        model        = "virtio"
        mtu          = 0
        queues       = 0
        rate_limit   = 0
        vlan_id      = 0
    }

    operating_system {
        type = "l26"
    }
}
