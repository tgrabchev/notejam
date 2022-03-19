#Creating the ELB
resource "aws_elb" "custom-elb" {
    name = "custom-elb"
    subnets = [aws_subnet.web-subnet-1.id,aws_subnet.web-subnet-2.id]
    security_groups = [aws_security_group.custom-elb-sg.id]

    listener {
        instance_port      = 80
        instance_protocol  = "http"
        lb_port            = 80
        lb_protocol        = "http"
  }

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "HTTP:80/"
        interval            = 30
  }

  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 400
}

# Creating the Security Group for the ELB
resource "aws_security_group" "custom-elb-sg" {
  name        = "Custom-ELB-SG"
  description = "Allow inbound traffic from ALB"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description     = "Allow traffic from web layer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    # cidr_blocks = ["0.0.0.0/0"] I used the whole range for testing if needed this can be enabled and set with the proper CIDR block range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Custom-ELB-SG"
  }
}

#Security Group for the EC2 instances
resource "aws_security_group" "custom-instance-sg" {
  name        = "Custom-Instances-SG"
  description = "Allow inbound traffic from ALB"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description     = "Allow traffic from web layer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    # cidr_blocks = ["0.0.0.0/0"] I used the whole range for testing if needed this can be enabled and set with the proper CIDR block range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Custom-ELB-SG"
  }
}