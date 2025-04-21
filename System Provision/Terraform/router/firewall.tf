
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
  dst_firewall_group_ids = ["6727f20dc09f535d51c4a4d6", "672fd921f2657274a3bf4404",]

  rule_index = "20000"
  protocol = "all"

  src_network_id = data.unifi_network.general_network_data.id
}

resource "unifi_firewall_rule" "block_all_trafic_to_hl_network" {
  name = "Block All General Traffic to Homelab Network"
  ruleset = "LAN_IN"
  action = "drop"
  rule_index = "20001"

  protocol = "all"
  dst_network_id = data.unifi_network.homelab_network_data.id
  src_network_id = data.unifi_network.general_network_data.id
}

resource "unifi_firewall_rule" "block_all_trafic_from_vms_to_proxmox" {
  name = "DROP All Traffic From VM's to Proxmox Machines"
  ruleset = "LAN_IN"
  action = "drop"
  rule_index = "20002"

  protocol = "all"
  dst_firewall_group_ids = ["672fc97bf2657274a3bf40b4"] # Proxmox Machines
  src_firewall_group_ids = ["672fc948f2657274a3bf40af"] # All VM's
}


