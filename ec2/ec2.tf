#Creating an EC2
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/known_hosts")
}

resource "aws_instance" "Bastion" {
  ami               = "var.ec2_ami_id"
  key_name          = aws_key_pair.deployer.key_name
  instance_type     = "var.ec2_instance_type"
  subnet_id         = aws_subnet.public_subnet1.id
  availability_zone = "us-east-1a"
  security_groups   = [aws_security_group.bastion_sg.id]
  tags = {
    Name = "var.ec2_name"
  }

  associate_public_ip_address = true
   iam_instance_profile = aws_iam_instance_profile.role_profile.name
  user_data                   = filebase64("./web-script.sh")
}

#Security group for BASTION HOST
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.my_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "BastionSG"
  }
}