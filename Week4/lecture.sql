-- uses longlist.db


SELECT "id" FROM "authors"
WHERE "name" = 'Fernanda Melchor';

SELECT "book_id" FROM "authored"
WHERE "author_id" = (
    SELECT "id"
    FROM "authors"
    WHERE "name" = 'Fernanda Melchor'
);

SELECT "title" FROM "books"
WHERE "id" IN (
    SELECT "book_id"
    FROM "authored"
    WHERE "author_id" = (
        SELECT "id"
        FROM "authors"
        WHERE "name" = 'Fernanda Melchor'
    )
);

-- Join the tables to get the titles of books authored by Fernanda Melchor
SELECT "name","title" FROM "authors"
JOIN "authored" ON "authors"."id"= "authored"."author_id" 
JOIN "books" ON "authored"."book_id" = "books"."id";

CREATE VIEW "longlist" AS
SELECT "name","title" FROM "authors"
JOIN "authored" ON "authors"."id"= "authored"."author_id" 
JOIN "books" ON "books"."id" = "authored"."book_id";

-- To drop View
DROP VIEW "longlist";

SELECT * FROM "longlist";

-- Simplified query to get the titles of books authored by Fernanda Melchor using the view
SELECT "title" FROM "longlist"
WHERE "name" = 'Fernanda Melchor';

--

SELECT "name","title" FROM "longlist"
ORDER BY "title";

-- AGGREGATING

-- Demonstrates views for aggregating data
-- Uses longlist.db

-- Views ratings table
SELECT * FROM "ratings";

-- Returns book IDs and unrounded ratings
SELECT "book_id", AVG("rating") AS "rating" FROM "ratings"
GROUP BY "book_id";

-- Returns book IDs and rounded ratings
SELECT "book_id", ROUND(AVG("rating"), 2) AS "rating" FROM "ratings"
GROUP BY "book_id";

-- Adds book IDs, rounded ratings, title, and year columns
SELECT "book_id", "title", "year", ROUND(AVG("rating"), 2) AS "rating" FROM "ratings"
JOIN "books" ON "ratings"."book_id" = "books"."id"
GROUP BY "book_id";

-- Defines book IDs, rounded ratings, title, and year columns as a view
CREATE VIEW "average_book_ratings" AS
SELECT "book_id" AS "id", "title", "year", ROUND(AVG("rating"), 2) AS "rating" FROM "ratings"
JOIN "books" ON "ratings"."book_id" = "books"."id"
GROUP BY "book_id";

-- Finds average book ratings by year nominated
SELECT "year", ROUND(AVG("rating"), 2) AS "rating" FROM "average_book_ratings" 
GROUP BY "year";

-- Creates temporary view of average ratings by year
CREATE TEMPORARY VIEW "average_ratings_by_year" ("year", "rating") AS
SELECT "year", ROUND(AVG("rating"), 2) AS "rating" FROM "average_book_ratings" 
GROUP BY "year";

-- Drops the view "average_book_ratings"
DROP VIEW "average_book_ratings";

-- Shows that CTEs are views accessible for the duration of a query
WITH "average_book_ratings" AS (
    SELECT "book_id",
           "title",
           "year",
           ROUND(AVG("rating"), 2) AS "rating"
    FROM "ratings"
    JOIN "books"
        ON "ratings"."book_id" = "books"."id"
    GROUP BY "book_id"
)
SELECT "year",
       ROUND(AVG("rating"), 2) AS "rating"
FROM "average_book_ratings"
GROUP BY "year";

-- Partitoning

-- queries for 2022 longlisted books
SELECT "id", "title" FROM "books"
WHERE "year" = 2022;

-- Creates view of 2022 longlisted books

CREATE VIEW "2022" AS
SELECT "id", "title" FROM "books"
WHERE "year" = 2022;

SELECT * FROM "2022";

-- Queries for 2021 longlisted books
SELECT "id", "title" FROM "books"
WHERE "year" = 2021;

