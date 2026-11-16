output "distribution_id" {
  description = "CloudFront distribution ID for deployments"
  value       = aws_cloudfront_distribution.website.id
}
output "distribution_arn" {
  description = "CloudFront distribution ARN for the S3 policy"
  value       = aws_cloudfront_distribution.website.arn
}
output "domain_name" {
  description = "CloudFront distribution hostname"
  value       = aws_cloudfront_distribution.website.domain_name
}
output "hosted_zone_id" {
  description = "CloudFront hosted zone ID for Route 53 aliases"
  value       = aws_cloudfront_distribution.website.hosted_zone_id
}