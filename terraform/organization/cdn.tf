module "cdn" {
  source                      = "../modules/cdn"
  aliases                     = ["www.${local.website_domain}", local.website_domain]
  domain_name                 = local.website_domain
  bucket_origin_id            = module.static_website.website_bucket_id
  bucket_regional_domain_name = module.static_website.website_bucket_regional_domain_name
  api_domain_name             = module.api_gw.domain_name
  api_origin_id               = module.api_gw.id
  certificate_arn             = module.certificates.certificate_arn
}
