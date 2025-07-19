terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46.0"
    }
  }
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "ezequiel-hl"
    workspaces {
      name = "public-services-vpc"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_key_pair" "ezq_ssh_keys" {
  filter {
    name   = "tag:Component"
    values = ["public-services"]
  }
}

data "aws_caller_identity" "current" {
  
}

variable "debian_image_id" {
  type = string
  default = "ami-0779caf41f9ba54f0"
}

variable "availability_zone" {
  type = string
  default = "us-east-1a"
}


