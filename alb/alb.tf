#ALB

resource "aws_lb_target_group" "alb-target" {
  vpc_id   = aws_vpc.my_vpc.id
  name     = "alb-target"
  port     = 80
  protocol = "HTTP"
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.project-ec2-asg.name
  lb_target_group_arn   = aws_lb_target_group.alb-target.arn
}

data "aws_subnet" "subnet-pub-1" {
  id = aws_subnet.public_subnet1.id
}
data "aws_subnet" "subnet-pub-2" {
  id = aws_subnet.public_subnet2.id
}

resource "aws_lb" "project" {
  name               = "var.alb_name"

  subnets            = [data.aws_subnet.subnet-pub-1.id, data.aws_subnet.subnet-pub-2.id]
    security_groups     = [aws_security_group.bastion_sg.id]
}

resource "aws_lb_listener" "class" {
  load_balancer_arn = aws_lb.project.arn
  port              = 80
  protocol          = "HTTP"
 
  default_action {
    target_group_arn = aws_lb_target_group.alb-target.arn
    type             = "forward"
  }
}