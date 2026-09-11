-- CS50 SQL — Week 6: Scaling
-- lecture.sql
-- Queries demonstrated in the CS50 SQL Week 6 lecture.
-- MySQL and PostgreSQL commands are included in their respective sections.
-- Shell commands such as mysql/psql connection commands are shown as comments.

-- =========================================================
-- MYSQL
-- =========================================================

-- Connect to MySQL from the terminal:
-- mysql -u root -h 127.0.0.1 -P 3306 -p

-- Show databases
SHOW DATABASES;

-- Create the MBTA database
CREATE DATABASE `mbta`;

-- Select the database
USE `mbta`;

-- Create cards table
CREATE TABLE `cards` (
    `id` INT AUTO_INCREMENT,
    PRIMARY KEY(`id`)
);

-- View all tables
SHOW TABLES;

-- Describe the cards table
DESCRIBE `cards`;

-- Create stations table
CREATE TABLE `stations` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL UNIQUE,
    `line` ENUM('blue', 'green', 'orange', 'red') NOT NULL,
    PRIMARY KEY(`id`)
);

-- Describe the stations table
DESCRIBE `stations`;

-- Create swipes table
CREATE TABLE `swipes` (
    `id` INT AUTO_INCREMENT,
    `card_id` INT,
    `station_id` INT,
    `type` ENUM('enter', 'exit', 'deposit') NOT NULL,
    `datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `amount` DECIMAL(5,2) NOT NULL CHECK(`amount` != 0),
    PRIMARY KEY(`id`),
    FOREIGN KEY(`station_id`) REFERENCES `stations`(`id`),
    FOREIGN KEY(`card_id`) REFERENCES `cards`(`id`)
);

-- Describe the swipes table
DESCRIBE `swipes`;

-- Add the silver line to the stations table
ALTER TABLE `stations`
MODIFY `line` ENUM('blue', 'green', 'orange', 'red', 'silver') NOT NULL;

-- =========================================================
-- STORED PROCEDURES
-- =========================================================

-- Select the MFA database
USE `mfa`;

-- Add a deleted column for soft deletion
ALTER TABLE `collections`
ADD COLUMN `deleted` TINYINT DEFAULT 0;

-- Change delimiter so the stored procedure can contain semicolons
DELIMITER //

-- Create procedure to show current collections
CREATE PROCEDURE `current_collection`()
BEGIN
    SELECT `title`, `accession_number`, `acquired`
    FROM `collections`
    WHERE `deleted` = 0;
END//

-- Reset delimiter
DELIMITER ;

-- Call the procedure
CALL current_collection();

-- Soft-delete an artwork
UPDATE `collections`
SET `deleted` = 1
WHERE `title` = 'Farmers working at dawn';

-- Call the procedure again
CALL current_collection();

-- =========================================================
-- STORED PROCEDURE WITH PARAMETER
-- =========================================================

-- Create transactions table
CREATE TABLE `transactions` (
    `id` INT AUTO_INCREMENT,
    `title` VARCHAR(64) NOT NULL,
    `action` ENUM('bought', 'sold') NOT NULL,
    PRIMARY KEY(`id`)
);

-- Change delimiter
DELIMITER //

-- Create sell procedure
CREATE PROCEDURE `sell`(IN `sold_id` INT)
BEGIN
    UPDATE `collections`
    SET `deleted` = 1
    WHERE `id` = `sold_id`;

    INSERT INTO `transactions` (`title`, `action`)
    VALUES (
        (SELECT `title`
         FROM `collections`
         WHERE `id` = `sold_id`),
        'sold'
    );
END//

-- Reset delimiter
DELIMITER ;

-- Sell the artwork with id 2
CALL `sell`(2);

-- =========================================================
-- POSTGRESQL
-- =========================================================

-- Connect to PostgreSQL from the terminal:
-- psql postgresql://postgres@127.0.0.1:5432/postgres

-- List databases
\l

-- Create the MBTA database
CREATE DATABASE "mbta";

-- Connect to the MBTA database
\c "mbta"

-- List tables
\dt

-- Create cards table
CREATE TABLE "cards" (
    "id" SERIAL,
    PRIMARY KEY("id")
);

-- Describe the cards table
\d "cards"

-- Create stations table
CREATE TABLE "stations" (
    "id" SERIAL,
    "name" VARCHAR(32) NOT NULL UNIQUE,
    "line" VARCHAR(32) NOT NULL,
    PRIMARY KEY("id")
);

-- Create an ENUM type for swipe types
CREATE TYPE "swipe_type"
AS ENUM('enter', 'exit', 'deposit');

-- Create swipes table
CREATE TABLE "swipes" (
    "id" SERIAL,
    "card_id" INT,
    "station_id" INT,
    "type" "swipe_type" NOT NULL,
    "datetime" TIMESTAMP NOT NULL DEFAULT now(),
    "amount" NUMERIC(5,2) NOT NULL CHECK("amount" != 0),
    PRIMARY KEY("id"),
    FOREIGN KEY("station_id") REFERENCES "stations"("id"),
    FOREIGN KEY("card_id") REFERENCES "cards"("id")
);

-- Exit PostgreSQL
\q

-- =========================================================
-- ACCESS CONTROLS
-- =========================================================

-- Create a new MySQL user
CREATE USER 'carter' IDENTIFIED BY 'password';

-- Show databases available to the current user
SHOW DATABASES;

-- Grant access to the anonymized analysis view
GRANT SELECT
ON `rideshare`.`analysis`
TO 'carter';

-- =========================================================
-- SQL INJECTION
-- =========================================================

-- Example of an unsafe query
SELECT `id`
FROM `users`
WHERE `user` = 'Carter'
AND `password` = 'password';

-- Example of how malicious input can alter the query
SELECT `id`
FROM `users`
WHERE `user` = 'Carter'
AND `password` = 'password' OR '1' = '1';

-- Example of an attempted UNION-based injection
SELECT *
FROM `accounts`
WHERE `id` = 1
UNION
SELECT *
FROM `accounts`;

-- =========================================================
-- PREPARED STATEMENTS
-- =========================================================

-- Prepare a statement with a placeholder
PREPARE `balance_check`
FROM 'SELECT *
      FROM `accounts`
      WHERE `id` = ?';

-- Set a variable
SET @id = 1;

-- Execute prepared statement
EXECUTE `balance_check`
USING @id;

-- Attempt to pass malicious input as a value
SET @id = '1 UNION SELECT * FROM `accounts`';

-- Execute prepared statement safely
EXECUTE `balance_check`
USING @id;

-- =========================================================
-- NOTES
-- =========================================================

-- Week 6 concepts covered by the queries above:
-- MySQL and PostgreSQL
-- Database servers
-- Data types
-- AUTO_INCREMENT / SERIAL
-- ENUM / SET
-- ALTER TABLE
-- Stored Procedures
-- Stored Procedures with Parameters
-- Scaling
-- Access Controls / GRANT
-- SQL Injection
-- Prepared Statements
dsad