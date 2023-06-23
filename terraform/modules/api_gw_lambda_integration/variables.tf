variable "account_id" {
    description = "Account id to be used for lambda function role"
    type        = string
}

variable "api_gw_execution_arn" {
  description = "API Gateway's execution ARN"
  type        = string
}

variable "api_gw_id" {
  type = string
}

variable "api_gw_resource_id" {
  type = string
}

variable "lambda_info" {
    description = "Map of all the info requider of the lambda function"
    type        = map(string)
}

variable "security_groups" {
  description = "Security Groups"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Lambda VPC subnet ids"
  type        = list(string)
}