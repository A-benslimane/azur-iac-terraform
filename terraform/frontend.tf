resource "azurerm_static_web_app" "frontend" {
  name                = var.frontend_app_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = "westeurope"

  sku_tier = "Free"
  sku_size = "Free"


  lifecycle {
    ignore_changes = [
      repository_url,
      repository_branch
    ]
  }

  tags = merge(
    local.common_tags,
    {
      component = "frontend"
    }
  )
}
