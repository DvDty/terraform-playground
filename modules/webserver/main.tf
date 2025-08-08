resource "aws_launch_template" "webserver" {
  image_id      = var.eu-central-1-ubuntu-ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.webserver.id]

  user_data = base64encode(
    templatefile("${path.module}/user-data.sh", {
      server_port = var.server_port
    })
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_example" {
  launch_template {
    id      = aws_launch_template.webserver.id
    version = "$Latest"
  }

  vpc_zone_identifier = data.aws_subnets.default.ids
  health_check_type   = "ELB"

  target_group_arns = [aws_lb_target_group.webserver.arn]

  min_size = var.min_size
  max_size = var.max_size

  tag {
    key                 = "Name"
    value               = "${var.webserver_name}-auto-scaling-group"
    propagate_at_launch = true
  }
}

resource "aws_lb" "webserver" {
  name               = "${var.webserver_name}-load-balancer"
  subnets            = data.aws_subnets.default.ids
  load_balancer_type = "application"
  security_groups = [aws_security_group.application_load_balancer.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.webserver.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "webserver" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver.arn
  }
}

resource "aws_lb_target_group" "webserver" {
  name     = "${var.webserver_name}-asg"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_security_group" "webserver" {
  name = "${var.webserver_name}-security-group-ec2"

  ingress {
    from_port = var.server_port
    to_port   = var.server_port
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "application_load_balancer" {
  name = "${var.webserver_name}-security-group-application-load-balancer"
}

locals {
  http_port    = 80
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
  any_port     = 0
  any_protocol = "-1"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.application_load_balancer.id

  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.application_load_balancer.id

  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}
