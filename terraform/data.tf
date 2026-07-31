data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  resource_group_name = var.app_service_plan_resource_group
}

data "azurerm_client_config" "current" {}
