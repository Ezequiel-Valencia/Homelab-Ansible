
# All of this seems to work for tunneled applications as well
resource "cloudflare_bot_management" "bot_management" {
  zone_id = var.zone_id
  ai_bots_protection = "block"
  enable_js = false # Don't want something this intrusive that injects JS code
  fight_mode = false # For now off because I have free tier version, https://community.cloudflare.com/t/bot-fight-mode-killed-my-api-requests/618524
}


# Extra fee if I enable it
# resource "cloudflare_zone_cache_reserve" "enable_chache_reserve" {
#   zone_id = var.zone_id
#   value = "on"
# }
