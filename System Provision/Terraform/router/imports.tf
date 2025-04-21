

# data "unifi_network" "network" {
#   name = "Homelab"
# }

# output "network_data" {
#   value = data.unifi_network.network
# }

# data "unifi_ap_group" "default" {

# }
# output "default" {
#   value = data.unifi_ap_group.default
# }

#! Networks !#
import {
  id = "6727e20dc09f535d51c4a0f5"
  to = unifi_network.general
}

import {
  id = "67268d57bcc1276029b9b35f"
  to = unifi_network.homelab
}


#! Network Objects !#
import {
  id = "672fc948f2657274a3bf40af"
  to = unifi_firewall_group.all_vms_ips
}

import {
  id = "672fd921f2657274a3bf4404"
  to = unifi_firewall_group.common_ports
}

import {
  id = "6727f20dc09f535d51c4a4d6"
  to = unifi_firewall_group.hl_apps
}

import {
  id = "672fc97bf2657274a3bf40b4"
  to = unifi_firewall_group.proxmox_ips
}

#! Firewall Rules !#

import {
  id = "6727f3e0c09f535d51c4a564"
  to = unifi_firewall_rule.allow_hl_apps_to_general
}

import {
  id = "6727f413c09f535d51c4a569"
  to = unifi_firewall_rule.block_all_trafic_to_hl_network
}

import {
  id = "672fc9e8f2657274a3bf40c0"
  to = unifi_firewall_rule.block_all_trafic_from_vms_to_proxmox
}
