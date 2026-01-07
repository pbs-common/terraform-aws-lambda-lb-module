data "aws_route53_zone" "hosted_zone" {
  count        = local.lookup_hosted_zone ? 1 : 0
  name         = "${local.hosted_zone}."
  private_zone = var.internal
}

data "aws_vpc" "vpc" {
  count = var.vpc_id == null ? 1 : 0

  tags = local.vpc_data_lookup_tags

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "aws_acm_certificate" "primary_acm_wildcard_cert" {
  count  = local.lookup_primary_acm_wildcard_cert ? 1 : 0
  domain = "*.${var.primary_hosted_zone}"
}

data "aws_subnets" "public_subnets" {
  count = var.lb_subnets == null && !var.internal ? 1 : 0

  dynamic "filter" {
    for_each = local.subnet_data_lookup_filters
    content {
      name   = filter.key
      values = filter.value
    }
  }
}

data "aws_subnets" "private_subnets" {
  count = var.lb_subnets == null && var.internal ? 1 : 0

  dynamic "filter" {
    for_each = local.subnet_data_lookup_filters
    content {
      name   = filter.key
      values = filter.value
    }
  }
}
