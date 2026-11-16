data "aws_iam_policy_document" "infra_apply_trust" {
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

resource "aws_iam_role" "infra_apply" {
  name               = "${var.project_name}-infra-apply"
  description        = "GitHub Actions role for portfolio infrastructure updates"
  assume_role_policy = data.aws_iam_policy_document.infra_apply_trust.json
}

data "aws_iam_policy_document" "infra_apply_permissions" {
  source_policy_documents = [
    data.aws_iam_policy_document.infra_plan_permissions.json
  ]

  statement {
    sid     = "WriteInfrastructureState"
    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.terraform_state.arn}/infra/terraform.tfstate"
    ]
  }

  statement {
    sid = "UpdateWebsiteBucketConfiguration"

    actions = [
      "s3:CreateBucket",
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:PutBucketPublicAccessBlock",
      "s3:PutBucketOwnershipControls",
      "s3:PutBucketVersioning",
      "s3:PutEncryptionConfiguration",
      "s3:PutBucketTagging",
      "s3:TagResource",
      "s3:UntagResource"
    ]

    resources = ["arn:aws:s3:::${var.website_bucket_name}"]
  }

  statement {
    sid = "UpdatePortfolioDistribution"

    actions = [
      "cloudfront:UpdateDistribution",
      "cloudfront:TagResource",
      "cloudfront:UntagResource"
    ]

    resources = [
      "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.cloudfront_distribution_id}"
    ]
  }

  statement {
    sid       = "UpdateOriginAccessControl"
    actions   = ["cloudfront:UpdateOriginAccessControl"]
    resources = ["*"]
  }

  statement {
    sid = "UpdateCertificateTags"

    actions = [
      "acm:AddTagsToCertificate",
      "acm:RemoveTagsFromCertificate"
    ]

    resources = [
      "arn:aws:acm:us-east-1:${data.aws_caller_identity.current.account_id}:certificate/92504b42-707a-48ae-88ec-cf2254017511"
    ]
  }

  statement {
    sid     = "ManagePortfolioDNS"
    actions = ["route53:ChangeResourceRecordSets"]

    resources = [
      "arn:aws:route53:::hostedzone/Z0791781B3Y0EK6WV66F"
    ]

    condition {
      test     = "ForAllValues:StringLike"
      variable = "route53:ChangeResourceRecordSetsNormalizedRecordNames"

      values = [
        "portfolio.rginfralabs.co.uk",
        "*.portfolio.rginfralabs.co.uk"
      ]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "route53:ChangeResourceRecordSetsRecordTypes"
      values   = ["A", "AAAA", "CNAME"]
    }
  }

  statement {
    sid       = "ReadDNSChangeStatus"
    actions   = ["route53:GetChange"]
    resources = ["arn:aws:route53:::change/*"]
  }
}

resource "aws_iam_role_policy" "infra_apply" {
  name   = "infrastructure-apply"
  role   = aws_iam_role.infra_apply.id
  policy = data.aws_iam_policy_document.infra_apply_permissions.json
}