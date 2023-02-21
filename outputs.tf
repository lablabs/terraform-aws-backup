output "source_backup_vault_id" {
  value       = try(aws_backup_vault.source[0].id, "")
  description = "Backup Vault ID of source backup vault"
}

output "source_backup_vault_arn" {
  value       = try(aws_backup_vault.source[0].arn, "")
  description = "Backup Vault ARN of source backup vault"
}

output "target_backup_vault_id" {
  value       = try(aws_backup_vault.target[0].id, "")
  description = "Backup Vault ID of target backup vault"
}

output "target_backup_vault_arn" {
  value       = try(aws_backup_vault.target[0].arn, "")
  description = "Backup Vault ARN of target backup vault"
}
