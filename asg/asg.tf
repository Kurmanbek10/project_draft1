#ASG
resource "aws_autoscaling_group" "project-ec2-asg" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 3
  max_size           = 5
  min_size           = 1

  launch_template {
    id      = aws_launch_template.project_launch_template.id
    version = "$Latest"
  }
}

#Launch Template
resource "aws_launch_template" "project_launch_template" {
 
  description    = "Example Launch Template"
  
  image_id = "ami-0277155c3f0ab2930"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.private_subnet1.id
    security_groups             = [aws_security_group.bastion_sg.id]
  }
  

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "PrivateInstanceWeb"
    }
  }
  user_data = filebase64("web-script.sh")
}