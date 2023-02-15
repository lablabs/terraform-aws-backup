variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled"
}

variable "name" {
  type        = string
  default     = "aws-backup"
  description = "Name of module resources"
}

variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace name"
}

variable "stage" {
  type        = string
  default     = ""
  description = "Stage name"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "is_cross_acount_backup_enabled" {
  type        = bool
  default     = false
  description = "Create backup vault on different account and turn on copy action to this vault (provider.target needs to be set)"
}

variable "backup_plans" {
  default     = []
  description = "Backup plans config along with rule and resources setup"
  type = list(object({
    name      = string
    resources = optional(list(string), [])
    selection_tags = optional(list(object({
      type  = string
      key   = string
      value = string
    })), [])
    rules = list(object({
      name                     = string
      schedule                 = string
      enable_continuous_backup = optional(bool)
      start_window             = optional(string, 60)
      completion_window        = optional(number, 180)
      lifecycle = optional(object({
        cold_storage_after = optional(number)
        delete_after       = optional(number)
      }))
      copy_action_lifecycle = optional(object({
        cold_storage_after = optional(number)
        delete_after       = optional(number)
      }))
      recovery_point_tags = optional(map(string))
    }))
    advanced_backup_setting = optional(object({
      WindowsVSS    = optional(string, null)
      resource_type = optional(string, null)
    }), null)
  }))
}
