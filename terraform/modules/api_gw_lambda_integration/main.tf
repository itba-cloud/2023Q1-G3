module "lambda" {
    source        = "../lambda"

    account_id      = var.account_id
    function_name   = var.lambda_info.function_name
    security_groups = var.security_groups
    subnet_ids      = var.subnet_ids
}

resource "aws_lambda_permission" "api_gw_lambda" {
    statement_id  = "AllowExecutionFromAPIGateway"
    action        = "lambda:InvokeFunction"
    function_name = var.lambda_info.function_name
    principal     = "apigateway.amazonaws.com"
    source_arn    = "${var.api_gw_execution_arn}/*/${aws_api_gateway_method.this.http_method}${aws_api_gateway_resource.this.path_part}"
    
    depends_on = [
      module.lambda
    ]
}

resource "aws_api_gateway_resource" "this" {
  rest_api_id = var.api_gw_id
  parent_id   = var.api_gw_resource_id
  path_part   = var.lambda_info.path_part 
}

resource "aws_api_gateway_method" "this" {
  rest_api_id   = var.api_gw_id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = var.lambda_info.http_method
  authorization = "NONE"
}

# Connect API GW with lambda
resource "aws_api_gateway_integration" "this" {
  rest_api_id             = var.api_gw_id
  resource_id             = aws_api_gateway_resource.this.id
  http_method             = aws_api_gateway_method.this.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "this" {
  rest_api_id = var.api_gw_id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.this.http_method
  status_code = var.lambda_info.status_code
}

resource "aws_api_gateway_integration_response" "this" {
  rest_api_id = var.api_gw_id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.this.http_method
  status_code = aws_api_gateway_method_response.this.status_code

  depends_on = [
    aws_api_gateway_integration.this
  ]
}
