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

locals {
  postgresql_appservice_ips = {
    appservice-1 = "40.89.130.0"
    appservice-2 = "40.89.139.181"
    appservice-3 = "40.89.166.179"
    appservice-4 = "40.89.161.203"
    appservice-5 = "40.79.130.129"
    appservice-6 = "20.111.0.255"
  }
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "appservice" {
  for_each = local.postgresql_appservice_ips

  name             = each.key
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = each.value
  end_ip_address   = each.value
}
