locals {
  network_acls = {
    default_inbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_block  = "10.0.0.0/16"
      },
    ]
  }
}

provider "aws" {
  region = "us-east-1"

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

data "aws_region" "current" {}

################################################################################
# NACL Rules Module
################################################################################

module "nacl_s3_pl" {
  source = "../.."

  service_name = "s3"
  start_offset = 200
}

################################################################################
# Extra Resources
################################################################################

resource "random_pet" "this" {
  length = 2
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = random_pet.this.id
  cidr = "10.0.0.0/16"

  azs = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b", "${data.aws_region.current.name}c"]

  # Intra subnets are designed to have no Internet access via NAT Gateway.
  intra_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  intra_dedicated_network_acl = true
  intra_inbound_acl_rules = concat(
    # NACL rule for local traffic
    local.network_acls["default_inbound"],
    # NACL rules for the response traffic from addresses in the AWS S3 prefix list
    module.nacl_s3_pl.rules
  )
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 3.0"

  vpc_id = module.vpc.vpc_id

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = module.vpc.intra_route_table_ids
    }
  }
}
