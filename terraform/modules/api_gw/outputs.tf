output "domain_name" {
  description = "API gateway domain name"
  value       = join(".", [aws_api_gateway_rest_api.this.id, local.name, data.aws_region.this.name, "amazonaws.com"])
}

output "id" {
  description = "API gateway id"
  value       = aws_api_gateway_rest_api.this.id
}

output "execution_arn" {
  description = "API gateway execution arn to be used by the lambdas"  
  value = aws_api_gateway_rest_api.this.execution_arn
}

output "resource_id" {
  description = "The api gateway resource_id"
  value       = aws_api_gateway_rest_api.this.root_resource_id
}
