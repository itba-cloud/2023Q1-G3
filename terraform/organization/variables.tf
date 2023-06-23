variable "aws_region" {
  description = "AWS region in which to deploy the application"
  type        = string
  default     = "us-east-1"
}

variable "website_domain" {
  description = "Website domain"
  type        = string
  default     = "smartpager.com.ar"
}