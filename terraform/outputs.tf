output "storage_account_name" {
  description = "Nom du compte de stockage créé"
  value       = azurerm_storage_account.main.name
}

output "storage_account_id" {
  description = "Identifiant du compte de stockage"
  value       = azurerm_storage_account.main.id
}

output "key_vault_name" {
  description = "Nom du Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI du Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "postgresql_server_name" {
  description = "Nom du serveur PostgreSQL"
  value       = azurerm_postgresql_flexible_server.main.name
}

output "postgresql_fqdn" {
  description = "Adresse du serveur PostgreSQL"
  value       = azurerm_postgresql_flexible_server.main.fqdn
}

output "postgresql_database_name" {
  description = "Nom de la base PostgreSQL"
  value       = azurerm_postgresql_flexible_server_database.quiz.name
}

output "backend_app_name" {
  description = "Nom de l'App Service backend"
  value       = azurerm_linux_web_app.backend.name
}

output "backend_app_url" {
  description = "URL publique du backend"
  value       = "https://${azurerm_linux_web_app.backend.default_hostname}"
}

output "frontend_app_name" {
  description = "Nom de la Static Web App frontend"
  value       = azurerm_static_web_app.frontend.name
}

output "frontend_app_url" {
  description = "URL publique de la Static Web App frontend"
  value       = "https://${azurerm_static_web_app.frontend.default_host_name}"
}

output "redis_name" {
  description = "Nom de l'instance Azure Managed Redis"
  value       = azurerm_managed_redis.redis.name
}

output "redis_hostname" {
  description = "Nom DNS de l'instance Azure Managed Redis"
  value       = azurerm_managed_redis.redis.hostname
}

output "redis_port" {
  description = "Port TLS de la base Redis"
  value       = azurerm_managed_redis.redis.default_database[0].port
}

output "redis_primary_access_key" {
  description = "Clé primaire de connexion à Redis"
  value       = azurerm_managed_redis.redis.default_database[0].primary_access_key
  sensitive   = true
}
