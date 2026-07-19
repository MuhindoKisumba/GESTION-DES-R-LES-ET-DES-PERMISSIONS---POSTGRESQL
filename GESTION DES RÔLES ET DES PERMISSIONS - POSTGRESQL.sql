/****************************************************************************************************
* GESTION DES RÔLES ET DES PERMISSIONS - POSTGRESQL
* Compatible PostgreSQL 13 / 14 / 15 / 16 / 17
* Auteur : MUHINDO KISUMBA ABDIEL
*
* DESCRIPTION
* -----------
* Ce script crée :
*  - Les rôles système
*  - Les utilisateurs
*  - Les permissions
*  - Les privilèges sur les tables
*  - Les privilèges sur les séquences
*  - Les privilèges sur les fonctions
*  - Les privilèges par défaut
*  - Quelques exemples de vérification
****************************************************************************************************/

------------------------------------------------------------
-- 1. SUPPRESSION (facultative)
------------------------------------------------------------

DROP ROLE IF EXISTS administrateur;
DROP ROLE IF EXISTS directeur;
DROP ROLE IF EXISTS chef_service;
DROP ROLE IF EXISTS agent;
DROP ROLE IF EXISTS auditeur;
DROP ROLE IF EXISTS lecteur;

DROP ROLE IF EXISTS admin_user;
DROP ROLE IF EXISTS directeur_user;
DROP ROLE IF EXISTS chef_user;
DROP ROLE IF EXISTS agent_user;
DROP ROLE IF EXISTS audit_user;
DROP ROLE IF EXISTS lecture_user;

------------------------------------------------------------
-- 2. CREATION DES ROLES
------------------------------------------------------------

CREATE ROLE administrateur NOLOGIN;
CREATE ROLE directeur NOLOGIN;
CREATE ROLE chef_service NOLOGIN;
CREATE ROLE agent NOLOGIN;
CREATE ROLE auditeur NOLOGIN;
CREATE ROLE lecteur NOLOGIN;

------------------------------------------------------------
-- 3. CREATION DES UTILISATEURS
------------------------------------------------------------

CREATE USER admin_user
WITH
LOGIN
PASSWORD 'Admin@2026';

CREATE USER directeur_user
WITH
LOGIN
PASSWORD 'Directeur@2026';

CREATE USER chef_user
WITH
LOGIN
PASSWORD 'Chef@2026';

CREATE USER agent_user
WITH
LOGIN
PASSWORD 'Agent@2026';

CREATE USER audit_user
WITH
LOGIN
PASSWORD 'Audit@2026';

CREATE USER lecture_user
WITH
LOGIN
PASSWORD 'Lecture@2026';

------------------------------------------------------------
-- 4. ASSOCIATION UTILISATEUR -> ROLE
------------------------------------------------------------

GRANT administrateur TO admin_user;
GRANT directeur TO directeur_user;
GRANT chef_service TO chef_user;
GRANT agent TO agent_user;
GRANT auditeur TO audit_user;
GRANT lecteur TO lecture_user;

------------------------------------------------------------
-- 5. DROITS SUR LA BASE
------------------------------------------------------------

GRANT CONNECT ON DATABASE postgres TO administrateur;
GRANT CONNECT ON DATABASE postgres TO directeur;
GRANT CONNECT ON DATABASE postgres TO chef_service;
GRANT CONNECT ON DATABASE postgres TO agent;
GRANT CONNECT ON DATABASE postgres TO auditeur;
GRANT CONNECT ON DATABASE postgres TO lecteur;

------------------------------------------------------------
-- 6. DROITS SUR LE SCHEMA PUBLIC
------------------------------------------------------------

GRANT USAGE ON SCHEMA public TO administrateur;
GRANT USAGE ON SCHEMA public TO directeur;
GRANT USAGE ON SCHEMA public TO chef_service;
GRANT USAGE ON SCHEMA public TO agent;
GRANT USAGE ON SCHEMA public TO auditeur;
GRANT USAGE ON SCHEMA public TO lecteur;

------------------------------------------------------------
-- 7. DROITS SUR LES TABLES
------------------------------------------------------------

-- Administrateur
GRANT ALL PRIVILEGES
ON ALL TABLES IN SCHEMA public
TO administrateur;

-- Directeur
GRANT
SELECT,
INSERT,
UPDATE,
DELETE
ON ALL TABLES IN SCHEMA public
TO directeur;

-- Chef de service
GRANT
SELECT,
INSERT,
UPDATE
ON ALL TABLES IN SCHEMA public
TO chef_service;

-- Agent
GRANT
SELECT,
INSERT
ON ALL TABLES IN SCHEMA public
TO agent;

-- Auditeur
GRANT
SELECT
ON ALL TABLES IN SCHEMA public
TO auditeur;

-- Lecteur
GRANT
SELECT
ON ALL TABLES IN SCHEMA public
TO lecteur;

