variable "service_name" {
  description = "Name of the AWS service to retrieve the prefix list for"
  type        = string
  validation {
    condition     = can(regex("(s3|dynamodb)", var.service_name))
    error_message = "The value of variable 'service_name' is not valid."
  }
}

variable "start_offset" {
  description = "Start offset to use for NACL rules"
  type        = number
}
