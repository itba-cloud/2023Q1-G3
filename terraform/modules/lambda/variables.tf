variable "account_id" {
  type        = string
  description = "Current account ID"
}

variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime"
  type = string
  default = "python3.9"
}

variable "security_groups" {
  description = "Security Groups"
  type        = list(string)
}

variable "subnet_ids" {
  type        = list(any)
  description = "List of lambda VPC subnet ids"
}