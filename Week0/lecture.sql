-- tO RETRIEVE THE DATA FROM THE TABLES
SELECT * FROM "longlist";

-- To retrieve only the "title" column from the "longlist" table
SELECT "title" FROM "longlist";

-- To retrieve the "title" and "author" columns from the "longlist" table
SELECT "title", "author" FROM "longlist";

-- To retrieve the "title", "author", and "translator" columns from the "longlist" table
SELECT "title", "author", "translator" FROM "longlist";

-- LIMIT results to the first 10 rows of the "title" column from the "longlist" table
SELECT "title" FROM "longlist" LIMIT 10;

-- LIMIT results to the first 5 rows of the "title" column from the "longlist" table
SELECT "title" FROM "longlist" LIMIT 5;

-- WHERE clause to filter results based on a condition
SELECT "title", "author" FROM "longlist" WHERE "year" = 2021;

SELECT "title", "author" FROM "longlist" WHERE "year" = 2022;

SELECT "title", "author" FROM "longlist" WHERE "year" =2023;

-- not equal to 
SELECT "title", "author" FROM "longlist" WHERE "format" != 'hardcover';

-- ANOTHER WAY TO WRITE NOT EQUAL TO
SELECT "title", "author" FROM "longlist" WHERE "format" <> 'hardcover';

-- NOT Keyword to filter results that do not match a specific condition
SELECT "title", "author" FROM "longlist" WHERE NOT "format" = 'hardcover';

-- Checks which books are nominated imn year 2022 or 2023
SELECT "title", "author" FROM "longlist" WHERE "year" = 2022 OR "year" = 2023;

SELECT "title", "format" FROM "longlist"
WHERE ("year" = 2022 OR "year" = 2023)
AND "format" = 'hardcover';

-- find the translators whos doesn"t exist in my database
SELECT "title", "translator" FROM "longlist" WHERE "translator" IS NULL;

-- find the translators whos exist in my database
SELECT "title", "translator" FROM "longlist" WHERE "translator" IS NOT NULL;

-- find the books that have title "love" in it
SELECT "title" FROM "longlist" WHERE "title" LIKE '%Love%';

-- if we put percentage sign after the word The, it will find all the books that start with the word "The"
SELECT "title" FROM "longlist" WHERE "title" LIKE 'The%'; 

-- if we put percentage sign before the word The, it will find all the books that end with the word "The"
SELECT "title" FROM "longlist" WHERE "title" LIKE '%The';

-- if I want to find PIRE or PYRE but I don't know which one is correct, I can use the underscore to represent a single character
SELECT "title" FROM "longlist" WHERE "title" LIKE 'P_re';

-- Find books between 2019 and 2022
-- Using many ORs
SELECT "title", "year" FROM "longlist" 
WHERE "year" = 2019 OR "year" = 2020 OR "year" = 2021 OR "year" = 2022;

--Using Operator BETWEEN to find books between 2019 and 2022
SELECT "title", "year" FROM "longlist" WHERE "year" >=2019 AND "year" <=2022;

--- Using Operator BETWEEN to find books between 2019 and 2022
SELECT "title", "year" FROM "longlist" WHERE "year" BETWEEN 2019 AND 2022;

SELECT "title", "rating" FROM "longlist" WHERE "rating" >4.0;

--
SELECT "title", "rating", "votes" FROM "longlist" WHERE "rating" >4.0 AND "votes" >10000;

-- Find the pages less than 300
SELECT "title", "pages" FROM "longlist" 
WHERE "pages" < 300; 


-- Top 10 books in my table
SELECT "title", "rating"  FROM "longlist" ORDER BY "rating" LIMIT 10;

-- Top 10 books in my table (desc)
SELECT "title", "rating"  FROM "longlist" ORDER BY "rating" DESC LIMIT 10;

-- Top 10 books according to the rating and votes of the book in descending order
SELECT "title", "rating", "votes" FROM "longlist" ORDER BY "rating" DESC, "votes" DESC LIMIT 10;

-- Arranging the title in ascending oder
SELECT "title" FROM "longlist" ORDER BY "title";

-- Arranging the title in descending oder
SELECT "title" FROM "longlist" ORDER BY "title" DESC;

-- average rating from my longlist UPTO 2 decimal points
SELECT ROUND(AVG("rating"), 2) AS "average rating"  FROM "longlist";
SELECT AVG("rating") FROM "longlist";
SELECT ROUND(AVG("rating"), 2) FROM "longlist";

-- max rating in my table
SELECT MAX("rating") FROM longlist;

-- min rating in my table
SELECT MIN("rating") FROM longlist;

-- Sum of total votes
SELECT SUM("votes") FROM longlist;

--Find the number of rows in a dataset
SELECT COUNT(*) FROM longlist;

-- Count the number of translators
SELECT COUNT("translator") FROM "longlist";

-- all publishers from my longlist
SELECT COUNT("publisher") FROM "longlist";


-- Find all th distinct publishers fro  the datasets
SELECT COUNT(DISTINCT "publisher") FROM "longlist";