
resource "proxmox_virtual_environment_vm" "true_nas" {
    node_name = "PC"
    vm_id = 201
    name = "TrueNAS"

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
        cores      = 4
        flags      = [] 
        hotplugged = 0
        limit      = 0
        numa       = false
        sockets    = 1
        type       = "qemu64"
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
        path_in_datastore = "vm-201-disk-0"
        replicate         = true
        size              = 20
        ssd               = false
    }

    disk {
        aio               = "io_uring"
        backup            = false
        cache             = "none"
        datastore_id      = ""
        discard           = "ignore"
        interface         = "scsi1"
        iothread          = false
        path_in_datastore = "/dev/disk/by-id/ata-ST4000VN006-3CW104_ZW602BKF"
        serial            = "ZW602BKF"
        replicate         = true
        size              = 3726
        ssd               = false
    }

    disk {
        aio               = "io_uring"
        backup            = false
        cache             = "none"
        datastore_id      = ""
        discard           = "ignore"
        interface         = "scsi2"
        iothread          = false
        path_in_datastore = "/dev/disk/by-id/ata-ST4000VN006-3CW104_ZW604VDD"
        serial            = "ZW604VDD"
        replicate         = true
        size              = 3726
        ssd               = false
    }

    memory {
        dedicated      = 16384
        floating       = 0
        keep_hugepages = false
        shared         = 0
    }

    network_device {
        bridge       = "vmbr0"
        disconnected = false
        enabled      = true
        firewall     = true
        mac_address  = "CE:AE:9C:32:38:C9"
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