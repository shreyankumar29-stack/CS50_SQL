-- Those books published By MacLehose press or MacLehose Editions
SELECT "title"
FROM "books"
WHERE "publisher_id"=(
    SELECT "id"
    FROM "publishers"
    WHERE "publisher"='MacLehose Press'
);

-- All the rating of this book called In Memory Of Memory
SELECT "rating"
FROM "ratings"
WHERE "book_id"=(
    SELECT "id"
    FROM "books"
    WHERE "title"='In Memory Of Memory'
);

-- Average Rating of this book

SELECT AVG("rating")
FROM "ratings"
WHERE "book_id" = (
    SELECT "id"
    FROM "books"
    WHERE "title" = 'In Memory of Memory'
);

-- Author Id from the fro the authored
SELECT "author_id"
FROM "authored"
WHERE "book_id" = (
    SELECT "id"
    FROM "books"
    WHERE "title" = 'The Birthday Party'
); 

-- name of the book who wrote the book The Birthday Party
SELECT "name" 
FROM "authors"
WHERE "id" = (
    SELECT "author_id"
    FROM "authored"
    WHERE "book_id" = (
        SELECT "id"
        FROM "books"
        WHERE "title" = 'The Birthday Party'
    )
);

-- author of not just one perhaps multile books, or different versions of the same book
SELECT "book_id"     
FROM "authored"         
WHERE "author_id"=(     
    SELECT "id"   
    FROM "authors"
    WHERE "name" ='Fernanda Melchor'
);

-- find me the titles where the book_id is not equal to but is in the set of id's
SELECT "title"
FROM "books"
WHERE "id" IN (
    SELECT "book_id"      
    FROM "authored"
    WHERE "author_id" = (
        SELECT "id"
        FROM "authors"
        WHERE "name" = 'Fernanda Melchor'
    )   
);

-- JOIN TWO tables from sea_lions.db

SELECT * 
       FROM "sea_lions"
       JOIN "migrations"
       ON "migrations"."id" = "sea_lions"."id";

-- 