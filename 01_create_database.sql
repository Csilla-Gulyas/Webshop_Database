-- =========================================
-- FILE: 01_create_database.sql
-- PURPOSE: Create the main database for the webshop
-- =========================================
DROP DATABASE IF EXISTS webshop;
CREATE DATABASE IF NOT EXISTS webshop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;