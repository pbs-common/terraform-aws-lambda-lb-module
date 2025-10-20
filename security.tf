resource "aws_security_group" "lb_sg" {
  count       = var.create_lb_sg ? 1 : 0
  description = "Controls access to the ${local.name} load balancer"

  vpc_id      = local.vpc_id
  name_prefix = "${local.load_balancer_name}-sg-"

  tags = merge(
    local.tags,
    { Name = "${local.load_balancer_name} LB SG" },
  )
}

module "lb_egress" {
  count = var.create_lb_sg ? 1 : 0

  source = "github.com/pbs/terraform-aws-sg-rule-module?ref=1.0.0"

  security_group_id = aws_security_group.lb_sg[0].id

  description = "Allow all traffic out"

  type     = "egress"
  port     = 0
  protocol = "all"

  source_cidr_blocks = [
    "0.0.0.0/0"
  ]
}

module "lb_http_ingress_cidrs" {
  count = var.create_lb_sg && local.create_cidr_access_rule ? 1 : 0

  source = "github.com/pbs/terraform-aws-sg-rule-module?ref=0.0.23"

  security_group_id = aws_security_group.lb_sg[0].id

  description = "Allow HTTP traffic to the lb for specific CIDRs"

  port = var.http_port

  source_cidr_blocks = var.restricted_cidr_blocks
}

module "lb_http_ingress_sgs" {
  count = var.create_lb_sg && local.create_sg_access_rule ? 1 : 0

  source = "github.com/pbs/terraform-aws-sg-rule-module?ref=0.0.23"

  security_group_id = aws_security_group.lb_sg[0].id

  description = "Allow HTTP traffic to the lb for specific SGs"

  port = var.http_port

  source_security_group_id = var.restricted_sg
}

module "lb_https_ingress_cidrs" {
  count = var.create_lb_sg && local.create_cidr_access_rule ? 1 : 0

  source = "github.com/pbs/terraform-aws-sg-rule-module?ref=0.0.23"

  security_group_id = aws_security_group.lb_sg[0].id

  description = "Allow HTTPS traffic to the lb for specific CIDRs"

  port = var.https_port

  source_cidr_blocks = var.restricted_cidr_blocks
}

module "lb_https_ingress_sgs" {
  count = var.create_lb_sg && local.create_sg_access_rule ? 1 : 0

  source = "github.com/pbs/terraform-aws-sg-rule-module?ref=0.0.21"

  security_group_id = aws_security_group.lb_sg[0].id

  description = "Allow HTTPS traffic to the lb for specific SGs"

  port = var.https_port

  source_security_group_id = var.restricted_sg
}

module "lambda_permission" {
  source = "github.com/pbs/terraform-aws-lambda-permission-module?ref=0.0.14"

  statement_id  = "AllowExecutionFromLB"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.target_group.arn
}
