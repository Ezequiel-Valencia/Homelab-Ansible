
# Drift detection: https://developer.hashicorp.com/terraform/tutorials/cloud/drift-detection

###################
# Compute/Storage #
###################

resource "aws_instance" "web" {
  ami           = var.debian_image_id
  instance_type = "t3.micro"
  availability_zone = var.availability_zone

  key_name = data.aws_key_pair.ezq_ssh_keys.key_name

  tags = {
    Name = "CTGrassRoots"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    encrypted = true
    volume_size = 10 # GiB
    volume_type = "standard"
    kms_key_id = aws_kms_key.encryption_key.key_id
  }

  # network_interface {
  #   device_index = 0
  #   network_interface_id = aws_network_interface.ct_grassroots_interface.id
  # }

  subnet_id = aws_subnet.grassroots_subnet.id

  vpc_security_group_ids = [
    aws_security_group.basic_web_server.id
  ]

#   instance_market_options {
#     market_type = "spot"
#     spot_options {
      
#     }
#   }

  credit_specification {
    cpu_credits = "standard"
  }

  tenancy = "default"
}
