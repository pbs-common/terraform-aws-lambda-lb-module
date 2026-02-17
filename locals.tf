locals {
  name = var.name != null ? var.name : var.product

  lambda_name = var.lambda_name != null ? var.lambda_name : local.name

  route_priority = 10

  vpc_id     = var.vpc_id != null ? var.vpc_id : one(data.aws_vpc.vpc[*].id)
  lb_subnets = var.lb_subnets != null ? var.lb_subnets : var.internal ? data.aws_subnets.private_subnets[0].ids : data.aws_subnets.public_subnets[0].ids

  vpc_data_lookup_tags = var.vpc_data_lookup_tags != null ? var.vpc_data_lookup_tags : {
    "environment" : var.environment
  }

  subnet_data_lookup_filters = var.subnet_data_lookup_filters != null ? var.subnet_data_lookup_filters : {
    "vpc-id" = [local.vpc_id]
    "tag:Name" = [
      var.internal ? "*-private-*" : "*-public-*"
    ]
  }

  load_balancer_name = var.load_balancer_name != null ? var.load_balancer_name : local.name
  target_group_name  = var.target_group_name != null ? var.target_group_name : local.name
  lb_security_groups = var.create_lb_sg ? [one(aws_security_group.lb_sg[*].id)] : null

  create_cidr_access_rule = length(var.restricted_cidr_blocks) > 0
  create_sg_access_rule   = var.restricted_sg != null

  hosted_zone           = var.internal ? var.private_hosted_zone : var.primary_hosted_zone
  null_safe_hosted_zone = local.hosted_zone == null ? "" : local.hosted_zone

  cnames  = var.cnames != null ? var.cnames : [local.name]
  aliases = var.aliases != null ? var.aliases : ["${local.name}.${local.null_safe_hosted_zone}"]

  product_dns_record_count = length(local.cnames)
  lookup_hosted_zone       = local.product_dns_record_count > 0
  hosted_zone_id           = local.lookup_hosted_zone ? one(data.aws_route53_zone.hosted_zone[*].zone_id) : null

  lookup_primary_acm_wildcard_cert = !var.internal && var.acm_arn == null

  acm_arn = var.acm_arn != null ? var.acm_arn : local.lookup_primary_acm_wildcard_cert ? one(data.aws_acm_certificate.primary_acm_wildcard_cert[*].arn) : null

  domain_name = local.product_dns_record_count == 0 ? one(aws_lb.lb.dns_name) : one(aws_route53_record.record[*].fqdn)

  only_create_http_listener = var.create_http_listeners && !var.create_https_listeners
  http_forward_rule_count   = local.only_create_http_listener ? length(local.aliases) : 0
  https_forward_rule_count  = var.create_https_listeners ? length(local.aliases) : 0

  // The number of HTTP listener rules we should create that point to the
  // $LATEST version of the lambda. If an alias name is provided and we DON'T
  // want to retain non-aliased listeners, we won't create listeners.
  // Otherwise, we do
  non_aliased_rule_count = (var.lambda_alias_name != null && !var.retain_non_aliased_listener_rules) ? 0 : local.http_forward_rule_count
  aliased_rule_count     = var.lambda_alias_name != null ? local.http_forward_rule_count : 0

  creator = "terraform"

  defaulted_tags = merge(
    var.tags,
    {
      Name                                      = local.name
      "${var.organization}:billing:product"     = var.product
      "${var.organization}:billing:environment" = var.environment
      creator                                   = local.creator
      repo                                      = var.repo
    }
  )

  tags = merge({ for k, v in local.defaulted_tags : k => v if lookup(data.aws_default_tags.common_tags.tags, k, "") != v })
}

data "aws_default_tags" "common_tags" {}
