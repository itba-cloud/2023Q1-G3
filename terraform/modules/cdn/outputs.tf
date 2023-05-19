output "static_website_OAI" {
  description = "OAI used for the website"
  value = aws_cloudfront_origin_access_identity.static_website_OAI.iam_arn
}

output "cloudfront_distribution" {
  description = "Cloudfront distribution for deployment"
  value       = aws_cloudfront_distribution.s3_distribution
}