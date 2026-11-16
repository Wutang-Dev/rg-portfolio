data "aws_iam_openid_connect_provider" "github" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "website_deploy_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:Wutang-Dev@256145436/rg-portfolio@1459128006:ref:refs/heads/main"
      ]
    }
  }
}

resource "aws_iam_role" "website_deploy" {
  name               = "${var.project_name}-website-deploy"
  description        = "GitHub Actions role for portfolio website releases"
  assume_role_policy = data.aws_iam_policy_document.website_deploy_trust.json
}

data "aws_iam_policy_document" "website_deploy_permissions" {
  statement {
    sid    = "ReadWebsiteBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = ["arn:aws:s3:::${var.website_bucket_name}"]
  }

  statement {
    sid    = "PublishWebsiteObjects"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = ["arn:aws:s3:::${var.website_bucket_name}/*"]
  }

  statement {
    sid    = "RefreshWebsiteCache"
    effect = "Allow"

    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation"
    ]

    resources = [
      "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.cloudfront_distribution_id}"
    ]
  }
}

resource "aws_iam_role_policy" "website_deploy" {
  name   = "website-deployment"
  role   = aws_iam_role.website_deploy.id
  policy = data.aws_iam_policy_document.website_deploy_permissions.json
}