#https://docs.aws.amazon.com/es_es/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html

data "aws_cloudfront_cache_policy" "optimized_policy" {
  name = "Managed-CachingOptimized"
}