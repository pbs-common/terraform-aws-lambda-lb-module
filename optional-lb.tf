variable "http_port" {
  description = "HTTP port on which the load balancer is listening"
  default     = 80
  type        = number
}

variable "https_port" {
  description = "HTTPS port on which the load balancer is listening"
  default     = 443
  type        = number
}

variable "target_group_name" {
  description = "Name of the target group. If omitted, this module will a value based on the `name` value in this module. This name must be unique per region per account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen."
  default     = null
  type        = string
}

variable "load_balancer_name" {
  description = "Name of the load balancer. If omitted, this module will a value based on the `name` value in this module. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen."
  default     = null
  type        = string
}

variable "internal" {
  description = "Use an internal load balancer."
  default     = false
  type        = bool
}

variable "idle_timeout" {
  description = "Idle timeout for the load balancer. The time in seconds that the connection is allowed to be idle."
  default     = 60
  type        = number
}

variable "restricted_cidr_blocks" {
  description = "CIDR blocks to receive restricted product access. If empty, no CIDRs will be allowed to connect."
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "restricted_sg" {
  description = "SG to receive restricted product access. If null, no sg will be configured to connect"
  default     = null
  type        = string
}

variable "create_lb_sg" {
  description = "Create a security group for the load balancer"
  default     = true
  type        = bool
}

variable "lb_subnets" {
  description = "Subnets for the product LB. If null, private and public subnets will be looked up based on environment tag and one will be selected based on `internal`."
  default     = null
  type        = list(string)
}

variable "vpc_data_lookup_tags" {
  description = "Value of the `tags` parameter in the `aws_vpc` data source used in this module. If null, a dynamic lookup based on `environment` will be used. Ignored if `vpc_id` is populated."
  default     = null
  type        = map(string)
}

variable "subnet_data_lookup_filters" {
  description = "Values of the `filter` blocks in the `aws_subnets` data source used in this module. If null, one will be guessed using the resolved VPC and a `Name` filter of `*-private-*` or `*-public-*` based on the value of `internal`. Ignored if `subnets` is populated."
  default     = null
  type        = map(any)
}

variable "alb_ssl_policy" {
  description = "SSL policy to use for an Application Load Balancer application."
  default     = "ELBSecurityPolicy-2016-08"
  type        = string
}

variable "create_http_listeners" {
  description = "Create HTTP listeners for the load balancer. By default, these listeners will only be used to redirect to HTTPS. Set `create_https_listeners` to false to only create http listeners. This is not recommended."
  default     = true
  type        = bool
}

variable "create_https_listeners" {
  description = "Create HTTPS listeners for the load balancer."
  default     = true
  type        = bool
}

variable "acm_arn" {
  description = "ARN of the ACM certificate to use for the load balancer. If null, one will be guessed based on the primary hosted zone of the service."
  default     = null
  type        = string
}

variable "lambda_alias_name" {
  description = "The lambda alias to point the load balancer at. If not provided, will default to $LATEST."
  default     = null
  type        = string
}
