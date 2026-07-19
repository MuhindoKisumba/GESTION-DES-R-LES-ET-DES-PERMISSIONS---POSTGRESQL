# README – Gestion des Rôles et des Permissions PostgreSQL

## Description

Ce projet fournit un script SQL permettant de mettre en place une gestion complète des rôles, des utilisateurs et des permissions dans PostgreSQL.

Le script est compatible avec PostgreSQL 13, 14, 15, 16 et 17.

Auteur : MUHINDO KISUMBA ABDIEL

---

# Objectifs

Ce script permet de :

- Créer les rôles métiers.
- Créer les utilisateurs de connexion.
- Associer les utilisateurs à leurs rôles.
- Gérer les privilèges sur la base de données.
- Gérer les privilèges sur les schémas.
- Gérer les privilèges sur les tables.
- Gérer les privilèges sur les séquences.
- Gérer les privilèges sur les fonctions.
- Configurer les privilèges par défaut.
- Restreindre certains accès.
- Vérifier les rôles et permissions existants.

---

# Contenu du script

Le script est organisé en 18 parties.

## 1. Suppression des rôles

Suppression des anciens rôles et utilisateurs afin de permettre une nouvelle installation sans conflit.

Commande utilisée :

```sql
DROP ROLE IF EXISTS ...
```

---

## 2. Création des rôles

Création des rôles fonctionnels.

Les rôles créés sont :

- administrateur
- directeur
- chef_service
- agent
- auditeur
- lecteur

Ces rôles sont créés avec l'option :

```sql
NOLOGIN
```

Ils ne peuvent donc pas se connecter directement.

---

## 3. Création des utilisateurs

Création des comptes PostgreSQL.

Utilisateurs créés :

- admin_user
- directeur_user
- chef_user
- agent_user
- audit_user
- lecture_user

Chaque utilisateur possède :

- LOGIN
- PASSWORD

---

## 4. Attribution des rôles

Association entre les utilisateurs et leurs rôles.

Exemple :

```sql
GRANT administrateur TO admin_user;
```

Ainsi un utilisateur hérite automatiquement des permissions de son rôle.

---

## 5. Permissions sur la base

Autorisation de connexion.

Commande utilisée :

```sql
GRANT CONNECT
```

Tous les rôles peuvent accéder à la base de données.

---

## 6. Permissions sur le schéma

Autorisation d'utiliser le schéma public.

Commande :

```sql
GRANT USAGE ON SCHEMA public
```

---

## 7. Permissions sur les tables

Chaque rôle reçoit un niveau d'accès différent.

### Administrateur

Permissions :

- SELECT
- INSERT
- UPDATE
- DELETE
- TRUNCATE
- REFERENCES
- TRIGGER

Commande :

```sql
GRANT ALL PRIVILEGES
```

---

### Directeur

Permissions :

- SELECT
- INSERT
- UPDATE
- DELETE

---

### Chef de service

Permissions :

- SELECT
- INSERT
- UPDATE

---

### Agent

Permissions :

- SELECT
- INSERT

---

### Auditeur

Permission :

- SELECT

---

### Lecteur

Permission :

- SELECT

---

# Matrice des permissions

| Rôle | SELECT | INSERT | UPDATE | DELETE |
|------|:------:|:------:|:------:|:------:|
| Administrateur | Oui | Oui | Oui | Oui |
| Directeur | Oui | Oui | Oui | Oui |
| Chef de service | Oui | Oui | Oui | Non |
| Agent | Oui | Oui | Non | Non |
| Auditeur | Oui | Non | Non | Non |
| Lecteur | Oui | Non | Non | Non |

---

## 8. Permissions sur les séquences

Gestion des séquences PostgreSQL.

Permissions attribuées :

- ALL
- USAGE
- SELECT

selon le rôle.

---

## 9. Permissions sur les fonctions

Gestion de l'exécution des fonctions.

Commande utilisée :

```sql
GRANT EXECUTE
```

Seul l'administrateur possède tous les privilèges.

---

## 10. Privilèges par défaut

Les nouvelles tables héritent automatiquement des permissions.

Commande utilisée :

```sql
ALTER DEFAULT PRIVILEGES
```

Cela évite de redonner les droits après chaque création de table.

---

## 11. Attributs spéciaux

Le rôle administrateur obtient :

```text
CREATEDB
CREATEROLE
```

Les autres rôles utilisent :

```text
NOINHERIT
```

afin de limiter les privilèges.

---

## 12. Restrictions

Le script retire volontairement certains droits.

Exemples :

L'agent ne peut pas supprimer les données.

```sql
REVOKE DELETE
```

Le lecteur ne peut pas modifier les données.

```sql
REVOKE UPDATE
```

---

## 13. Vérification des rôles

Affichage des rôles PostgreSQL.

Informations affichées :

- Nom
- Super utilisateur
- Création de base
- Création de rôle
- Connexion autorisée

Table système utilisée :

```sql
pg_roles
```

---

## 14. Vérification des membres

Affichage des associations :

- utilisateur
- rôle

Table système utilisée :

```sql
pg_auth_members
```

---

## 15. Vérification des permissions

Consultation des privilèges sur les tables.

Vue utilisée :

```sql
information_schema.role_table_grants
```

---

## 16. Vérification des séquences

Consultation des privilèges sur les séquences.

Vue utilisée :

```sql
information_schema.usage_privileges
```

---

## 17. Tests

Le script contient des exemples permettant de tester les rôles.

Exemple :

```sql
SET ROLE agent;

SELECT CURRENT_USER;

RESET ROLE;
```

---

## 18. Documentation

Chaque rôle reçoit une description grâce à :

```sql
COMMENT ON ROLE
```

Cela facilite l'administration de la base.

---

# Architecture des rôles

```text
                 administrateur
                       │
        ┌──────────────┼──────────────┐
        │              │              │
    directeur     chef_service     auditeur
        │              │
        │              │
      agent        lecteur
```

---

# Sécurité

Le script applique plusieurs bonnes pratiques :

- Séparation des rôles et des utilisateurs.
- Principe du moindre privilège.
- Utilisation des privilèges par défaut.
- Gestion centralisée des autorisations.
- Restriction des opérations sensibles.
- Attribution des droits par rôle.
- Vérification des privilèges.
- Documentation intégrée.

---

# Compatibilité

Le script fonctionne avec :

- PostgreSQL 13
- PostgreSQL 14
- PostgreSQL 15
- PostgreSQL 16
- PostgreSQL 17

Systèmes compatibles :

- Windows
- Linux
- Ubuntu
- Debian
- CentOS
- Fedora
- Rocky Linux

---

# Exécution

Exécution avec psql :

```bash
psql -U postgres -d nom_base -f gestion_roles.sql
```

Ou depuis pgAdmin :

1. Ouvrir Query Tool.
2. Charger le script SQL.
3. Exécuter le script.

---

# Résultat

À la fin de l'exécution, la base dispose :

- de 6 rôles métiers ;
- de 6 utilisateurs ;
- des permissions sur la base ;
- des permissions sur le schéma ;
- des permissions sur les tables ;
- des permissions sur les séquences ;
- des permissions sur les fonctions ;
- des privilèges par défaut ;
- des restrictions de sécurité ;
- des requêtes de contrôle des privilèges ;
- d'une gestion des accès conforme aux bonnes pratiques PostgreSQL.

---

# Auteur

MUHINDO KISUMBA ABDIEL

Licence en Informatique de Gestion

Spécialités :

- Administration PostgreSQL
- SQL Server
- Oracle Database
- MySQL
- Analyse de données
- Administration Systèmes et Réseaux
- Cybersécurité
- Développement d'applications
