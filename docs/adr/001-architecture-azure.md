# ADR 001 - Choix de l'architecture Azure

## Statut

Accepté

## Contexte

Le projet Azure Quiz est composé :

- d'un frontend Angular ;
- d'un backend Spring Boot ;
- d'une base de données PostgreSQL ;
- d'un cache Redis ;
- d'un stockage Blob.

L'objectif est de déployer l'application sur Azure en utilisant Terraform pour l'infrastructure et GitHub Actions pour automatiser les déploiements.

## Décision

### Backend : Azure App Service

Le backend Spring Boot est déployé sur Azure App Service.

App Service a été choisi car il permet d'héberger facilement une application web sans avoir à administrer directement des machines virtuelles ou un cluster Kubernetes.

Le projet utilise le plan App Service partagé fourni dans le cadre de la formation.

### Frontend : Azure Static Web Apps

Le frontend Angular est hébergé avec Azure Static Web Apps.

Ce service est adapté à une application frontend statique et permet de séparer clairement le frontend du backend.

### Base de données : PostgreSQL Flexible Server

Azure Database for PostgreSQL Flexible Server est utilisé pour la base de données.

Le choix d'un service managé évite d'avoir à installer et administrer PostgreSQL sur une machine virtuelle.

### Cache : Azure Managed Redis

Redis est utilisé comme système de cache pour le backend.

Une instance Azure Managed Redis permet d'utiliser Redis sans gérer directement le serveur.

### Stockage : Azure Blob Storage

Azure Blob Storage est utilisé pour le stockage des résultats de quiz.

L'accès depuis le backend est réalisé avec une Managed Identity et des droits RBAC.

### Secrets : Azure Key Vault

Les informations sensibles comme le mot de passe PostgreSQL et la clé API sont stockées dans Azure Key Vault.

Cela évite de placer directement ces valeurs dans le code source.

### Infrastructure : Terraform

Terraform est utilisé pour créer et gérer l'infrastructure Azure.

Le state Terraform est stocké à distance dans Azure Blob Storage afin de ne pas conserver le fichier de state dans le dépôt Git.

### CI/CD : GitHub Actions

GitHub Actions automatise les tests, les contrôles de sécurité et les déploiements du frontend et du backend.

L'authentification entre GitHub Actions et Azure utilise OIDC.

Ce choix évite de stocker un secret Azure longue durée dans GitHub.

## Conséquences

Cette architecture permet :

- de séparer le frontend et le backend ;
- d'utiliser principalement des services Azure managés ;
- de gérer l'infrastructure avec du code ;
- d'automatiser les déploiements ;
- de centraliser les secrets dans Key Vault ;
- de limiter l'utilisation de secrets permanents grâce à OIDC et aux Managed Identities.

En contrepartie, l'application dépend de plusieurs services Azure et nécessite une configuration correcte des droits RBAC, du réseau et des variables d'environnement.
