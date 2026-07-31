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

resource "random_password" "postgresql_admin" {
  length           = 24
  special          = true
  override_special = "!#%&*()-_=+"
}

resource "azurerm_postgresql_flexible_server" "main" {
  name                = var.postgresql_server_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  version = "16"
  zone    = "2"

  administrator_login    = var.postgresql_admin_username
  administrator_password = random_password.postgresql_admin.result

  sku_name   = var.postgresql_sku_name
  storage_mb = 32768

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  public_network_access_enabled = true

  tags = merge(
    local.common_tags,
    {
      component = "database"
    }
  )
}

resource "azurerm_postgresql_flexible_server_database" "quiz" {
  name      = var.postgresql_database_name
  server_id = azurerm_postgresql_flexible_server.main.id

  charset   = "UTF8"
  collation = "en_US.utf8"
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

resource "azurerm_linux_web_app" "backend" {
  name                = var.backend_app_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  service_plan_id     = data.azurerm_service_plan.app_service_plan.id

  https_only = true

  site_config {
    always_on = true

    application_stack {
      java_version        = "21"
      java_server         = "JAVA"
      java_server_version = "21"
    }
  }

  app_settings = {
    SERVER_PORT = "8080"

    SPRING_DATASOURCE_URL = "jdbc:postgresql://${azurerm_postgresql_flexible_server.main.fqdn}:5432/${azurerm_postgresql_flexible_server_database.quiz.name}?sslmode=require"

    SPRING_DATASOURCE_USERNAME = var.postgresql_admin_username
    SPRING_DATASOURCE_PASSWORD = random_password.postgresql_admin.result
  }

  tags = merge(
    local.common_tags,
    {
      component = "backend"
    }
  )
}

resource "azurerm_static_web_app" "frontend" {
  name                = var.frontend_app_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = "westeurope"

  sku_tier = "Free"
  sku_size = "Free"

  tags = merge(
    local.common_tags,
    {
      component = "frontend"
    }
  )
}
