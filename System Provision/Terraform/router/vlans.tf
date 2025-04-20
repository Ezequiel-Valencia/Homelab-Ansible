

resource "unifi_network" "general" {
    name                         = "General"
    network_group                = "LAN"
    purpose                      = "corporate"
    site                         = "default"
    subnet                       = "10.0.1.0/24" 
    vlan_id                      = 2

    dhcp_enabled                 = true
    dhcpd_boot_enabled           = false
    dhcp_relay_enabled           = false

    dhcp_v6_dns_auto             = true
    dhcp_v6_enabled              = false 
    
    dhcp_lease                   = 86400
    dhcp_v6_lease                = 86400
    
    dhcp_start                   = "10.0.1.6" 
    dhcp_stop                    = "10.0.1.254"
    dhcp_v6_start                = "::2" 
    dhcp_v6_stop                 = "::7d1" 
    dhcp_dns                     = []
    dhcp_v6_dns                  = [] 
    
    igmp_snooping                = true 
    internet_access_enabled      = true
    intra_network_access_enabled = true

    ipv6_interface_type          = "none"
    ipv6_pd_start                = "::2" 
    ipv6_pd_stop                 = "::7d1" 
    ipv6_ra_enable               = true 
    ipv6_ra_preferred_lifetime   = 14400
    ipv6_ra_priority             = "high" 
    ipv6_ra_valid_lifetime       = 0

    multicast_dns                = true
}


resource "unifi_network" "homelab" {
    name                         = "Homelab"
    network_group                = "LAN"
    purpose                      = "corporate"
    site                         = "default"
    subnet                       = "10.0.0.0/24" 
    vlan_id                      = 0
    domain_name                  = "localdomain"

    dhcp_enabled                 = true
    dhcpd_boot_enabled           = false
    dhcp_relay_enabled           = false

    dhcp_v6_dns_auto             = true
    dhcp_v6_enabled              = false 
    
    dhcp_lease                   = 86400
    dhcp_v6_lease                = 86400
    
    dhcp_start                   = "10.0.0.6" 
    dhcp_stop                    = "10.0.0.254"
    dhcp_v6_start                = "::2" 
    dhcp_v6_stop                 = "::7d1" 
    dhcp_dns                     = []
    dhcp_v6_dns                  = [] 
    
    igmp_snooping                = true 
    internet_access_enabled      = true
    intra_network_access_enabled = true

    ipv6_interface_type          = "none"
    ipv6_pd_start                = "::2" 
    ipv6_pd_stop                 = "::7d1" 
    ipv6_ra_enable               = true 
    ipv6_ra_preferred_lifetime   = 14400
    ipv6_ra_priority             = "high" 
    ipv6_ra_valid_lifetime       = 0

    multicast_dns                = true
}

