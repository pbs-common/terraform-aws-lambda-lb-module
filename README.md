# PBS TF Lambda LB

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-lambda-lb-module?ref=x.y.z
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

Provisions an AWS Lambda function and an Application Load Balancer to route traffic to it.

Integrate this module like so:

```hcl
module "lambda_lb" {
  source = "github.com/pbs/terraform-aws-lambda-lb-module?ref=x.y.z"

  handler  = "main.lambda_handler"
  filename = "./artifacts/deploy.zip"
  runtime  = "python3.10"

  primary_hosted_zone = var.primary_hosted_zone

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
}
```

## Adding This Version of the Module

If this repo is added as a subtree, then the version of the module should be close to the version shown here:

`x.y.z`

Note, however that subtrees can be altered as desired within repositories.

Further documentation on usage can be found [here](./docs).

Below is automatically generated documentation on this Terraform module using [terraform-docs][terraform-docs]

---

[terraform-docs]: https://github.com/terraform-docs/terraform-docs

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.22.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | github.com/pbs/terraform-aws-lambda-module | 1.3.40 |
| <a name="module_lambda_permission"></a> [lambda\_permission](#module\_lambda\_permission) | github.com/pbs/terraform-aws-lambda-permission-module | 0.0.18 |
| <a name="module_lb_egress"></a> [lb\_egress](#module\_lb\_egress) | github.com/pbs/terraform-aws-sg-rule-module | 0.0.23 |
| <a name="module_lb_http_ingress_cidrs"></a> [lb\_http\_ingress\_cidrs](#module\_lb\_http\_ingress\_cidrs) | github.com/pbs/terraform-aws-sg-rule-module | 0.0.23 |
| <a name="module_lb_http_ingress_sgs"></a> [lb\_http\_ingress\_sgs](#module\_lb\_http\_ingress\_sgs) | github.com/pbs/terraform-aws-sg-rule-module | 0.0.23 |
| <a name="module_lb_https_ingress_cidrs"></a> [lb\_https\_ingress\_cidrs](#module\_lb\_https\_ingress\_cidrs) | github.com/pbs/terraform-aws-sg-rule-module | 0.0.23 |
| <a name="module_lb_https_ingress_sgs"></a> [lb\_https\_ingress\_sgs](#module\_lb\_https\_ingress\_sgs) | github.com/pbs/terraform-aws-sg-rule-module | 0.0.21 |

## Resources

| Name | Type |
|------|------|
| [aws_lb.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.http_redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.http_forward_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.https_forward_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.target_group_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.lb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_acm_certificate.primary_acm_wildcard_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_route53_zone.hosted_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnets.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_acm_arn"></a> [acm\_arn](#input\_acm\_arn) | ARN of the ACM certificate to use for the load balancer. If null, one will be guessed based on the primary hosted zone of the service. | `string` | `null` | no |
| <a name="input_add_app_config_extension_layer"></a> [add\_app\_config\_extension\_layer](#input\_add\_app\_config\_extension\_layer) | Add the AWS-AppConfig-Lambda-Extension layer to the Lambda function. Ignored if layers is not null or if runtime is not supported. | `bool` | `true` | no |
| <a name="input_add_ssm_extension_layer"></a> [add\_ssm\_extension\_layer](#input\_add\_ssm\_extension\_layer) | Add the AWS-Parameters-and-Secrets-Lambda-Extension layer to the Lambda function. Ignored if layers is not null or if using the ARM runtime. | `bool` | `true` | no |
| <a name="input_add_vpc_config"></a> [add\_vpc\_config](#input\_add\_vpc\_config) | Add VPC configuration to the Lambda function | `bool` | `false` | no |
| <a name="input_alb_ssl_policy"></a> [alb\_ssl\_policy](#input\_alb\_ssl\_policy) | SSL policy to use for an Application Load Balancer application. | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | CNAME(s) that are allowed to be used for this product in the rules on the load balancer. Any name that does not match one of these will get a 403 response from the load balancer. Default is `product`.`hosted_zone`. e.g. [product.example.com] --> [product.example.com] | `list(string)` | `null` | no |
| <a name="input_allow_app_config_access"></a> [allow\_app\_config\_access](#input\_allow\_app\_config\_access) | Allow AppConfig access from the Lambda function. Ignored if `policy_json` or `role_arn` are set. | `bool` | `true` | no |
| <a name="input_app_config_extension_account_number"></a> [app\_config\_extension\_account\_number](#input\_app\_config\_extension\_account\_number) | Account number for the AWS-AppConfig-Extension layer | `string` | `"027255383542"` | no |
| <a name="input_app_config_extension_version"></a> [app\_config\_extension\_version](#input\_app\_config\_extension\_version) | Lambda layer version for the AWS-AppConfig-Extension layer | `number` | `null` | no |
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Architectures to target for the Lambda function | `list(string)` | <pre>[<br>  "x86_64"<br>]</pre> | no |
| <a name="input_cnames"></a> [cnames](#input\_cnames) | CNAME(s) that are going to be created for this product in the hosted zone. This can be set to [] to avoid creating a CNAME for the product. Default is `product`. e.g. [product] --> [product.example.com] | `list(string)` | `null` | no |
| <a name="input_create_http_listeners"></a> [create\_http\_listeners](#input\_create\_http\_listeners) | Create HTTP listeners for the load balancer. By default, these listeners will only be used to redirect to HTTPS. Set `create_https_listeners` to false to only create http listeners. This is not recommended. | `bool` | `true` | no |
| <a name="input_create_https_listeners"></a> [create\_https\_listeners](#input\_create\_https\_listeners) | Create HTTPS listeners for the load balancer. | `bool` | `true` | no |
| <a name="input_create_lb_sg"></a> [create\_lb\_sg](#input\_create\_lb\_sg) | Create a security group for the load balancer | `bool` | `true` | no |
| <a name="input_dns_evaluate_target_health"></a> [dns\_evaluate\_target\_health](#input\_dns\_evaluate\_target\_health) | evaluate health of endpoints by querying DNS records | `bool` | `false` | no |
| <a name="input_environment_vars"></a> [environment\_vars](#input\_environment\_vars) | Map of environment variables for the Lambda. If null, defaults to setting an SSM\_PATH based on the environment and name of the function. Set to {} if you would like for there to be no environment variables present. This is important if you are creating a Lambda@Edge. | `map(any)` | `null` | no |
| <a name="input_file_system_config"></a> [file\_system\_config](#input\_file\_system\_config) | File system configuration for the Lambda function | `map(any)` | `null` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | Filename for the artifact to use for the Lambda | `string` | `null` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda handler | `string` | `null` | no |
| <a name="input_http_port"></a> [http\_port](#input\_http\_port) | HTTP port on which the load balancer is listening | `number` | `80` | no |
| <a name="input_https_port"></a> [https\_port](#input\_https\_port) | HTTPS port on which the load balancer is listening | `number` | `443` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | Idle timeout for the load balancer. The time in seconds that the connection is allowed to be idle. | `number` | `60` | no |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | URI of the container image to use for the Lambda | `string` | `null` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Use an internal load balancer. | `bool` | `false` | no |
| <a name="input_lambda_description"></a> [lambda\_description](#input\_lambda\_description) | Description for this lambda function | `string` | `null` | no |
| <a name="input_lambda_insights_extension_account_number"></a> [lambda\_insights\_extension\_account\_number](#input\_lambda\_insights\_extension\_account\_number) | Account number for the LambdaInsightsExtension layer | `string` | `"580247275435"` | no |
| <a name="input_lambda_insights_extension_version"></a> [lambda\_insights\_extension\_version](#input\_lambda\_insights\_extension\_version) | Lambda layer version for the LambdaInsightsExtension layer | `number` | `null` | no |
| <a name="input_lambda_name"></a> [lambda\_name](#input\_lambda\_name) | Name of the Lambda function | `string` | `null` | no |
| <a name="input_lambda_subnets"></a> [lambda\_subnets](#input\_lambda\_subnets) | Subnets to use for the Lambda function. Ignored if add\_vpc\_config is false. If null, one will be looked up based on environment tag. | `list(string)` | `null` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | Lambda layers to apply to function. If null, a Lambda Layer extension is added by default. | `list(string)` | `null` | no |
| <a name="input_lb_subnets"></a> [lb\_subnets](#input\_lb\_subnets) | Subnets for the product LB. If null, private and public subnets will be looked up based on environment tag and one will be selected based on `internal`. | `list(string)` | `null` | no |
| <a name="input_load_balancer_name"></a> [load\_balancer\_name](#input\_load\_balancer\_name) | Name of the load balancer. If omitted, this module will a value based on the `name` value in this module. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen. | `string` | `null` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Number of days to retain CloudWatch Log entries | `number` | `7` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime | `number` | `128` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Lambda LB. If null, will default to product. | `string` | `null` | no |
| <a name="input_package_type"></a> [package\_type](#input\_package\_type) | Package type for the Lambda function. Valid values are Zip and Image. | `string` | `"Zip"` | no |
| <a name="input_parameters_and_secrets_extension_account_number"></a> [parameters\_and\_secrets\_extension\_account\_number](#input\_parameters\_and\_secrets\_extension\_account\_number) | Account number for the AWS-Parameters-and-Secrets-Lambda-Extension layer | `string` | `"177933569100"` | no |
| <a name="input_parameters_and_secrets_extension_version"></a> [parameters\_and\_secrets\_extension\_version](#input\_parameters\_and\_secrets\_extension\_version) | Lambda layer version for the AWS-Parameters-and-Secrets-Lambda-Extension layer | `number` | `null` | no |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | ARN of the permissions boundary to use on the role created for this lambda | `string` | `null` | no |
| <a name="input_policy_json"></a> [policy\_json](#input\_policy\_json) | Policy JSON. If null, default policy granting access to SSM and cloudwatch logs is used | `string` | `null` | no |
| <a name="input_primary_hosted_zone"></a> [primary\_hosted\_zone](#input\_primary\_hosted\_zone) | Name of the primary hosted zone for DNS. e.g. primary\_hosted\_zone = example.org --> service.example.org. If null, it is assumed that a private hosted zone will be used. | `string` | `null` | no |
| <a name="input_private_hosted_zone"></a> [private\_hosted\_zone](#input\_private\_hosted\_zone) | Name of the private hosted zone for DNS. e.g. private\_hosted\_zone = example.org --> service.example.private. If null, it is assumed that a public hosted zone will be used. | `string` | `null` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Whether to publish creation/change as new Lambda Function Version | `bool` | `true` | no |
| <a name="input_restricted_cidr_blocks"></a> [restricted\_cidr\_blocks](#input\_restricted\_cidr\_blocks) | CIDR blocks to receive restricted product access. If empty, no CIDRs will be allowed to connect. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_restricted_sg"></a> [restricted\_sg](#input\_restricted\_sg) | SG to receive restricted product access. If null, no sg will be configured to connect | `string` | `null` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | ARN of the role to be used for this Lambda | `string` | `null` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Runtime for the lambda function | `string` | `null` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | Security group ID. If null, one will be created. | `string` | `null` | no |
| <a name="input_ssm_path"></a> [ssm\_path](#input\_ssm\_path) | SSM path to use for environment variables. If null, defaults to /${var.environment}/${local.name} | `string` | `null` | no |
| <a name="input_subnet_data_lookup_filters"></a> [subnet\_data\_lookup\_filters](#input\_subnet\_data\_lookup\_filters) | Values of the `filter` blocks in the `aws_subnets` data source used in this module. If null, one will be guessed using the resolved VPC and a `Name` filter of `*-private-*` or `*-public-*` based on the value of `internal`. Ignored if `subnets` is populated. | `map(any)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_target_group_name"></a> [target\_group\_name](#input\_target\_group\_name) | Name of the target group. If omitted, this module will a value based on the `name` value in this module. This name must be unique per region per account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen. | `string` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Timeout in seconds of the Lambda | `number` | `3` | no |
| <a name="input_tracing_config_mode"></a> [tracing\_config\_mode](#input\_tracing\_config\_mode) | Tracing config mode for X-Ray integration on Lambda | `string` | `"Active"` | no |
| <a name="input_use_prefix"></a> [use\_prefix](#input\_use\_prefix) | Use prefix for resources instead of explicitly defining whole name where possible | `bool` | `true` | no |
| <a name="input_vpc_data_lookup_tags"></a> [vpc\_data\_lookup\_tags](#input\_vpc\_data\_lookup\_tags) | Value of the `tags` parameter in the `aws_vpc` data source used in this module. If null, a dynamic lookup based on `environment` will be used. Ignored if `vpc_id` is populated. | `map(string)` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID. If null, one will be looked up based on environment tag. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | One domain name that will resolve to this product. Might not be a valid alias. |
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | ARN of the Lambda function |
| <a name="output_lambda_name"></a> [lambda\_name](#output\_lambda\_name) | Name of the Lambda function |
| <a name="output_lambda_sg"></a> [lambda\_sg](#output\_lambda\_sg) | Security group of the lambda function |
| <a name="output_lb_arn"></a> [lb\_arn](#output\_lb\_arn) | Load balancer ARN |
| <a name="output_lb_sg"></a> [lb\_sg](#output\_lb\_sg) | Load balancer security group |
