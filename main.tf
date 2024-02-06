# Use the VPC module
module "vpc" {
  source          = "./vpc"
  vpc_cidr_block  = "10.0.0.0/24"
}

# Use the ASG module
module "asg" {
  source = "./asg"
  # Set variables for ASG module as needed.
}

# Use the ALB module
module "alb" {
  source = "./alb"
  vpc_id = module.vpc.vpc_id
  # Set variables for ALB module as needed.
}

# Use the EC2 module
module "ec2" {
  source           = "./ec2"
  public_subnet_id = module.vpc.aws_subnet.public_subnet1.id  # Replace with your actual public subnet ID
  bastion_sg_id    = module.vpc.bastion_sg_id     # Replace with your actual security group ID
  # Set variables for EC2 module as needed.
}

# Use the IAM role module
module "role" {
  source = "./role"
  # Set variables for IAM role module as needed.
}