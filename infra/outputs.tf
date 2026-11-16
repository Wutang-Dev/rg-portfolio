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