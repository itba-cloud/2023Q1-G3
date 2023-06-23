module "log_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket_prefix = "logs"
  force_destroy = true

  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true
}


module "www_website_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket_prefix = "www"
  force_destroy = true

  website = {
    redirect_all_requests_to = {
      host_name = module.website_bucket.s3_bucket_bucket_regional_domain_name
    }
  }

}


module "website_bucket" {

  force_destroy = true
  source = "terraform-aws-modules/s3-bucket/aws"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  bucket_prefix = "website"

  attach_policy = true
  policy = data.aws_iam_policy_document.static_website_policy.json

  versioning = {
    status     = true
    mfa_delete = false
  }

  logging = {
    target_bucket = module.log_bucket.s3_bucket_id
    target_prefix = "log/"
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  website = {
    index_document = var.index_document
    error_document = var.error_document
  }
}

#Upload files of your static website
resource "aws_s3_object" "data" {
  for_each = { for file in local.file_with_type : "${file.file_name}.${file.mime}" => file }

  bucket = module.website_bucket.s3_bucket_id
  key    = each.value.file_name

  source       = local.static_resource_paths[each.value.file_name]
  etag         = filemd5(local.static_resource_paths[each.value.file_name])
  content_type = each.value.mime
}
