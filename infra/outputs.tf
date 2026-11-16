output "website_bucket_name" {
  description = "S3 bucket containing the portfolio website"
  value       = module.s3.bucket_name
}
output "website_bucket_arn" {
  description = "ARN of the S3 bucket containing the portfolio website"
  value       = module.s3.bucket_arn
}
output "website_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket containing the portfolio website"
  value       = module.s3.bucket_regional_domain_name
}
output "acm_certificate_arn" {
  description = "Validated ACM certificate for the portfolio"
  value       = module.acm.certificate_arn
}
output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution hostname"
  value       = module.cloudfront.domain_name
}
output "portfolio_url" {
  description = "Portfolio website HTTPS URL"
  value       = "https://${module.route53.website_fqdn}"
}