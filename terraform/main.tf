data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_route53_zone" "selected" {
  name = "strategycrackers.com"
}

data "template_file" "asg_instance_exec" {
  template = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install git -y
    sudo apt install python3-pip -y
    cd /tmp
    sudo git clone https://github.com/burnsie7/hello-tf.git
    pip install -r ./hello-tf/requirements.txt
    sudo chmod +x ./hello-tf/assets/setup-web.sh
    sudo sh ./hello-tf/assets/setup-web.sh
  EOF
}

resource "aws_route53_record" "hello_dns_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.prefix}.${data.aws_route53_zone.selected.name}"
  type    = "A"
  alias {
    name                   = aws_lb.hello_asg_lb.dns_name
    zone_id                = aws_lb.hello_asg_lb.zone_id
    evaluate_target_health = true
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name = "app-vpc"
  cidr = "10.0.0.0/16"

  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}


resource "aws_launch_template" "lt-hello-template" {
  name_prefix            = "lt-${var.prefix}"
  image_id               = var.ami_id
  instance_type          = var.instance_size
  vpc_security_group_ids = [aws_security_group.hello_instance_sg.id]
  key_name               = var.cli_pem
  user_data              = base64encode(data.template_file.asg_instance_exec.rendered)
  tags = {
    Name = "Launch Template from Tag"
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ASG-Server"
    }
  }
}


resource "aws_autoscaling_group" "hello_asg" {
  name                = "${var.prefix}-asg"
  min_size            = 3
  max_size            = 5
  desired_capacity    = 3
  vpc_zone_identifier = module.vpc.public_subnets

  health_check_type = "ELB"
  launch_template {
    id = aws_launch_template.lt-hello-template.id
  }

  target_group_arns = [aws_lb_target_group.hello_tg.arn]

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}-asg-compute-instance"
    propagate_at_launch = true
  }
}

resource "aws_lb" "hello_asg_lb" {
  name               = "${var.prefix}-asg-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.hello_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "hello_listener" {
  load_balancer_arn = aws_lb.hello_asg_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hello_tg.arn
  }
}

resource "aws_lb_target_group" "hello_tg" {
  name     = "${var.prefix}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_autoscaling_attachment" "hello_attachment" {
  autoscaling_group_name = aws_autoscaling_group.hello_asg.id
  lb_target_group_arn    = aws_lb_target_group.hello_tg.arn
}

resource "aws_security_group" "hello_instance_sg" {
  name = "${var.prefix}-instance-sg"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.hello_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "hello_sg" {
  name = "${var.prefix}-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}
