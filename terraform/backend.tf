resource "azurerm_linux_web_app" "backend" {
  name                = var.backend_app_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  service_plan_id     = data.azurerm_service_plan.app_service_plan.id

  https_only = true

  identity {
    type = "SystemAssigned"
  }

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

    SPRING_PROFILES_ACTIVE = "prod"

    SPRING_DATASOURCE_URL = "jdbc:postgresql://${azurerm_postgresql_flexible_server.main.fqdn}:5432/${azurerm_postgresql_flexible_server_database.quiz.name}?sslmode=require"

    SPRING_DATASOURCE_USERNAME = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.postgresql_admin_username.id})"
    SPRING_DATASOURCE_PASSWORD = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.postgresql_admin_password.id})"

    STORAGE_ACCOUNT_NAME   = azurerm_storage_account.main.name
    STORAGE_CONTAINER_NAME = azurerm_storage_container.quiz_results.name

    REDIS_HOSTNAME    = azurerm_managed_redis.redis.hostname
    REDIS_PORT        = tostring(azurerm_managed_redis.redis.default_database[0].port)
    REDIS_PASSWORD    = azurerm_managed_redis.redis.default_database[0].primary_access_key
    REDIS_SSL_ENABLED = "true"

    BACKEND_API_KEY      = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.backend_api_key.id})"
    CORS_ALLOWED_ORIGINS = "https://${azurerm_static_web_app.frontend.default_host_name}"
  }

  tags = merge(
    local.common_tags,
    {
      component = "backend"
    }
  )
}
