module "label" {
  source    = "cloudposse/label/null"
  version   = "0.25.0"
  name      = var.name
  namespace = var.namespace
  stage     = var.stage
  tags      = var.aws_tags
}
