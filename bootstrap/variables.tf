variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-north-1"
}
variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "rg-infrastructure-portfolio"
}
variable "managed_by" {
  description = "The entity managing the resources"
  type        = string
  default     = "Terraform"
}

variable "purpose" {
  description = "The purpose of the resources"
  type        = string
  default     = "RemoteState"
}
variable "website_bucket_name" {
  description = "S3 bucket used for portfolio website deployments"
  type        = string
  default     = "rg-infrastructure-portfolio-site-345471468677-eu-north-1"
}

variable "cloudfront_distribution_id" {
  description = "CloudFront distribution used for the portfolio"
  type        = string
  default     = "E2RH4R4DH0Q5GE"
}
