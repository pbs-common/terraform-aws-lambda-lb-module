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

  owner        = var.owner
  environment  = var.environment
  product      = var.product
  organization = var.organization
  repo         = var.repo
}

module "lb_http_ingress_cidrs" {
  count = var.create_lb_sg && local.create_cidr_access_rule ? 1 : 0

  source = "github.com/pbs/terraform-aws-sg-rule-module?ref=1.0.0"

  security_group_id = aws_security_group.lb_sg[0].id

  description = "Allow HTTP traffic to the lb for specific CIDRs"

  port = var.http_port

  source_cidr_blocks = var.restricted_cidr_blocks

  owner        = var.owner
  environment  = var.environment
  product      = var.product
  organization = var.organization
  repo         = var.repo
}

module "lb_http_ingress_sgs" {
  count = var.create_lb_sg && local.create_sg_access_rule ? 1 : 0

  source = "github.com/pbs/terraform-aws-sg-rule-module?ref=1.0.0"

  security_group_id = aws_security_group.lb_sg[0].id

  description = "Allow HTTP traffic to the lb for specific SGs"

  port = var.http_port

  source_security_group_id = var.restricted_sg

  owner        = var.owner
  environment  = var.environment
  product      = var.product
  organization = var.organization
  repo         = var.repo
}

module "lb_https_ingress_cidrs" {
  count = var.create_lb_sg && local.create_cidr_access_rule ? 1 : 0

  source = "github.com/pbs/terraform-aws-sg-rule-module?ref=1.0.0"

  security_group_id = aws_security_group.lb_sg[0].id

  description = "Allow HTTPS traffic to the lb for specific CIDRs"

  port = var.https_port

  source_cidr_blocks = var.restricted_cidr_blocks

  owner        = var.owner
  environment  = var.environment
  product      = var.product
  organization = var.organization
  repo         = var.repo
}

module "lb_https_ingress_sgs" {
  count = var.create_lb_sg && local.create_sg_access_rule ? 1 : 0

  source                   = "github.com/pbs/terraform-aws-sg-rule-module?ref=1.0.0"
  security_group_id        = aws_security_group.lb_sg[0].id
  description              = "Allow HTTPS traffic to the lb for specific SGs"
  port                     = var.https_port
  source_security_group_id = var.restricted_sg

  # Tags
  environment  = var.environment
  product      = var.product
  repo         = var.repo
  organization = var.organization
  owner        = var.owner
}

module "lambda_permission" {
  source = "github.com/pbs/terraform-aws-lambda-permission-module?ref=0.0.18"

  statement_id  = "AllowExecutionFromLB"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.target_group.arn
}

/*
 * If the load balancer is pointing at a particular alias, we also need to
 * explicitly provide permissions for the load balancer to invoke the alias
 */
resource "aws_lambda_permission" "lb_alias_invocation" {
  count = var.lambda_alias_name == null ? 0 : 1

  statement_id  = "AllowExecutionFromLB"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.aliased_target_group[0].arn
  qualifier     = var.lambda_alias_name
}
