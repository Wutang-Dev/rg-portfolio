# bucket name
output "bucket_name" {
  description = "Name of the website bucket"
  value       = aws_s3_bucket.website.id
}
output "bucket_arn" {
  description = "ARN of the website bucket"
  value       = aws_s3_bucket.website.arn
}
# bucket regional domain name
output "bucket_regional_domain_name" {
  description = "Regional bucket endpoint for the CloudFront origin"
  value       = aws_s3_bucket.website.bucket_regional_domain_name
}