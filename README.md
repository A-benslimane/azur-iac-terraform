# Azure Quiz - Infrastructure Terraform

Ce dépôt contient l'infrastructure Azure du projet **Azure Quiz**, déployée avec Terraform.

L'objectif est de déployer une application composée d'un frontend Angular et d'un backend Spring Boot, avec plusieurs services Azure managés.

## Architecture

L'application utilise les services suivants :

- **Azure Static Web Apps** : hébergement du frontend Angular
- **Azure App Service** : hébergement du backend Spring Boot
- **Azure Database for PostgreSQL Flexible Server** : base de données
- **Azure Managed Redis** : cache
- **Azure Storage Account / Blob Storage** : stockage des résultats
- **Azure Key Vault** : stockage des secrets
- **GitHub Actions** : CI/CD
- **Terraform** : création et gestion de l'infrastructure

Flux principal :

```text
Utilisateur
    |
    v
Azure Static Web Apps
    |
    | HTTPS
    v
Azure App Service
    |
    +----> PostgreSQL
    |
    +----> Redis
    |
    +----> Blob Storage
    |
    +----> Key Vault
```

## Infrastructure as Code

Les ressources Azure sont séparées dans plusieurs fichiers Terraform :

```text
terraform/
├── backend.tf
├── frontend.tf
├── postgresql.tf
├── redis.tf
├── storage.tf
├── key-vault.tf
├── data.tf
├── locals.tf
├── outputs.tf
├── providers.tf
├── variables.tf
└── versions.tf
```

Cette séparation permet de garder une configuration plus lisible et plus facile à maintenir.

## State Terraform

Le state Terraform est stocké à distance dans Azure Blob Storage.

- Storage Account : `stabenslimanequiz`
- Container : `tfstate`
- State : `terraform.tfstate`

Cela permet de ne pas stocker le fichier `terraform.tfstate` dans Git.

## Sécurité

Les informations sensibles sont stockées dans **Azure Key Vault**.

Le backend utilise notamment Key Vault pour récupérer :

- le mot de passe PostgreSQL
- l'utilisateur PostgreSQL
- la clé API du backend

L'App Service utilise également une **Managed Identity** pour accéder aux ressources Azure nécessaires.

L'accès au Blob Storage est géré avec Azure RBAC.

Les pipelines GitHub Actions utilisent **OpenID Connect (OIDC)** pour s'authentifier auprès d'Azure sans stocker de secret Azure permanent dans GitHub.

## CI/CD

Les déploiements du frontend et du backend sont automatisés avec GitHub Actions.

### Backend

Lors d'un push sur `main` :

1. build de l'application Spring Boot
2. exécution des tests
3. contrôles de sécurité
4. authentification Azure avec OIDC
5. déploiement vers Azure App Service

### Frontend

Lors d'un push sur `main` :

1. installation des dépendances
2. tests et contrôles qualité
3. récupération de la configuration nécessaire
4. build Angular de production
5. authentification Azure avec OIDC
6. déploiement vers Azure Static Web Apps

Les Pull Requests exécutent les contrôles de build, tests et sécurité sans effectuer de déploiement en production.

## Commandes Terraform

Initialisation :

```bash
terraform init
```

Vérification du format :

```bash
terraform fmt -check
```

Validation :

```bash
terraform validate
```

Prévisualisation des changements :

```bash
terraform plan
```

Déploiement :

```bash
terraform apply
```

## Ressources principales

| Ressource | Nom |
|---|---|
| Resource Group | `abenslimaneRG` |
| App Service | `app-abenslimane-quiz` |
| Static Web App | `swa-abenslimane-quiz` |
| PostgreSQL | `psql-abenslimane-quiz` |
| Database | `quizdb` |
| Redis | `redis-abenslimane-quiz` |
| Storage Account | `stabenslimanequiz` |
| Key Vault | `kv-abenslimane-quiz` |

## Résultat

L'application Angular est déployée sur Azure Static Web Apps et communique avec l'API Spring Boot hébergée sur Azure App Service.

L'infrastructure est reproductible avec Terraform et les déploiements applicatifs sont automatisés avec GitHub Actions.