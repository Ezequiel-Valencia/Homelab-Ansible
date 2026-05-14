
locals {
  tunnel_cname = "${cloudflare_zero_trust_tunnel_cloudflared.homelab_tunnel.id}.cfargotunnel.com"
}

##########################
# Homelab Tunnel Records #
##########################

resource "cloudflare_dns_record" "jellyfin" {
  zone_id = var.zone_id
  name    = "jellyfin.homelab.tunnel.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "library" {
  zone_id = var.zone_id
  name    = "library.homelab.tunnel.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "karakeep" {
  zone_id = var.zone_id
  name    = "karakeep.tunnel.homelab.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "ittools" {
  zone_id = var.zone_id
  name    = "ittools.tunnel.homelab.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "threemix-backend" {
  zone_id = var.zone_id
  name    = "backend.threemix.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "backend" {
  zone_id = var.zone_id
  name    = "backend.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "openweb-ui" {
  zone_id = var.zone_id
  name    = "openweb-ui.tunnel.homelab.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "n8n" {
  zone_id = var.zone_id
  name    = "n8n.tunnel.homelab.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "dashy" {
  zone_id = var.zone_id
  name    = "dashy.tunnel.homelab.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "gitea" {
  zone_id = var.zone_id
  name    = "gitea.tunnel.homelab.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "openproject" {
  zone_id = var.zone_id
  name    = "openproject.tunnel.homelab.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "leantime" {
  zone_id = var.zone_id
  name    = "leantime.tunnel.homelab.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "home-assistant" {
  zone_id = var.zone_id
  name    = "home-assistant.tunnel.homelab.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "joplin" {
  zone_id = var.zone_id
  name    = "joplin.tunnel.homelab.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "authentik" {
  zone_id = var.zone_id
  name    = "authentik.tunnel.homelab.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "mealie" {
  zone_id = var.zone_id
  name    = "mealie.tunnel.homelab.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "immich" {
  zone_id = var.zone_id
  name    = "immich.tunnel.homelab.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "navidrome" {
  zone_id = var.zone_id
  name    = "navidrome.tunnel.homelab.ezequielvalencia.com"
  type    = "CNAME"
  content = local.tunnel_cname
  proxied = true
  ttl     = 1
}

