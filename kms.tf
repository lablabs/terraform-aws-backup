module "source_kms_key" {
  source  = "cloudposse/kms-key/aws"
  version = "0.12.1"

  enabled = var.enabled
  providers = {
    aws = aws.source
  }

  context                 = module.source_label.context
  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/${module.source_label.id}"
  policy                  = data.aws_iam_policy_document.kms_source_policy.json
}

module "target_kms_key" {
  source  = "cloudposse/kms-key/aws"
  version = "0.12.1"

  enabled = var.enabled && var.is_cross_account_backup_enabled
  providers = {
    aws = aws.target
  }

  context                 = module.target_label.context
  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/${module.target_label.id}"
  policy                  = data.aws_iam_policy_document.kms_target_policy.json
}

data "aws_caller_identity" "source" {
  provider = aws.source
}

data "aws_caller_identity" "target" {
  provider = aws.target
}

data "aws_iam_policy_document" "kms_source_policy" {
  provider = aws.source
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"

    #checkov:skip=CKV_AWS_111
    actions = ["kms:*"]

    #checkov:skip=CKV_AWS_109
    resources = ["*"]

    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.source.account_id}:root",
      ]
      type = "AWS"
    }
  }
  statement {
    sid    = "Allow use of the key"
    effect = "Allow"

    #checkov:skip=CKV_AWS_111
    actions = ["kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
      "kms:CreateGrant"
    ]

    #checkov:skip=CKV_AWS_109
    resources = ["*"]

    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.target.account_id}:root",
      ]
      type = "AWS"
    }
  }
}

data "aws_iam_policy_document" "kms_target_policy" {
  provider = aws.target
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"

    #checkov:skip=CKV_AWS_111
    actions = ["kms:*"]

    #checkov:skip=CKV_AWS_109
    resources = ["*"]

    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.target.account_id}:root"
      ]
      type = "AWS"
    }
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"

    actions = ["kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
      "kms:CreateGrant"
    ]

    #checkov:skip=CKV_AWS_109
    resources = ["*"]

    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.source.account_id}:root",
      ]
      type = "AWS"
    }
  }
}
