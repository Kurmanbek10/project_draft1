variable "ec2_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "defualt instance type"
}

variable "ec2_name" {
  type        = string
  default     = "EC2-Bastion-Host"
  description = "ec2 name"
}

variable "ec2_ami_id" {
  type        = string
  default     = "ami-0277155c3f0ab2930"
  description = "AMI id for us-east-1"
}
