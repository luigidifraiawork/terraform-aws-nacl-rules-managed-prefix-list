data "aws_region" "current" {}

data "aws_ec2_managed_prefix_list" "this" {
  name = "com.amazonaws.${data.aws_region.current.name}.${var.service_name}"
}

resource "null_resource" "this" {
  count = length(data.aws_ec2_managed_prefix_list.this.entries.*.cidr)

  triggers = {
    rule_number = var.start_offset + count.index
    rule_action = "allow"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_block  = element(data.aws_ec2_managed_prefix_list.this.entries.*.cidr, count.index)
  }
}
