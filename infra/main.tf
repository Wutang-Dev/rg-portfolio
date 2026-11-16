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
module "cloudfront" {
  source = "./modules/cloudfront"

  project_name                = var.project_name
  domain_name                 = var.portfolio_domain_name
  certificate_arn             = module.acm.certificate_arn
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
}
data "aws_iam_policy_document" "website" {
  statement {
    sid    = "AllowCloudFrontRead"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${module.s3.bucket_arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cloudfront.distribution_arn]
    }
  }

  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      module.s3.bucket_arn,
      "${module.s3.bucket_arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
resource "aws_s3_bucket_policy" "website" {
  bucket = module.s3.bucket_name
  policy = data.aws_iam_policy_document.website.json
}
module "route53" {
  source = "./modules/route53"

  hosted_zone_id         = data.aws_route53_zone.website.zone_id
  domain_name            = var.portfolio_domain_name
  cloudfront_domain_name = module.cloudfront.domain_name
  cloudfront_zone_id     = module.cloudfront.hosted_zone_id
}
