output "rules" {
  description = "NACL rules that allow CIDR blocks in the prefix list for the given service"
  value       = null_resource.this.*.triggers
}
