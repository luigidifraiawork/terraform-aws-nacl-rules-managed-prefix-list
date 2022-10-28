# NACL rules for AWS prefix lists
This module provides either inbound or outbound NACL rules for a specific AWS prefix list (`s3` or `dynamodb`) in the current region. Its output, `rules`, of type `list(map(string))`, can be used to e.g. populate the `intra_inbound_acl_rules`/`intra_outbound_acl_rules` input variables of the [terraform-aws-modules/vpc/aws module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest), possibly using Terraform's `concat` function to include user-defined rules too.

As an example: for the AWS S3 service, including the output of this module to `intra_inbound_acl_rules` allows the **response** traffic from a VPC Gateway endpoint for S3 to enter intra subnets of the VPC in question.

## Examples
- [Complete](https://github.com/luigidifraiawork/terraform-aws-nacl-rules-managed-prefix-list/tree/master/examples/complete) - Create VPC, VPC Gateway Endpoint for S3, and NACL rules to allow response traffic from the S3 service to intra subnets.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.33 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.33 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.this](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ec2_managed_prefix_list.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_direction"></a> [direction](#input\_direction) | Direction of NACL rules (inbound or outbound) | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the AWS service to retrieve the prefix list for | `string` | n/a | yes |
| <a name="input_start_offset"></a> [start\_offset](#input\_start\_offset) | Start offset to use for NACL rules | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rules"></a> [rules](#output\_rules) | NACL rules that allow CIDR blocks in the prefix list for the given service |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
