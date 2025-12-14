
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


#! Alienware !#
import {
  id = "alienware/203"
  to = proxmox_virtual_environment_vm.bots
}

import {
  id = "alienware/304"
  to = proxmox_virtual_environment_vm.k3s_control
}

import {
  id = "alienware/600"
  to = proxmox_virtual_environment_vm.media
}

