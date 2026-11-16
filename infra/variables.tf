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
  description = "The purpose of the resources for the portfolio"
  type        = string
  default     = "PortfolioHosting"
}
variable "domain_name" {
  description = "Existing public Route 53 hosted zone"
  type        = string
  default     = "rginfralabs.co.uk"
}

variable "portfolio_domain_name" {
  description = "Hostname used for the portfolio website"
  type        = string
  default     = "portfolio.rginfralabs.co.uk"
}
