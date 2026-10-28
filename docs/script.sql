-- Script SQL da Império Leste
-- ============================================================
-- Império Leste - Pizzaria e Esfiharia
-- Script SQL completo (MySQL) - Entrega 2
-- ATENÇÃO: as tabelas só devem ser escritas depois que o DER
-- revisado e o modelo lógico estiverem prontos.
-- ============================================================

-- 1) CREATE DATABASE
DROP DATABASE IF EXISTS imperio_leste;
CREATE DATABASE imperio_leste CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE imperio_leste;

-- 2) CREATE TABLE (com tipos de dados adequados)
-- 3) CONSTRAINTS (PK, FK, NOT NULL, UNIQUE, CHECK, DEFAULT)
-- Dica: escrever as tabelas "pai" antes das "filhas" por causa das FKs.
-- Exemplo do formato (NÃO é o modelo final):
-- CREATE TABLE nome_da_tabela (
--     id_exemplo INT AUTO_INCREMENT PRIMARY KEY,
--     nome       VARCHAR(100) NOT NULL
-- );

-- 4) INSERT INTO (massa de dados FICTÍCIA, sem dados reais de clientes)

-- 5) SELECT com JOIN (consultas que cruzam várias tabelas)

-- 6) UPDATE

-- 7) DELETE

-- 8) CONSULTAS GERENCIAIS (uma por problema declarado e por KPI)
-- Formato obrigatório do cabeçalho:
-- G01 — Pergunta em português que a consulta responde?
-- Atende: P1 (falta de sistema de precificação)
-- SELECT ...

-- 9) CONSULTAS DE AUDITORIA (conferem as regras de negócio)
-- Formato obrigatório do cabeçalho:
-- A01 — Pergunta em português que a consulta responde?
-- Verifica: RN01 (texto da regra)
-- SELECT ...
