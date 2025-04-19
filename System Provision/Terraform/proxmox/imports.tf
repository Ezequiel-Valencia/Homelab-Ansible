
#######
# VMs #
#######


#! ZPC !#
import {
  id = "zpc/301"
  to = proxmox_virtual_environment_vm.dashy
}

import {
  id = "zpc/300"
  to = proxmox_virtual_environment_vm.pihole
}

import {
  id = "zpc/302"
  to = proxmox_virtual_environment_vm.monitor
}

import {
  id = "zpc/500"
  to = proxmox_virtual_environment_vm.longhorn
}
