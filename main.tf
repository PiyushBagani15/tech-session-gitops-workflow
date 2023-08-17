
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