variable "static_resources" {
    description = "Path to the static resources of the website"
    type        =  string
}

variable "bucket_name" {
  description  = "The bucket domain name"
  type         = string
}

variable "bucket_prefix" {
  description  = "The bucket prefix"
  type         = string
  default = "G3"
}

variable "bucket_access_OAI" {
  description  = "OAI of authorized bucket users"
  type         = list(string)
}

variable "index_document" {
  description = "Index document for website bucket"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Error document for website bucket"
  type        = string
  default     = "error.html"
}