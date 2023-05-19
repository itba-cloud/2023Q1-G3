module "api_gw" {
  source                            = "../modules/api_gw"
  lambda_api_gw_resources_hash_list = [for resource_hash in module.api_gw_lambda_integration : resource_hash.lambda_api_gw_config_hash]
}

module "api_gw_lambda_integration" {
  for_each = local.lambdas
  source   = "../modules/api_gw_lambda_integration"

  account_id           = data.aws_caller_identity.this.account_id
  api_gw_execution_arn = module.api_gw.execution_arn
  api_gw_id            = module.api_gw.id
  api_gw_resource_id   = module.api_gw.resource_id
  lambda_info          = each.value
  security_groups      = [aws_security_group.this["lambda"].id]
  subnet_ids           = module.vpc.private_subnets_ids
}