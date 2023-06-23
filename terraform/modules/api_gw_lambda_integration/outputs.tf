output "lambda_api_gw_config_hash" {
  description = "Hash to check if any dependencies of the lambda - api gw config has changed"
  value = sha1(jsonencode([   
    aws_api_gateway_integration.this,
    aws_api_gateway_method.this,
    aws_api_gateway_resource.this,
  ]))
}