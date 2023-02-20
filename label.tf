module "source_label" {
  source      = "cloudposse/label/null"
  version     = "0.25.0"
  name        = var.name
  namespace   = var.namespace
  stage       = var.stage
  attributes  = concat(["source"], var.attributes)
  environment = var.environment
  tags        = var.tags
}

module "target_label" {
  source      = "cloudposse/label/null"
  version     = "0.25.0"
  name        = var.name
  namespace   = var.namespace
  stage       = var.stage
  attributes  = concat(["target"], var.attributes)
  environment = var.environment
  tags        = var.tags
}
