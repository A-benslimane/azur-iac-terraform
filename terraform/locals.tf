locals {
  common_tags = {
    owner       = var.owner
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}
