##############
# Networking #
##############
resource "aws_vpc" "public_services" {
  cidr_block = "10.0.0.0/24"
  instance_tenancy = "default"
  tags = {
    Name = "public-services"
  }
}

resource "aws_subnet" "grassroots_subnet" {
    vpc_id = aws_vpc.public_services.id
    cidr_block = "10.0.0.16/28"
    availability_zone = var.availability_zone
    tags = {
      Name: "grassroots_subnet"
      Component: "public-services"
    }
}

# resource "aws_network_interface" "ct_grassroots_interface" {
#   subnet_id = aws_subnet.grassroots_subnet.id
#   private_ip = "10.0.0.17"
#   tags = {
#     Name: "grassroots_interface"
#   }
# }

resource "aws_internet_gateway" "public_services_gateway" {
  vpc_id = aws_vpc.public_services.id
  tags = {
    Name = "publice-services-gateway"
  }
}

resource "aws_security_group" "basic_web_server" {
    name = "basic_web_server"
    vpc_id = aws_vpc.public_services.id

    # If it gets in, allow all of it to get out
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 0
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 0
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Required beacause deleting a security group is tricky
    lifecycle {
      create_before_destroy = true 
    }
    timeouts {
      delete = "2m"
    }
}