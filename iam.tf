locals {
  aws_backup_managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup",
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  ]
  role_description = "Provides AWS Backup permission to create backups and perform restores on your behalf across AWS services"
}

module "source_role" {
  source  = "cloudposse/iam-role/aws"
  version = "0.17.0"

  enabled = var.enabled
  providers = {
    aws = aws.source
  }

  name = "${module.label.id}-source"

  role_description = local.role_description

  assume_role_actions = [
    "sts:AssumeRole"
  ]

  principals = {
    Service = ["backup.amazonaws.com"]
  }

  managed_policy_arns = local.aws_backup_managed_policy_arns

  policy_document_count = 0
}


module "target_role" {
  source  = "cloudposse/iam-role/aws"
  version = "0.17.0"

  enabled = var.enabled && var.is_cross_acount_backup_enabled
  providers = {
    aws = aws.target
  }

  name = "${module.label.id}-target"

  role_description = local.role_description

  assume_role_actions = [
    "sts:AssumeRole"
  ]

  principals = {
    Service = ["backup.amazonaws.com"]
  }

  policy_document_count = 0

  managed_policy_arns = local.aws_backup_managed_policy_arns
}


# aws backup

data "aws_iam_policy_document" "source_vault" {
  provider = aws.source
  statement {
    sid    = "Enable backup"
    effect = "Allow"

    actions = ["backup:CopyIntoBackupVault"]

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

data "aws_iam_policy_document" "target_vault" {
  count = var.is_cross_acount_backup_enabled ? 1 : 0

  provider = aws.target
  statement {
    sid    = "Enable backup"
    effect = "Allow"

    actions = ["backup:CopyIntoBackupVault"]

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
