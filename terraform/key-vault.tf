resource "azurerm_key_vault" "main" {
  name                = var.key_vault_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  rbac_authorization_enabled = true

  tags = merge(
    local.common_tags,
    {
      component = "security"
    }
  )
}

resource "azurerm_role_assignment" "current_user_key_vault_secrets_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "postgresql_admin_password" {
  name         = "postgresql-admin-password"
  value        = random_password.postgresql_admin.result
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [
    azurerm_role_assignment.current_user_key_vault_secrets_officer
  ]
}

resource "azurerm_key_vault_secret" "postgresql_admin_username" {
  name         = "postgresql-admin-username"
  value        = var.postgresql_admin_username
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [
    azurerm_role_assignment.current_user_key_vault_secrets_officer
  ]
}
