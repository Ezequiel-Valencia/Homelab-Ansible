
#! Objects !#

resource "unifi_firewall_group" "all_vms_ips" {
  name = "All VM's"
  type = "address-group"
  members = [ "10.0.0.11",
           "10.0.0.110",
           "10.0.0.12",
           "10.0.0.13",
           "10.0.0.15",
           "10.0.0.6",
           "10.0.0.7",
           "10.0.0.8",
           "10.0.0.9",]
}

resource "unifi_firewall_group" "vpn_laptop_ip" {
  name = "Laptop VPN"
  type = "address-group"
  members = [ "192.168.2.2"]
}


resource "unifi_firewall_group" "common_ports" {
  name = "DNS, HTTP, HTTPS Ports"
  type = "port-group"
  members = ["443", "80", "53"]
}


resource "unifi_firewall_group" "hl_apps" {
  name = "PiHole, Dashy, And K8 Load Balancer"
  type = "address-group"
  members = ["10.0.0.6", "10.0.0.8", "10.0.0.80"]
}


resource "unifi_firewall_group" "proxmox_ips" {
  name = "Proxmox Machines"
  type = "address-group"
  members = ["10.0.0.4", "10.0.0.5", "10.0.0.14"]
}


#! Rules !#

data "unifi_network" "general_network_data" {
  name = "General"
}

data "unifi_network" "homelab_network_data" {
  name = "Homelab"
}

resource "unifi_firewall_rule" "allow_hl_apps_to_general" {
  name = "Allow General Network To PiHole/Dashy/K8 LB"
  action = "accept"
  ruleset = "LAN_IN"

    # hl_apps and common_ports
  dst_firewall_group_ids = [unifi_firewall_group.hl_apps.id, unifi_firewall_group.common_ports.id]

  rule_index = "20000"
  protocol = "all"

  src_network_id = data.unifi_network.general_network_data.id
}

resource "unifi_firewall_rule" "block_all_trafic_to_hl_network" {
  name = "Block All Traffic to Homelab Network"
  ruleset = "LAN_IN"
  action = "drop"
  rule_index = "20001"

  # Not setting src means all is dropped
  protocol = "all"
  dst_network_id = data.unifi_network.homelab_network_data.id
}

resource "unifi_firewall_rule" "block_all_trafic_from_vms_to_proxmox" {
  name = "DROP All Traffic From VM's to Proxmox Machines"
  ruleset = "LAN_IN"
  action = "drop"
  rule_index = "20002"

  protocol = "all"
  dst_firewall_group_ids = [unifi_firewall_group.proxmox_ips.id] # Proxmox Machines
  src_firewall_group_ids = [unifi_firewall_group.all_vms_ips.id] # All VM's
}

resource "unifi_firewall_rule" "allow_vpn_laptop_access_to_hl" {
  name = "Allow VPN Laptop Access To HL"
  ruleset = "LAN_IN"
  action = "accept"
  rule_index = "20003"

  protocol = "all"
  dst_firewall_group_ids = [unifi_firewall_group.hl_apps.id, unifi_firewall_group.common_ports.id]
  src_firewall_group_ids = [unifi_firewall_group.vpn_laptop_ip.id]
}


