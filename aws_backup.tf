# Source vault
resource "aws_backup_vault" "source" {
  count         = var.enabled ? 1 : 0
  provider      = aws.source
  name          = "${module.label.id}-source"
  kms_key_arn   = module.source_kms_key.key_arn
  force_destroy = true
}

resource "aws_backup_vault_policy" "source" {
  count             = var.enabled ? 1 : 0
  provider          = aws.source
  backup_vault_name = aws_backup_vault.source[0].name
  policy            = data.aws_iam_policy_document.source_vault.json
}

resource "aws_backup_plan" "source" {
  provider = aws.source
  for_each = { for bp in var.backup_plans : bp.name => bp if var.enabled }

  name = each.value.name
  tags = var.tags

  dynamic "rule" {
    for_each = each.value.rules
    content {
      rule_name                = rule.value.name
      target_vault_name        = aws_backup_vault.source[0].name
      schedule                 = rule.value.schedule
      start_window             = try(rule.value.start_window, 60)
      completion_window        = try(rule.value.completion_window, 180)
      recovery_point_tags      = try(rule.value.recovery_point_tags, null)
      enable_continuous_backup = try(rule.value.enable_continuous_backup, null)


      dynamic "lifecycle" {
        for_each = try(rule.value.lifecycle, null) != null ? [true] : []
        content {
          cold_storage_after = try(rule.value.lifecycle.cold_storage_after, null)
          delete_after       = try(rule.value.lifecycle.delete_after, null)
        }
      }

      dynamic "copy_action" {
        for_each = var.is_cross_acount_backup_enabled == true ? [true] : []
        content {
          dynamic "lifecycle" {
            for_each = try(rule.value.copy_action_lifecycle, null) != null ? [true] : []
            content {
              cold_storage_after = try(rule.value.copy_action_lifecycle.cold_storage_after, null)
              delete_after       = try(rule.value.copy_action_lifecycle.delete_after, null)
            }
          }
          destination_vault_arn = aws_backup_vault.target[0].arn
        }

      }
    }
  }

  dynamic "advanced_backup_setting" {
    for_each = try(each.value.advanced_backup_setting, null) != null ? [true] : []

    content {
      backup_options = {
        WindowsVSS = try(each.value.advanced_backup_setting.WindowsVSS, null)
      }
      resource_type = try(each.value.advanced_backup_setting.resource_type, null)
    }
  }
}

# Resource selection by arn
resource "aws_backup_selection" "source" {
  for_each = { for bp in flatten([
    for bp_plan in var.backup_plans : [
      for resource in bp_plan.resources : {
        backup_plan_key : bp_plan.name
        resource_arn : resource
      }
    ]
  ]) : md5("${bp.backup_plan_key}${bp.resource_arn}") => bp if var.enabled }

  provider     = aws.source
  iam_role_arn = module.source_role.arn
  plan_id      = aws_backup_plan.source[each.value.backup_plan_key].id
  name         = substr("${module.label.id}-${each.key}", 0, 50)
  resources    = [each.value.resource_arn]
}

# Resource selection by tag
resource "aws_backup_selection" "tag" {
  for_each = { for bp in flatten([
    for bp_plan in var.backup_plans : [
      for selection_tag in bp_plan.selection_tags : {
        backup_plan_key : bp_plan.name
        selection_tag : selection_tag
      }
    ]
  ]) : md5("${bp.backup_plan_key}${bp.selection_tag["type"]}${bp.selection_tag["key"]}${bp.selection_tag["value"]}") => bp if var.enabled }

  provider     = aws.source
  iam_role_arn = module.source_role.arn
  plan_id      = aws_backup_plan.source[each.value.backup_plan_key].id
  name         = substr("${module.label.id}-${each.key}", 0, 50)
  resources    = ["*"]
  selection_tag {
    type  = each.value.selection_tag["type"]
    key   = each.value.selection_tag["key"]
    value = each.value.selection_tag["value"]
  }
}

# Target vault
resource "aws_backup_vault" "target" {
  count         = var.enabled && var.is_cross_acount_backup_enabled ? 1 : 0
  provider      = aws.target
  name          = "${module.label.id}-target"
  kms_key_arn   = module.target_kms_key.key_arn
  force_destroy = true
}

resource "aws_backup_vault_policy" "target" {
  count             = var.enabled && var.is_cross_acount_backup_enabled ? 1 : 0
  provider          = aws.target
  backup_vault_name = aws_backup_vault.target[0].name
  policy            = data.aws_iam_policy_document.target_vault[0].json
}
