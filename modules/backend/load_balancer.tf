# resource "aws_lb" "alb" {
#   name               = "alb_${var.name}"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]

#   enable_deletion_protection = false
#   enable_http2              = true

#   tags = {
#     Name = "Alb_${var.name}"
#   }
# }

# resource "aws_lb_listener" "wordpress_ecs" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }


