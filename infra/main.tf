data "aws_caller_identity" "current" {}

data "aws_route53_zone" "website" {
  name         = var.domain_name
  private_zone = false
}

module "s3" {
  source = "./modules/s3"

  bucket_name = "${var.project_name}-site-${data.aws_caller_identity.current.account_id}-${var.aws_region}"
}

module "acm" {
  source = "./modules/acm"

  providers = {
    aws = aws.us_east_1
  }

  domain_name    = var.portfolio_domain_name
  hosted_zone_id = data.aws_route53_zone.website.zone_id
}