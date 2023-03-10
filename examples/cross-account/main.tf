resource "aws_backup_global_settings" "aws_backup" {
  global_settings = {
    "isCrossAccountBackupEnabled" = "true"
  }
  provider = aws.management
}

module "aws-backup-dev-audit" {
  source = "../../"

  providers = {
    aws.source = aws.source
    aws.target = aws.target
  }

  enabled = true

  name = "dynamod-db"

  # namespace = "aws-backup"

  is_cross_account_backup_enabled = true

  backup_plans = [
    {
      name      = "dynamodb-plan"
      resources = [aws_dynamodb_table.example.arn]
      selection_tags = [
        {
          type  = "STRINGEQUALS"
          key   = "tag:stage"
          value = "dev"
        }
      ]
      rules = [{
        name              = "dynamodb-rule"
        schedule          = "cron(30 * * * ? *)"
        start_window      = 60
        completion_window = 120
        lifecycle = {
          delete_after = 14
        }
        copy_action_lifecycle = {
          delete_after = 14
        }

        recovery_point_tags = {
          "Environment" = "dev"
        }
        },
        {
          name              = "dynamodb-rule"
          schedule          = "cron(0 * * * ? *)"
          start_window      = 60
          completion_window = 120
          lifecycle = {
            delete_after = 14
          }
          recovery_point_tags = {
            "Environment" = "dev"
          }
      }]
    },
    {
      name      = "dynamodb-plan2"
      resources = [aws_dynamodb_table.example.arn]
      rules = [{
        name              = "dynamodb-rule2"
        schedule          = "cron(0 1 * * ? *)"
        start_window      = 120
        completion_window = 360
      }]
    }
  ]


}
