locals {
  id          = module.label.id
  target_name = "${local.id}-target"
  source_name = "${local.id}-source"
  context     = module.label.context
}
