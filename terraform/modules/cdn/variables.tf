variable "ipv6_enable" {
  description  = "Enable IPV6 CDN support"
  type         = bool
  default      = false
}

variable "aliases" {
  description  = "CDN aliases"
  type         = set(string)
}

variable "domain_name" {
  description  = "Domain name"
  type         = string
}

variable "bucket_regional_domain_name" {
  description  = "Static site bucket regional domain name"
  type         = string
}

variable "bucket_origin_id" {
  description  = "CDN origin bucket id"
  type         = string
}

variable "api_domain_name" {
  description  = "API REST domain name"
  type         = string
}

variable "api_origin_id" {
  description  = "API REST origin id"
  type         = string
}

variable "certificate_arn" {
  description  = "Certificate ARN"
  type         = string
}