variable "vpc_name" {
  description  = "Name tag value"
  type         = string
  default      = "Main-VPC-SMARTPAGER"
}

variable "vpc_network_cidr" {
  description  = "CIDR block for the main vpc"
  type         = string 
  default     = "10.0.0.0/16"
}

variable "vpc_az_count" {
  description = "Quantity of availability zones - 1 subnet per AZ"
  type        = number
  default     = 2
}
