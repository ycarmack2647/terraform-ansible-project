
# Create the ALB
resource "aws_lb" "alb" {
  name               = "my-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["subnet-0355527bb0c5f277c", "subnet-09e7304a354b69c04"]  # Replace with your public subnet IDs

  tags = {
    Name = "my-alb"
  }
}

# Create the Target Group
resource "aws_lb_target_group" "dev_tg" {
  name     = "dev-tg"
  port     = 80  # The port your web servers are listening on
  protocol = "HTTP"
  vpc_id   = "vpc-0d251ae28bb57d0d3"  # Replace with your VPC ID

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "dev-tg"
  }
}

# Create the HTTP Listener on Port 80
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_tg.arn
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.existing_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_tg.arn
  }
}



# Register Targets with the Target Group
resource "aws_lb_target_group_attachment" "webserver_az1" {
  target_group_arn = aws_lb_target_group.dev_tg.arn
  target_id        = aws_instance.webserver_az1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "webserver_az2" {
  target_group_arn = aws_lb_target_group.dev_tg.arn
  target_id        = aws_instance.webserver_az2.id
  port             = 80
}
