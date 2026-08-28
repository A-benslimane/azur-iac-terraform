variable "owner" {
  description = "Identifiant du propriétaire des ressources Azure"
  type        = string
}

variable "project_name" {
  description = "Nom court du projet"
  type        = string
  default     = "azure-quiz"
}

variable "environment" {
  description = "Nom de l'environnement"
  type        = string
  default     = "nonprod"
}

variable "location" {
  description = "Région Azure utilisée pour les ressources"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du groupe de ressources dédié à l'apprenant"
  type        = string
}

variable "app_service_plan_name" {
  description = "Nom de l'App Service Plan mutualisé fourni par le formateur"
  type        = string
}

variable "app_service_plan_resource_group" {
  description = "Groupe de ressources contenant l'App Service Plan mutualisé"
  type        = string
}

variable "storage_account_name" {
  description = "Nom du compte de stockage Azure"
  type        = string
}

variable "key_vault_name" {
  description = "Nom du Key Vault"
  type        = string
}

variable "postgresql_server_name" {
  description = "Nom du serveur PostgreSQL Flexible Server"
  type        = string
}

variable "postgresql_database_name" {
  description = "Nom de la base de données PostgreSQL"
  type        = string
  default     = "quizdb"
}

variable "postgresql_admin_username" {
  description = "Nom de l'administrateur PostgreSQL"
  type        = string
  default     = "quizadmin"
}

variable "postgresql_sku_name" {
  description = "SKU du serveur PostgreSQL"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "backend_app_name" {
  description = "Nom de l'App Service du backend"
  type        = string
}

variable "frontend_app_name" {
  description = "Nom de la Static Web App frontend"
  type        = string
}
