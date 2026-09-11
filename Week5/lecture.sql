-- CS50 SQL — Week 5: Optimizing
-- lecture.sql
-- Queries and SQLite commands demonstrated in the Week 5 lecture.
-- Shell commands are kept as comments where they were used to open/check databases.

-- =========================================================
-- IMDb DATABASE / INDEXES
-- =========================================================

-- Open the IMDb database
-- sqlite3 movies.db

-- Show the database schema
.schema

-- Peek at the first 5 movies
SELECT *
FROM "movies"
LIMIT 5;

-- Find the movie titled Cars
SELECT *
FROM "movies"
WHERE "title" = 'Cars';

-- Turn on query timing
.timer on

-- Rerun the Cars query with timing enabled
SELECT *
FROM "movies"
WHERE "title" = 'Cars';

-- Create an index on the movie title
CREATE INDEX "title_index"
ON "movies" ("title");

-- Rerun the Cars query using the index
SELECT *
FROM "movies"
WHERE "title" = 'Cars';

-- Show SQLite's query plan
EXPLAIN QUERY PLAN
SELECT *
FROM "movies"
WHERE "title" = 'Cars';

-- Drop the title index
DROP INDEX "title_index";

-- Verify the schema after dropping the index
.schema

-- Show the query plan without the title index
EXPLAIN QUERY PLAN
SELECT *
FROM "movies"
WHERE "title" = 'Cars';


-- =========================================================
-- INDEXES ACROSS MULTIPLE TABLES
-- =========================================================

-- Find all movies in which Tom Hanks starred
SELECT "title"
FROM "movies"
WHERE "id" IN (
    SELECT "movie_id"
    FROM "stars"
    WHERE "person_id" = (
        SELECT "id"
        FROM "people"
        WHERE "name" = 'Tom Hanks'
    )
);

-- Explain the query plan
EXPLAIN QUERY PLAN
SELECT "title"
FROM "movies"
WHERE "id" IN (
    SELECT "movie_id"
    FROM "stars"
    WHERE "person_id" = (
        SELECT "id"
        FROM "people"
        WHERE "name" = 'Tom Hanks'
    )
);

-- Create an index on person_id in stars
CREATE INDEX "person_index"
ON "stars" ("person_id");

-- Create an index on name in people
CREATE INDEX "name_index"
ON "people" ("name");

-- Check the optimized query plan
EXPLAIN QUERY PLAN
SELECT "title"
FROM "movies"
WHERE "id" IN (
    SELECT "movie_id"
    FROM "stars"
    WHERE "person_id" = (
        SELECT "id"
        FROM "people"
        WHERE "name" = 'Tom Hanks'
    )
);

-- Drop the old person index
DROP INDEX "person_index";

-- Create a covering index containing person_id and movie_id
CREATE INDEX "person_index"
ON "stars" ("person_id", "movie_id");

-- Check the query plan with the covering index
EXPLAIN QUERY PLAN
SELECT "title"
FROM "movies"
WHERE "id" IN (
    SELECT "movie_id"
    FROM "stars"
    WHERE "person_id" = (
        SELECT "id"
        FROM "people"
        WHERE "name" = 'Tom Hanks'
    )
);

-- Turn timing on (if not already enabled)
.timer on

-- Run the optimized Tom Hanks query
SELECT "title"
FROM "movies"
WHERE "id" IN (
    SELECT "movie_id"
    FROM "stars"
    WHERE "person_id" = (
        SELECT "id"
        FROM "people"
        WHERE "name" = 'Tom Hanks'
    )
);


-- =========================================================
-- PARTIAL INDEX
-- =========================================================

-- Create a partial index for movies released in 2023
CREATE INDEX "recents"
ON "movies" ("title")
WHERE "year" = 2023;

-- Find titles of movies released in 2023
SELECT "title"
FROM "movies"
WHERE "year" = 2023;

-- Check whether the partial index is used
EXPLAIN QUERY PLAN
SELECT "title"
FROM "movies"
WHERE "year" = 2023;

