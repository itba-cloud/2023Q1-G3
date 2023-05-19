locals {
  bucket_name      = "static-website-${random_pet.this.id}"
  static_resources = "../frontend"
  website_domain   = var.website_domain
  path             = "../resources"

  lambdas = {
    "get_menu" = {
      function_name = "get_menu"
      http_method   = "GET"
      path_part     = "get_menu"
      status_code   = 200
    }
    "upload_menu" = {
      function_name = "upload_menu"
      http_method   = "GET"
      path_part     = "upload_menu"
      status_code   = 200
    }
    "get_queue_size" = {
      function_name = "get_queue_size"
      http_method   = "GET"
      path_part     = "get_queue_size"
      status_code   = 200
    }
    "add_to_queue" = {
      function_name = "add_to_queue"
      http_method   = "POST"
      path_part     = "add_to_queue"
      status_code   = 200
    }
  }

  security_groups = {
    lambda = {
      name        = "lambda_sg",
      description = "Generic Lambda Security Group",
      rules = [
        {
          name        = "no-egress"
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          name        = "ingress-http"
          type        = "ingress"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          name        = "ingress-https"
          type        = "ingress"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }

  flatten_sg_rules = flatten([
    for key, value in local.security_groups : [
      for rule in value.rules : {
        sg_name = key
        rule    = rule
      }
  ]])
}