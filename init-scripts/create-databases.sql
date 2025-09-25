-- Создание базы для Keycloak
CREATE DATABASE keycloak_db;
GRANT ALL PRIVILEGES ON DATABASE keycloak_db TO admin;

-- Создание базы для Camunda
CREATE DATABASE camunda_db;
GRANT ALL PRIVILEGES ON DATABASE camunda_db TO admin;

-- Дополнительные настройки для Camunda (опционально)
\c camunda_db;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";