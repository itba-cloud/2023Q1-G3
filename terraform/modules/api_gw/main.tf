resource "aws_api_gateway_rest_api" "this" {
  name = local.name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    #Resource updates require redeploying the API. https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle
    redeployment = sha1(jsonencode(var.lambda_api_gw_resources_hash_list))
  }


  lifecycle {
    #ensures high uptime
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "api"
}
