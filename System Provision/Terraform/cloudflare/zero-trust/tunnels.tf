
######################################################
# Currently Doesn't Work and Error Feedback is Vauge #
# In future can fix it.                              #
######################################################


# resource "cloudflare_zero_trust_tunnel_cloudflared_config" "example_zero_trust_tunnel_cloudflared_config" {
#   account_id = var.account_id
#   tunnel_id = var.apps_tunnel_id
#   config = {
#     # List of public hostname definitions, and the service tied to them
#     ingress = [{
#       hostname = "backend.threemix.ezequielvalencia.com"
#       service = "http://three-mix.public-apps.svc.cluster.local:8080"
#       origin_request = {
#         no_happy_eyeballs = true # disables an algo that uses IPv4 and IPv6 in conjucture, instead only use one or the other
#       }
#     }]
#     # Config for the public hostname connection cloudflare manages as the proxy for our tunnel.
#     origin_request = {
#       no_happy_eyeballs = true
#     }
#   }
# }