------------------------------------------------------------
-- 8. DROITS SUR LES SEQUENCES
------------------------------------------------------------

GRANT ALL PRIVILEGES
ON ALL SEQUENCES IN SCHEMA public
TO administrateur;

GRANT
USAGE,
SELECT
ON ALL SEQUENCES IN SCHEMA public
TO directeur;

GRANT
USAGE,
SELECT
ON ALL SEQUENCES IN SCHEMA public
TO chef_service;

GRANT
USAGE
ON ALL SEQUENCES IN SCHEMA public
TO agent;

GRANT
SELECT
ON ALL SEQUENCES IN SCHEMA public
TO auditeur;

GRANT
SELECT
ON ALL SEQUENCES IN SCHEMA public
TO lecteur;

------------------------------------------------------------
-- 9. DROITS SUR LES FONCTIONS
------------------------------------------------------------

GRANT ALL PRIVILEGES
ON ALL FUNCTIONS IN SCHEMA public
TO administrateur;

GRANT EXECUTE
ON ALL FUNCTIONS IN SCHEMA public
TO directeur;

GRANT EXECUTE
ON ALL FUNCTIONS IN SCHEMA public
TO chef_service;

GRANT EXECUTE
ON ALL FUNCTIONS IN SCHEMA public
TO agent;

GRANT EXECUTE
ON ALL FUNCTIONS IN SCHEMA public
TO auditeur;

GRANT EXECUTE
ON ALL FUNCTIONS IN SCHEMA public
TO lecteur;

------------------------------------------------------------
-- 10. PRIVILEGES PAR DEFAUT
------------------------------------------------------------

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL
ON TABLES
TO administrateur;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT
SELECT,
INSERT,
UPDATE,
DELETE
ON TABLES
TO directeur;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT
SELECT,
INSERT,
UPDATE
ON TABLES
TO chef_service;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT
SELECT,
INSERT
ON TABLES
TO agent;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT
SELECT
ON TABLES
TO auditeur;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT
SELECT
ON TABLES
TO lecteur;

------------------------------------------------------------
-- 11. ATTRIBUTS SPECIAUX
------------------------------------------------------------

ALTER ROLE administrateur CREATEDB;
ALTER ROLE administrateur CREATEROLE;

ALTER ROLE directeur NOINHERIT;
ALTER ROLE chef_service NOINHERIT;
ALTER ROLE agent NOINHERIT;
ALTER ROLE auditeur NOINHERIT;
ALTER ROLE lecteur NOINHERIT;

------------------------------------------------------------
-- 12. EXEMPLES DE RESTRICTIONS
------------------------------------------------------------

REVOKE DELETE
ON ALL TABLES IN SCHEMA public
FROM agent;

REVOKE UPDATE
ON ALL TABLES IN SCHEMA public
FROM lecteur;

------------------------------------------------------------
-- 13. AFFICHAGE DES ROLES
------------------------------------------------------------

SELECT
rolname,
rolsuper,
rolcreatedb,
rolcreaterole,
rolcanlogin
FROM pg_roles
ORDER BY rolname;

------------------------------------------------------------
-- 14. MEMBRES DES ROLES
------------------------------------------------------------

SELECT
pg_get_userbyid(roleid) AS role,
pg_get_userbyid(member) AS utilisateur
FROM pg_auth_members
ORDER BY role;

------------------------------------------------------------
-- 15. PRIVILEGES SUR LES TABLES
------------------------------------------------------------

SELECT
grantee,
table_name,
privilege_type
FROM information_schema.role_table_grants
ORDER BY
grantee,
table_name,
privilege_type;

------------------------------------------------------------
-- 16. PRIVILEGES SUR LES SEQUENCES
------------------------------------------------------------

SELECT
grantee,
object_name,
privilege_type
FROM information_schema.usage_privileges
ORDER BY
grantee,
object_name;

------------------------------------------------------------
-- 17. TESTS DE CONNEXION
------------------------------------------------------------

-- SET ROLE agent;
-- SELECT CURRENT_USER;
-- RESET ROLE;

-- SET ROLE directeur;
-- SELECT CURRENT_USER;
-- RESET ROLE;

-- SET ROLE administrateur;
-- SELECT CURRENT_USER;
-- RESET ROLE;

------------------------------------------------------------
-- 18. COMMENTAIRES
------------------------------------------------------------

COMMENT ON ROLE administrateur IS
'Accès complet à la base de données';

COMMENT ON ROLE directeur IS
'Gestion opérationnelle complète';

COMMENT ON ROLE chef_service IS
'Gestion des données sans suppression';

COMMENT ON ROLE agent IS
'Saisie et consultation';

COMMENT ON ROLE auditeur IS
'Consultation uniquement';

COMMENT ON ROLE lecteur IS
'Lecture seule';

------------------------------------------------------------
-- FIN DU SCRIPT
------------------------------------------------------------