
data "aws_ami" "linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "tf-cloud-instance" {
  ami           = data.aws_ami.linux.id
  instance_type = var.instance_type

  tags = {
    Name = "${var.instance_name}-${var.environment}"
  }
}

module "service_sg" {
  source  = "app.terraform.io/tech-session-demo/security-group/aws"
  version = "4.17.2"

  name        = "${var.environment}-sg"
  description = "Security group for user-service with custom ports open within VPC."

  ingress_cidr_blocks      = ["10.10.0.0/16"]
  ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.10.0.0/16"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "s3-bucket" {
  source  = "app.terraform.io/tech-session-demo/s3-bucket/aws"
  version = "3.14.1"
  bucket = "s3-bucket-aws-${var.environment}"
}