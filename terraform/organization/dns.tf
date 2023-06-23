module "dns" {
  source = "../modules/dns"

  domain_name = var.website_domain
  cdn         = module.cdn.cloudfront_distribution
}