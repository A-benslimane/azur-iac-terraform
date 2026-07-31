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