-- Creates view of 2021 longlisted books
CREATE VIEW "2021" AS
SELECT "id", "title" FROM "books"
WHERE "year" = 2021;

-- Demonstrates views for securing data
-- Uses rideshare.db

CREATE TABLE "rides" (
    "id" INTEGER,
    "origin" TEXT NOT NULL,
    "destination" INTEGER NOT NULL,
    "rider" TEXT NOT NULL,
    PRIMARY KEY("id")
);

INSERT INTO "rides" ("origin", "destination", "rider")
VALUES
('Good Egg Galaxy', 'Honeyhive Galaxy', 'Peach'),
('Castle Courtyard', 'Cascade Kingdom', 'Mario'),
('Metro Kingdom', 'Mushroom Kingdom', 'Luigi'),
('Seaside Kingdom', 'Deep Woods', 'Bowser');

-- Reveals all rides information
SELECT * FROM "rides";

-- Reveals only subset of columns
SELECT "id", "origin", "destination" FROM "rides";

-- Makes clear that rider is anonymous
SELECT "id", "origin", "destination", 'Anonymous' AS "rider" FROM "rides";

-- Creates a view
CREATE VIEW "analysis" AS
SELECT "id", "origin", "destination", 'Anonymous' AS "rider" FROM "rides";

-- Queries the view
SELECT "origin", "destination", "rider" FROM "analysis";

-- Demonstrates soft deletions
-- Uses mfa.db


-- View data in the "collections" table

SELECT * FROM "collections";


-- View schema of the "collections" table

.schema collections


-- Add a "deleted" column to the "collections" table
-- Default value is 0, meaning the item is not deleted

ALTER TABLE "collections"
ADD COLUMN "deleted" INTEGER DEFAULT 0;


-- View updated data in the "collections" table

SELECT * FROM "collections";


-- View updated schema of the "collections" table

.schema collections


-- Instead of physically deleting an item,
-- update its "deleted" column to 1

UPDATE "collections"
SET "deleted" = 1
WHERE "title" = 'Farmers working at dawn';


-- Select only items from "collections" that are NOT deleted

SELECT *
FROM "collections"
WHERE "deleted" = 0;


-- Create a view to show only non-deleted items

CREATE VIEW "current_collections" AS
SELECT "id", "title", "accession_number", "acquired"
FROM "collections"
WHERE "deleted" = 0;


-- Select from "current_collections"
-- to see only non-deleted items

SELECT * FROM "current_collections";


-- Attempt to delete an item from the view
-- This initially fails because views cannot normally be deleted from directly

DELETE FROM "current_collections"
WHERE "title" = 'Imaginative landscape';


-- Create a trigger that allows DELETE operations on the view
-- Instead of deleting the row, it performs a soft deletion
-- on the underlying "collections" table

CREATE TRIGGER "delete"

INSTEAD OF DELETE ON "current_collections"

FOR EACH ROW

BEGIN

    UPDATE "collections"
    SET "deleted" = 1
    WHERE "id" = OLD."id";

END;


-- Create a trigger to revert an item's deletion
-- If the accession number already exists in "collections",
-- set "deleted" back to 0

CREATE TRIGGER "insert_when_exists"

INSTEAD OF INSERT ON "current_collections"

FOR EACH ROW

WHEN NEW."accession_number" IN (
    SELECT "accession_number"
    FROM "collections"
)

BEGIN

    UPDATE "collections"
    SET "deleted" = 0
    WHERE "accession_number" = NEW."accession_number";

END;


-- Create a trigger to insert a new item into "collections"
-- if the accession number does not already exist

CREATE TRIGGER "insert_when_new"

INSTEAD OF INSERT ON "current_collections"

FOR EACH ROW

WHEN NEW."accession_number" NOT IN (
    SELECT "accession_number"
    FROM "collections"
)

BEGIN

    INSERT INTO "collections"
        ("title", "accession_number", "acquired")

    VALUES
        (NEW."title", NEW."accession_number", NEW."acquired");

END;


