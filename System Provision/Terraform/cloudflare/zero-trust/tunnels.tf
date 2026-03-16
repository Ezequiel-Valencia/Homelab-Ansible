

resource "cloudflare_zero_trust_tunnel_cloudflared" "homelab_tunnel" {
  account_id = var.account_id
  name = "homelab"
  config_src = "cloudflare"
}


resource "cloudflare_zero_trust_tunnel_cloudflared_config" "homelab_tunnel_config" {
  account_id = var.account_id
  tunnel_id = cloudflare_zero_trust_tunnel_cloudflared.homelab_tunnel.id
  source = "cloudflare"
  config = {
    # List of public hostname definitions, and the service tied to them
    ingress = [
    {
      hostname = "jellyfin.homelab.tunnel.ezequielvalencia.com"
      service = "http://jellyfin.media.svc.cluster.local:7026"
      origin_request = {
        no_happy_eyeballs = true # disables an algo that uses IPv4 and IPv6 in conjucture, instead only use one or the other
      }
    },
    {
      hostname = "library.homelab.tunnel.ezequielvalencia.com"
      service = "http://kavita.media.svc.cluster.local:8083"
      origin_request = {
        no_happy_eyeballs = true
      }
    },
    {
      hostname = "karakeep.tunnel.homelab.ezequielvalencia.com"
      service = "http://karakeep.tools.svc.cluster.local:80"
      origin_request = {
        no_happy_eyeballs = true
      }
    },
    {
        hostname = "ittools.tunnel.homelab.ezequielvalencia.com"
        service = "http://ittool.tools.svc.cluster.local"
        origin_request = {
        no_happy_eyeballs = true 
      }
    },
    {
        hostname = "backend.threemix.ezequielvalencia.com"
        service  = "http://three-mix.public-apps.svc.cluster.local:8080"
        origin_request = {
        no_happy_eyeballs = true 
      }
    },
    {
        hostname = "backend.ezequielvalencia.com"
        service  = "http://ezequiel-backend.public-apps.svc.cluster.local:8080"
        origin_request = {
        no_happy_eyeballs = true 
      }
    },
    {
        hostname = "openweb-ui.tunnel.homelab.ezequielvalencia.com"
        service  = "http://open-web-ui.ai.svc.cluster.local:8080"
        origin_request = {
        no_happy_eyeballs = true 
      }
    },
    {
        hostname = "n8n.tunnel.homelab.ezequielvalencia.com"
        service  = "http://n8n.ai.svc.cluster.local:5678"
        origin_request = {
        no_happy_eyeballs = true 
      }
    },
    {
        hostname = "dashy.tunnel.homelab.ezequielvalencia.com"
        service  = "http://10.0.0.8:8080"
        origin_request = {
        no_happy_eyeballs = true 
      }
    },
    {
        hostname = "ctgrassroots.org"
        service  = "http://ct-grassroots.public-apps.svc.cluster.local:4000"
        origin_request = {
        no_happy_eyeballs = true 
      }
    },
    {
        hostname = "gitea.tunnel.homelab.ezequielvalencia.com"
        service  = "http://gitea.tools.svc.cluster.local"
        origin_request = {
        no_happy_eyeballs = true 
      }
    },
    {
        hostname = "openproject.tunnel.homelab.ezequielvalencia.com"
        service  = "http://openproject.tools.svc.cluster.local:80"
        origin_request = {
        no_happy_eyeballs = true 
      }
    },
    {
        hostname = "leantime.tunnel.homelab.ezequielvalencia.com"
        service  = "http://leantime.tools.svc.cluster.local:80"
        origin_request = {
        no_happy_eyeballs = true 
      }
    },
    {
        hostname = "home-assistant.tunnel.homelab.ezequielvalencia.com"
        service  = "https://home-assistant.homelab.ezequielvalencia.com"
        origin_request = {
          no_happy_eyeballs = true
          # Allows for 10.0.0.17 traefik reverse proxy to understand it's requesting
          # home assistant, and that the TLS works
          http_host_header = "home-assistant.homelab.ezequielvalencia.com"
          origin_server_name = "home-assistant.homelab.ezequielvalencia.com"
      }
    },
    {
        service = "http_status:404" # Applied to entire tunnel if previous hits don't match
    }
    ]
    # Config for the public hostname connection cloudflare manages as the proxy for our tunnel.
    origin_request = {
      no_happy_eyeballs = true
    },
    warp_routing = {
        enabled = false
    }
  }
}


