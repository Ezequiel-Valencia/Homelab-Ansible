
resource "proxmox_virtual_environment_vm" "bots" {
    node_name = "alienware"
    vm_id = 203
    name = "Bots"

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
    tags                    = ["sen"]

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
        datastore_id      = "local-lvm"
        discard           = "ignore"
        file_format       = "raw"
        interface         = "scsi0"
        iothread          = true
        path_in_datastore = "vm-203-disk-0"
        replicate         = true
        size              = 32
        ssd               = false
    }

    memory {
        dedicated      = 6144
        floating       = 0
        keep_hugepages = false
        shared         = 0
    }

    network_device {
        bridge       = "vmbr0"
        disconnected = false
        enabled      = true
        firewall     = true
        mac_address  = "BC:24:11:E6:C1:FB"
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


resource "proxmox_virtual_environment_vm" "k3s_control" {
    node_name = "alienware"
    vm_id = 304
    name = "K3s-Control"

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
        datastore_id      = "local-lvm"
        discard           = "ignore"
        file_format       = "raw"
        interface         = "scsi0"
        iothread          = true
        path_in_datastore = "vm-304-disk-0"
        replicate         = true
        size              = 32
        ssd               = false
    }

    memory {
        dedicated      = 6144
        floating       = 0
        keep_hugepages = false
        shared         = 0
    }

    network_device {
        bridge       = "vmbr0"
        disconnected = false
        enabled      = true
        firewall     = true
        mac_address  = "BC:24:11:B8:B2:34"
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

resource "proxmox_virtual_environment_vm" "media" {
    node_name = "alienware"
    vm_id = 600
    name = "Media"

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
    tags                    = ["entertain"]

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
        datastore_id      = "local-lvm"
        discard           = "ignore"
        file_format       = "raw"
        interface         = "scsi0"
        iothread          = true
        path_in_datastore = "vm-600-disk-0"
        replicate         = true
        size              = 36
        ssd               = false
    }

    agent {
      enabled = false
      timeout = "15m"
      trim = false
      type = "virtio"
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
        path_in_datastore = "vm-600-disk-0"
        replicate         = true
        size              = 500
        ssd               = false
    }

    memory {
        dedicated      = 10240
        floating       = 0
        keep_hugepages = false
        shared         = 0
    }

    network_device {
        bridge       = "vmbr0"
        disconnected = false
        enabled      = true
        firewall     = true
        mac_address  = "BC:24:11:D4:55:9F"
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


