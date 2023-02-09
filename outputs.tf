output "source_backup_vault_id" {
  value       = aws_backup_vault.source.id
  description = "Backup Vault ID of source backup vault"
}

output "source_backup_vault_arn" {
  value       = aws_backup_vault.source.arn
  description = "Backup Vault ARN of source backup vault"
}

output "target_backup_vault_id" {
  value       = aws_backup_vault.target.*.id
  description = "Backup Vault ID of target backup vault"
}

output "target_backup_vault_arn" {
  value       = aws_backup_vault.target.*.arn
  description = "Backup Vault ARN of target backup vault"
}
