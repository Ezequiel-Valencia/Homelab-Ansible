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
      name = "zone-management"
    }
  }
}


#####################################################################
# Variables are retrieved from backend, ezequiel-hl:zone-management #
#####################################################################

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

