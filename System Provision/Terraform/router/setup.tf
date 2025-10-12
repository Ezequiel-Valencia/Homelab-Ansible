
terraform {
  required_providers {
    unifi = {
      source = "paultyng/unifi"
      version = "0.41.0"
    }
  }
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "ezequiel-hl"
    workspaces {
      name = "unifi-router"
    }
  }
}


provider "unifi" {
  api_url = "https://10.0.0.1"
  allow_insecure = true
  username = "terraform"
  password = var.router_login
}
