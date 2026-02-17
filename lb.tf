resource "aws_lb" "lb" {
  name            = local.load_balancer_name
  subnets         = local.lb_subnets
  security_groups = local.lb_security_groups
  idle_timeout    = var.idle_timeout

  internal = var.internal

  tags = merge(
    local.tags,
    { Name = "${local.load_balancer_name} LB" },
  )
}

## HTTP Listeners
resource "aws_lb_listener" "http" {
  count             = local.only_create_http_listener ? 1 : 0
  load_balancer_arn = aws_lb.lb.id
  port              = var.http_port
  protocol          = "HTTP"

  # We 403 by default, unless one of the application rules below is met.

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener" "http_redirect" {
  count             = local.only_create_http_listener ? 0 : 1
  load_balancer_arn = aws_lb.lb.id
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = var.https_port
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

## HTTPS Listener
resource "aws_lb_listener" "https" {
  count             = var.create_https_listeners ? 1 : 0
  load_balancer_arn = aws_lb.lb.id
  port              = var.https_port
  protocol          = "HTTPS"
  certificate_arn   = local.acm_arn
  ssl_policy        = var.alb_ssl_policy

  # We 403 by default, unless one of the forwarding rules below is met.

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "403"
    }
  }

  depends_on = [
    aws_lb_target_group.target_group
  ]
}

resource "aws_lb_target_group" "target_group" {
  name        = local.target_group_name
  target_type = "lambda"

  tags = merge(local.tags, { "Name" = "${local.target_group_name} target group" })
}

// A target group attachement that points to the lambda
// If an alias is provided, we'll point to that instead
resource "aws_lb_target_group_attachment" "target_group_attachment" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.lambda_alias_name == null ? module.lambda.arn : data.aws_lambda_alias.lb_target[0].arn
  depends_on       = [module.lambda_permission, module.lambda, aws_lambda_permission.lb_alias_invocation, data.aws_lambda_alias.lb_target]

  lifecycle {
    create_before_destroy = true
  }
}

## Forwarding Rules

resource "aws_lb_listener_rule" "http_forward_rule" {
  count        = local.http_forward_rule_count
  listener_arn = aws_lb_listener.http[0].arn
  priority     = local.route_priority + count.index

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    host_header {
      values = [element(local.aliases, count.index)]
    }
  }
}

resource "aws_lb_listener_rule" "https_forward_rule" {
  count        = local.https_forward_rule_count
  listener_arn = aws_lb_listener.https[0].arn
  priority     = local.route_priority + count.index

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    host_header {
      values = [element(local.aliases, count.index)]
    }
  }
}
