data "aws_iam_policy_document" "static_website_policy" {
  statement {
    sid     = "PublicReadGetObject"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    principals {
      type        = "AWS"
      identifiers = var.bucket_access_OAI
    }
    resources = [
      module.website_bucket.s3_bucket_arn, 
      "${module.website_bucket.s3_bucket_arn}/*"
    ]
  }
}
