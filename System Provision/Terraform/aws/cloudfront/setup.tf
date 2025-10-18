terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.17.0"
    }
  }
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "ezequiel-hl"
    workspaces {
      name = "cloudfront"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# CloudFront requires the origin to be specified by domain name
variable "origin_domain_name" {
  description = "The domain name of the origin API (no protocol)"
  type        = string
  default     = "backend.ezequielvalencia.com"
}