module "static_website" {
  source            = "../modules/static_website"
  static_resources  = local.static_resources
  bucket_name       = local.bucket_name
  bucket_access_OAI = [module.cdn.static_website_OAI]
}

