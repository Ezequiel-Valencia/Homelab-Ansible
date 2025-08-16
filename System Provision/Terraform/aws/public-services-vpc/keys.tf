
########
# Key ##
########

resource "aws_kms_key" "encryption_key" {
  description = "Key used to encrypt/decrpyt public services."
  key_usage = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  tags = {
    "Component" = "public-services" 
  }
}

resource "aws_kms_key_policy" "key_policy" {
  key_id = aws_kms_key.encryption_key.key_id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}