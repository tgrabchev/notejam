#Creating AWS Key Pari
resource "aws_key_pair" "mykey" {
  key_name = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)

}


# Creating Launch Template for the Autoscaling group
resource "aws_launch_configuration" "custom-launch-config" {
    name = "custom-launch-config"
    image_id = var.aws_ami
    instance_type = "t2.micro"
    key_name = aws_key_pair.mykey.key_name
    security_groups = [aws_security_group.custom-instance-sg.id]

    user_data = "#!/bin/bash\nsudo -i\namazon-linux-extras install nginx1\nsystemctl start nginx\nsudo systemctl enable nginx\necho Hello Team This Notejam Web App > /usr/share/nginx/html/index.html\nyum install git -y\nyum install pip -y\ncd /\ncd tmp\nmkdir FlaskProject\ngit clone https://github.com/nordcloud/notejam.git FlaskProject/\ncd FlaskProject/\ncd flask\npip install -r requirements.txt\npython db.py\npython runserver.py"

}

# Defining the  Autoscaling group
resource "aws_autoscaling_group" "custom-group-autoscaling" {
  name = "custom-group-autoscaling"
  vpc_zone_identifier = [aws_subnet.web-subnet-1.id,aws_subnet.web-subnet-2.id]
  launch_configuration = aws_launch_configuration.custom-launch-config.name
  min_size = 1
  max_size = 4
  desired_capacity = 2
  health_check_grace_period = 100
  health_check_type = "EC2"
  force_delete = true
  load_balancers = [
    aws_elb.custom-elb.id
  ]
}

# Define Autoscaling Configuration Policy
resource "aws_autoscaling_policy" "custom-cpu-policy" {
  name = "custom-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.custom-group-autoscaling.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 2
  cooldown = 60
  policy_type = "SimpleScaling"
}

#Defining AWS CLoud Watch Alarm for CPU
resource "aws_cloudwatch_metric_alarm" "custom-cpu-alarm" {
  alarm_name = "custom-cpu-alarm"
  alarm_description = "Alarm Once the CPU Increases"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 60
  statistic = "Average"
  threshold = 20

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.custom-group-autoscaling.name
  }
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.custom-cpu-policy.arn]

}

# Define Auto Descaling Policy
resource "aws_autoscaling_policy" "custom-cpu-policy-scaledown" {
  name = "custom-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.custom-group-autoscaling.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = -1
  cooldown = 60
  policy_type = "SimpleScaling"

}

# Define Descaling Cloud Watch Metrics for CPU Scaledown
resource "aws_cloudwatch_metric_alarm" "custom-cpu-alarm-scaledown" {
  alarm_name = "custom-cpu-alarm-scaledown"
  alarm_description = "Alarm Once the CPU Decreases"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 60
  statistic = "Average"
  threshold = 10

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.custom-group-autoscaling.name
  }
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.custom-cpu-policy-scaledown.arn]

}