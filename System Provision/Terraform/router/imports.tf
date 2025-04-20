

# data "unifi_network" "network" {
#   name = "Homelab"
# }

# output "network_data" {
#   value = data.unifi_network.network
# }

import {
  id = "6727e20dc09f535d51c4a0f5"
  to = unifi_network.general
}

import {
  id = "67268d57bcc1276029b9b35f"
  to = unifi_network.homelab
}