-- Check a query for a year not included in the partial index
EXPLAIN QUERY PLAN
SELECT "title"
FROM "movies"
WHERE "year" = 1998;

-- View indexes in the schema
.schema

-- Drop the indexes used in the lecture
DROP INDEX "person_index";
DROP INDEX "name_index";
DROP INDEX "recents";


-- =========================================================
-- VACUUM / DATABASE SPACE
-- =========================================================

-- Check the database size in a terminal
-- du -b movies.db

-- Recheck the schema after dropping indexes
.schema

-- Reclaim unused space
VACUUM;

-- Check the database size again in a terminal
-- du -b movies.db


-- =========================================================
-- CONCURRENCY / TRANSACTIONS
-- =========================================================

-- Open the bank database
-- sqlite3 bank.db

-- Show the bank database schema
.schema

-- View account balances
SELECT *
FROM "accounts";

-- ---------------------------------------------------------
-- Demonstration of an incomplete transfer (without a transaction)
-- ---------------------------------------------------------

-- Add $10 to Bob (Bob's id = 2)
UPDATE "accounts"
SET "balance" = "balance" + 10
WHERE "id" = 2;

-- From another connection, view the intermediate state
-- SELECT * FROM "accounts";

-- Subtract $10 from Alice (Alice's id = 1)
UPDATE "accounts"
SET "balance" = "balance" - 10
WHERE "id" = 1;

-- From another connection, view the completed state
-- SELECT * FROM "accounts";


-- ---------------------------------------------------------
-- Reset the balances for the transaction demonstration
-- ---------------------------------------------------------

-- Give Alice back $10
UPDATE "accounts"
SET "balance" = "balance" + 10
WHERE "id" = 1;

-- Take $10 back from Bob
UPDATE "accounts"
SET "balance" = "balance" - 10
WHERE "id" = 2;

-- Verify the original balances
SELECT *
FROM "accounts";


-- =========================================================
-- TRANSACTION WITH COMMIT
-- =========================================================

-- Begin a transaction
BEGIN TRANSACTION;

-- Add $10 to Bob
UPDATE "accounts"
SET "balance" = "balance" + 10
WHERE "id" = 2;

-- From another connection, this change is not yet visible
-- SELECT * FROM "accounts";

-- Subtract $10 from Alice
UPDATE "accounts"
SET "balance" = "balance" - 10
WHERE "id" = 1;

-- Commit the transaction
COMMIT;

-- From another connection, view the committed balances
-- SELECT * FROM "accounts";


-- =========================================================
-- ROLLBACK / CONSTRAINT FAILURE
-- =========================================================

-- View the current balances
SELECT *
FROM "accounts";

-- Bob receives $10 first
UPDATE "accounts"
SET "balance" = "balance" + 10
WHERE "id" = 2;

-- This update fails because Alice would have a negative balance
-- (when executed with Alice's balance at 0)
UPDATE "accounts"
SET "balance" = "balance" - 10
WHERE "id" = 1;

-- Since no transaction was used above, manually undo Bob's change
UPDATE "accounts"
SET "balance" = "balance" - 10
WHERE "id" = 2;


-- ---------------------------------------------------------
-- Perform the same operation inside a transaction
-- ---------------------------------------------------------

BEGIN TRANSACTION;

-- Add $10 to Bob
UPDATE "accounts"
SET "balance" = "balance" + 10
WHERE "id" = 2;

-- This fails because Alice would have a negative balance
UPDATE "accounts"
SET "balance" = "balance" - 10
WHERE "id" = 1;

-- Undo all changes made in the transaction
ROLLBACK;

-- Verify that the balances returned to their previous state
SELECT *
FROM "accounts";


-- =========================================================
-- EXCLUSIVE TRANSACTION / LOCKS
-- =========================================================

-- Begin an exclusive transaction
BEGIN EXCLUSIVE TRANSACTION;

-- From another connection, try to read the database.
-- This results in: database is locked
-- SELECT * FROM "accounts";

-- Exit/finish the exclusive transaction as needed.
-- COMMIT;
-- or
-- ROLLBACK;
