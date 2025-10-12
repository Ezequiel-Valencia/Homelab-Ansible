
terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.76.0"
    }
  }
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "ezequiel-hl"
    workspaces {
      name = "proxmox"
    }
  }
}


provider "proxmox" {
  endpoint = var.proxmox_api
  insecure = false # By default Proxmox Virtual Environment uses self-signed certificates.
  api_token = var.proxmox_api_token
}
