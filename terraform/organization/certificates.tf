module "certificates" {
  source      = "../modules/certificates"
  domain_name = local.website_domain
}