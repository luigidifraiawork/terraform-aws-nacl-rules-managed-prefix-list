data "aws_region" "current" {}

data "aws_ec2_managed_prefix_list" "this" {
  name = "com.amazonaws.${data.aws_region.current.name}.${var.service_name}"
}

resource "null_resource" "this" {
  count = length(data.aws_ec2_managed_prefix_list.this.entries.*.cidr)

  triggers = {
    rule_number = var.start_offset + count.index
    rule_action = "allow"
    from_port   = var.direction == "inbound" ? 1024 : 443
    to_port     = var.direction == "inbound" ? 65535 : 443
    protocol    = "tcp"
    cidr_block  = element(data.aws_ec2_managed_prefix_list.this.entries.*.cidr, count.index)
  }
}
