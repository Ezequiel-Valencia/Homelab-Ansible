

# Import Tunnel
# import {
#     id = "<cloudflare application id>/699ef197-56b5-40cc-b4dd-6aa7bd4cb84c"
#     to = cloudflare_zero_trust_tunnel_cloudflared.homelab_tunnel
# }


# Import Tunnel Config
# import {
#     id = "<cloudflare application id>/699ef197-56b5-40cc-b4dd-6aa7bd4cb84c"
#     to = cloudflare_zero_trust_tunnel_cloudflared_config.homelab_tunnel_config
# }


################
# DNS Records  #
# ID format: ${var.zone_id}/<dns_record_id>
# DNS record IDs can be found via: Cloudflare Dashboard > DNS > Records, or via API/CLI
# Look up each DNS record ID from the Cloudflare dashboard (DNS > Records) or via the API:
#   curl -X GET "https://api.cloudflare.com/client/v4/zones/<zone_id>/dns_records" \
#     -H "Authorization: Bearer <token>"
################

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.jellyfin
# }

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.library
# }

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.karakeep
# }

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.ittools
# }

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.threemix-backend
# }

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.backend
# }

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.openweb-ui
# }

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.n8n
# }

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.dashy
# }

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.gitea
# }

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.openproject
# }

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.leantime
# }

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.home-assistant
# }

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.joplin
# }

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.authentik
# }

# import {
#   id = "${var.zone_id}/<dns_id>"
#   to = cloudflare_dns_record.mealie
# }

