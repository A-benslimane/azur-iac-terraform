# Infrastructure Azure avec Terraform

Ce dépôt contient le code Terraform utilisé pour créer l’infrastructure Azure du projet Quiz.

## Architecture

terraform/
├── data.tf
├── locals.tf
├── outputs.tf
├── providers.tf
├── variables.tf
├── versions.tf
├── terraform.tfvars
├── terraform.tfvars.example
├── .terraform.lock.hcl
│
├── storage.tf
├── key-vault.tf
├── postgresql.tf
├── backend.tf
├── frontend.tf
└── redis.tf


L’infrastructure comprend :

- un compte de stockage Azure ;
- un Azure Key Vault ;
- un serveur PostgreSQL Flexible Server ;
- une base de données PostgreSQL ;
- une Azure Linux Web App pour le backend Spring Boot ;
- une Azure Static Web App pour le frontend Angular.



## Ressources Azure

| Ressource | Nom |
|---|---|
| Resource Group | `abenslimaneRG` |
| Storage Account | `stabenslimanequiz` |
| Key Vault | `kv-abenslimane-quiz` |
| PostgreSQL Server | `psql-abenslimane-quiz` |
| PostgreSQL Database | `quizdb` |
| Backend App Service | `app-abenslimane-quiz` |
| Frontend Static Web App | `swa-abenslimane-quiz` |

## Régions/

La majorité des ressources sont déployées dans :

```text
France Central
