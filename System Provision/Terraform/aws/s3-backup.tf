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
      name = "s3-cold-storage"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default = "hl-app-cold-storage"
}

# Define variables
variable "max_storage_gb" {
  description = "Max storage of cold storage bucket before alarm is set off."
  type        = number
  default = 10
}


variable "iam_user_name" {
  description = "IAM user who will get access to the S3 bucket"
  type        = string
  default = "longhorn"
}

#######################
## Resource Creation ##
#######################


resource "aws_s3_bucket" "create-cold-storage-bucket" {
  bucket = var.bucket_name
}

# Set Ownership Controls (Allow ACLs) 
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.create-cold-storage-bucket.id

  rule {
    object_ownership = "ObjectWriter" # Allows ACLs to be used, https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls
  }
}

# Enable ACL, https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl

# Create an IAM policy for S3 bucket access
resource "aws_iam_policy" "s3-hl-cold-storage-policy" {
  name        = "${var.bucket_name}-access-policy"
  description = "Grants IAM user full access to the S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*"]
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })
}

# Attach the policy to the IAM user
resource "aws_iam_user_policy_attachment" "attach_policy" {
  depends_on = [ aws_iam_policy.s3-hl-cold-storage-policy ]
  user       = var.iam_user_name
  policy_arn = aws_iam_policy.s3-hl-cold-storage-policy.arn
}

# CloudWatch Metric to track bucket size
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/metrics-dimensions.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#argument-reference

resource "aws_cloudwatch_metric_alarm" "s3_storage_alarm" {
  alarm_name          = "${var.bucket_name}-storage-limit"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "BucketSizeBytes"
  namespace          = "AWS/S3"
  period             = 86400 # Check every 24 hours, set in seconds
  statistic          = "Maximum"
  threshold          = var.max_storage_gb * 1073741824 # Convert GB to Bytes
  alarm_description  = "Alert when S3 bucket exceeds ${var.max_storage_gb} GB."
  actions_enabled    = true # Action executed if any changes occur to alarm state

  dimensions = {
    BucketName = aws_s3_bucket.create-cold-storage-bucket.id
    StorageType = "StandardStorage"
  }
}


