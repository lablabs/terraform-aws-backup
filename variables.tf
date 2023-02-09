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

variable "aws_tags" {
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
  type        = any
  # type = list(object({
  #   name      = string
  #   resources = list(string)
  #   rules = list(object({
  #     name = string
  #     schedule = string
  #     enable_continuous_backup = optional(bool)
  #     start_window  = optional(string)
  #     completion_window  = optional(number)
  #     lifecycle = optional(object({
  #       cold_storage_after = optional(number)
  #       delete_after = optional(number)
  #     }))
  #     recovery_point_tags = optional(map(string))
  #   }))
  # }))
}
