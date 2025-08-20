
############
# Policies #
############

resource "cloudflare_zero_trust_access_policy" "only_us_ips" {
  account_id = var.account_id
  decision = "allow"
  include = [{
    geo = {
      country_code = "US"
    }
  }]
  name = "Allow only US IPs"
  isolation_required = false # Does not need special browser
}


resource "cloudflare_zero_trust_access_policy" "bypass_cloudflare_login" {
  account_id = var.account_id
  decision = "bypass"
  include = [{
    everyone = {}
  }]
  name = "Bypass Cloudflare Login"
  isolation_required = false # Does not need special browser
}

########
# Tags #
########

resource "cloudflare_zero_trust_access_tag" "ai_tag" {
  account_id = var.account_id
  name = "ai"
}

resource "cloudflare_zero_trust_access_tag" "tool_tag" {
  account_id = var.account_id
  name = "tool"
}

##################################################################################
# In order to skip Cloudflares login pop-up need to apply Bypass Policy Manually #
##################################################################################

resource "cloudflare_zero_trust_access_application" "threemix-backend" {
    depends_on = [ cloudflare_zero_trust_access_policy.bypass_cloudflare_login ]
  domain = "backend.threemix.ezequielvalencia.com"
  type = "self_hosted"
  account_id = var.account_id

  enable_binding_cookie = true # Mitigation against CSRF, https://developers.cloudflare.com/cloudflare-one/identity/authorization-cookie/
  http_only_cookie_attribute = true
  name = "Threemix Backend"

  session_duration = "24h"
  skip_interstitial = true
  tags = ["public apps", "homelab"]
}



resource "cloudflare_zero_trust_access_application" "homelab-jellyfin" {
    depends_on = [ cloudflare_zero_trust_access_policy.only_us_ips ]
  domain = "jellyfin.homelab.ezequielvalencia.com"
  type = "self_hosted"
  account_id = var.account_id

  enable_binding_cookie = true # Mitigation against CSRF, https://developers.cloudflare.com/cloudflare-one/identity/authorization-cookie/
  http_only_cookie_attribute = true
  name = "Jellyfin"

  session_duration = "24h"
  skip_interstitial = true
  tags = ["homelab", "media"] # Need to create tags manually beforehand 
}

resource "cloudflare_zero_trust_access_application" "library-jellyfin" {
    depends_on = [ cloudflare_zero_trust_access_policy.only_us_ips ]
  domain = "library.homelab.ezequielvalencia.com"
  type = "self_hosted"
  account_id = var.account_id

  enable_binding_cookie = true # Mitigation against CSRF, https://developers.cloudflare.com/cloudflare-one/identity/authorization-cookie/
  http_only_cookie_attribute = true
  name = "Library"

  session_duration = "24h"
  skip_interstitial = true
  tags = ["homelab", "media"] # Need to create tags manually beforehand 
}



resource "cloudflare_zero_trust_access_application" "open-web" {
  depends_on = [ cloudflare_zero_trust_access_policy.only_us_ips ]
  domain = "open-web.tunnel.homelab.ezequielvalencia.com"
  type = "self_hosted"
  account_id = var.account_id

  enable_binding_cookie = true # Mitigation against CSRF, https://developers.cloudflare.com/cloudflare-one/identity/authorization-cookie/
  http_only_cookie_attribute = true
  name = "OpenWeb UI"
  policies = [ {
    id = cloudflare_zero_trust_access_policy.bypass_cloudflare_login.id
  } ]

  session_duration = "24h"
  skip_interstitial = true
  tags = ["homelab", "ai"] # Need to create tags manually beforehand 
}

resource "cloudflare_zero_trust_access_application" "n8n" {
  depends_on = [ cloudflare_zero_trust_access_policy.only_us_ips ]
  domain = "n8n.tunnel.homelab.ezequielvalencia.com"
  type = "self_hosted"
  account_id = var.account_id

  enable_binding_cookie = true # Mitigation against CSRF, https://developers.cloudflare.com/cloudflare-one/identity/authorization-cookie/
  http_only_cookie_attribute = true
  name = "N8N"
  policies = [ {
    id = cloudflare_zero_trust_access_policy.bypass_cloudflare_login.id
  } ]

  session_duration = "24h"
  skip_interstitial = true
  tags = ["homelab", "ai"] # Need to create tags manually beforehand 
}

resource "cloudflare_zero_trust_access_application" "karakeep" {
  depends_on = [ cloudflare_zero_trust_access_policy.only_us_ips ]
  domain = "karakeep.tunnel.homelab.ezequielvalencia.com"
  type = "self_hosted"
  account_id = var.account_id

  enable_binding_cookie = true # Mitigation against CSRF, https://developers.cloudflare.com/cloudflare-one/identity/authorization-cookie/
  http_only_cookie_attribute = true
  name = "Karakeep"
  policies = [ {
    id = cloudflare_zero_trust_access_policy.bypass_cloudflare_login.id
  } ]

  session_duration = "24h"
  skip_interstitial = true
  tags = ["homelab", "tool"] # Need to create tags manually beforehand 
}

resource "cloudflare_zero_trust_access_application" "ittools" {
  depends_on = [ cloudflare_zero_trust_access_policy.only_us_ips ]
  domain = "ittools.tunnel.homelab.ezequielvalencia.com"
  type = "self_hosted"
  account_id = var.account_id

  enable_binding_cookie = true # Mitigation against CSRF, https://developers.cloudflare.com/cloudflare-one/identity/authorization-cookie/
  http_only_cookie_attribute = true
  name = "Ittools"
  policies = [ {
    id = cloudflare_zero_trust_access_policy.bypass_cloudflare_login.id
  } ]

  session_duration = "24h"
  skip_interstitial = true
  tags = ["homelab", "tool"] # Need to create tags manually beforehand 
}

