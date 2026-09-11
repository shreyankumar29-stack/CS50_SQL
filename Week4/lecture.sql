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