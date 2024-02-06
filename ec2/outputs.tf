# Output the public name of the EC2 instance
output "ec2_instance_name" {
  value = aws_instance.my_instance.tags["Name"]
}

# Output the public IP address of the EC2 instance
output "ec2_public_ip" {
  value = aws_instance.my_instance.public_ip
}

# Output the public id of the EC2 instance
output "ec2_instance_id" {
  value = aws_instance.Bastion.id
}