terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "ezequiel-hl"
    workspaces {
      name = "zero-trust"
    }
  }
}


################################################################
# Variables are retrieved from backend, ezequiel-hl:zero-trust #
################################################################

variable "provided_api_token" {
    sensitive = true
    description = "Token which grants terraform access."
    type = string
}

variable "zone_id" {
    sensitive = true
    description = "Zone working in"
    type = string
}

variable "account_id" {
    sensitive = true
    description = "Owner account ID"
    type = string
}

provider "cloudflare" {
  api_token = var.provided_api_token
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
  tags = ["public apps"]
}