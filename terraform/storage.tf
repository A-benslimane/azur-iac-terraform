resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = data.azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version = "TLS1_2"

  tags = merge(
    local.common_tags,
    {
      component = "storage"
    }
  )
}

resource "azurerm_storage_container" "quiz_results" {
  name                  = "quiz-results"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "backend_storage_blob_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_web_app.backend.identity[0].principal_id
}
