data "aws_iam_policy_document" "infra_plan_trust" {
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

resource "aws_iam_role" "infra_plan" {
  name               = "${var.project_name}-infra-plan"
  description        = "GitHub Actions role for portfolio infrastructure plans"
  assume_role_policy = data.aws_iam_policy_document.infra_plan_trust.json
}

data "aws_iam_policy_document" "infra_plan_permissions" {
  statement {
    sid       = "ListStateBucket"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.terraform_state.arn]
  }

  statement {
    sid     = "ReadInfrastructureState"
    actions = ["s3:GetObject"]

    resources = [
      "${aws_s3_bucket.terraform_state.arn}/infra/terraform.tfstate"
    ]
  }

  statement {
    sid = "ManageInfrastructureStateLock"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${aws_s3_bucket.terraform_state.arn}/infra/terraform.tfstate.tflock"
    ]
  }

  statement {
    sid = "ReadWebsiteBucketConfiguration"

    actions = [
      "s3:Get*",
      "s3:ListTagsForResource"
    ]

    resources = ["arn:aws:s3:::${var.website_bucket_name}"]
  }

  statement {
    sid = "ReadCloudFrontConfiguration"

    actions = [
      "cloudfront:Get*",
      "cloudfront:List*"
    ]

    resources = ["*"]
  }

  statement {
    sid = "ReadPortfolioCertificate"

    actions = [
      "acm:DescribeCertificate",
      "acm:ListTagsForCertificate"
    ]

    resources = [
      "arn:aws:acm:us-east-1:${data.aws_caller_identity.current.account_id}:certificate/92504b42-707a-48ae-88ec-cf2254017511"
    ]
  }

  statement {
    sid = "FindHostedZone"

    actions = [
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName"
    ]

    resources = ["*"]
  }

  statement {
    sid = "ReadPortfolioDNS"

    actions = [
      "route53:GetHostedZone",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource"
    ]

    resources = [
      "arn:aws:route53:::hostedzone/Z0791781B3Y0EK6WV66F"
    ]
  }
}

resource "aws_iam_role_policy" "infra_plan" {
  name   = "infrastructure-plan"
  role   = aws_iam_role.infra_plan.id
  policy = data.aws_iam_policy_document.infra_plan_permissions.json
}