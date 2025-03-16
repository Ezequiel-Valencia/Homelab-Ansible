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

variable "apps_tunnel_id" {
  description = "Unique ID for Tunnel"
  default = "19cc0bb3-b107-4555-9c55-c0882b6f5ae7"
}

# Manually Created Ahead of Time
variable "homelab_tunnel_id" {
  description = "Unique ID for Tunnel"
  default = "699ef197-56b5-40cc-b4dd-6aa7bd4cb84c"
}

provider "cloudflare" {
  api_token = var.provided_api_token
}

