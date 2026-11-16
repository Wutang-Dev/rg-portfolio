variable "project_name" {
  description = "Name of the project"
  type        = string
}
variable "domain_name" {
  description = "Domain name for the CloudFront distribution"
  type        = string
}
variable "certificate_arn" {
  description = "ARN of the ACM certificate for the CloudFront distribution"
  type        = string
}
variable "bucket_regional_domain_name" {
  description = "Regional S3 endpoint used as the origin"
  type        = string
}