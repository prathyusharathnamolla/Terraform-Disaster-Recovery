terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
      configuration_aliases = [aws.source, aws.destination]
    }
  }
}

resource "aws_launch_template" "source" {
  provider = aws.source

  name_prefix   = "source-app-launch-template-"
  image_id      = var.instance_ami_source
  instance_type = var.instance_type

  network_interfaces {
    security_groups = var.source_sg_ids
    subnet_id       = element(var.source_subnet_ids, 0)
  }

  user_data = base64encode(<<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Source Region Web Server</h1>" > /var/www/html/index.html
EOF
)
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "source-app-instance"
    }
  }
}


resource "aws_launch_template" "destination" {
  provider = aws.destination

  name_prefix   = "destination-app-launch-template-"
  image_id      = var.instance_ami_destination
  instance_type = var.instance_type

  network_interfaces {
    security_groups = var.destination_sg_ids
    subnet_id       = element(var.destination_subnet_ids, 0)
  }

  user_data =  base64encode(<<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<h1>Destination Region Web Server</h1>" > /var/www/html/index.html
EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "destination-app-instance"
    }
  }
}

resource "aws_autoscaling_group" "source" {
  provider            = aws.source
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.source_subnet_ids
  launch_template {
    id      = aws_launch_template.source.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "source-app-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "destination" {
  provider            = aws.destination
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.destination_subnet_ids
  launch_template {
    id      = aws_launch_template.destination.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "destination-app-asg"
    propagate_at_launch = true
  }
}

resource "aws_lb" "source" {
  provider            = aws.source
  name                = "source-app-alb"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = var.source_sg_ids
  subnets             = var.source_subnet_ids

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name = "source-app-alb"
  }
}

resource "aws_lb" "destination" {
  provider            = aws.destination
  name                = "destination-app-alb"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = var.destination_sg_ids
  subnets             = var.destination_subnet_ids

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name = "destination-app-alb"
  }
}

resource "aws_lb_target_group" "source" {
  provider     = aws.source
  name         = "source-target-group"
  port         = 80
  protocol     = "HTTP"
  vpc_id       = var.source_vpc_id
  target_type  = "instance"
  health_check {
    path                = var.health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name = "source-target-group"
  }
}

resource "aws_lb_target_group" "destination" {
  provider     = aws.destination
  name         = "destination-target-group"
  port         = 80
  protocol     = "HTTP"
  vpc_id       = var.destination_vpc_id
  target_type  = "instance"
  health_check {
    path                = var.health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name = "destination-target-group"
  }
}

resource "aws_lb_listener" "source" {
  provider           = aws.source
  load_balancer_arn  = aws_lb.source.arn
  port               = 80
  protocol           = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.source.arn
  }
}

resource "aws_lb_listener" "destination" {
  provider           = aws.destination
  load_balancer_arn  = aws_lb.destination.arn
  port               = 80
  protocol           = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.destination.arn
  }
}
