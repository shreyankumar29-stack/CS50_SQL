## Relational Databases:
A relational database is a database that stores data in multiple tables and connects those tables using relationships.

## One-to-Many Relationship
**Example**:One book is written by one author and one author writes one book.

## One-to-Many Relationship
**Example**:One author can write many books.

## Many-to-Many Relationship
**Example**: One author can write many book and one book can be written by many authors.

## Keys:
Fundamental idea in Database that can help us relate tables one to other.

1. Primary Key: Uniquely identifies the row
2. Foreign Key: taking a primary key, from one table and including it in the column of some other table.

**Example:**

1. books                                         
   |id |isbn|title|                              
   |---|----|-----|                                 
   |1|9788439736967|Boulder|                        
   |2|9780525573067|The White Book|                 
   |3|9781529414431|Standing Heavy|                 
   |4|9781910695432|Flights|                        
in the case of books, every book has a unique identifier called an ISBN. In other words, if you search for a book by its ISBN, only one book will be found. In database terms, the ISBN is a primary key — an identifier that is unique for every item in a table.
Inspired by this idea of an ISBN, we can imagine assigning unique IDs to our publishers, authors and translators! Each of these IDs would be the primary key of the table it belongs to.    


2. ratings
    | ISBN | Rating |
    |---------------|:------:|
    | 9788439736967 | 4 |
    | 9788439736967 | 3 |
    | 9788439736967 | 5 |
    | 9780525573067 | 2 |
    | 9780525573067 | 3 |
    | 9781529414431 | 4 |
    | 9781910695432 | 5 |
    | 9781910695432 | 4 |         

    Notice how the primary key of the books table is now a column in the ratings table. This helps form a one-to-many relationship between the two tables — a book with a title (found in the books table) can have multiple ratings (found in the ratings table).
    The ISBN, as we can see, is a long identifier. If each character occupied a byte of memory, storing a single ISBN (including the dashes) would take 17 bytes of memory, which is a lot!
    we don’t necessarily have to use the ISBN as a primary key. We can just construct our own using numbers like 1, 2, 3… and so on as long as each book has a unique number to identify it.

## SubQuery
One SQL query inside another Query.                    
**Example**:
SELECT "id" 
FROM "publishers"
WHERE "publisher"='Firtzcarraldo Editions';

SELECT "title" 
FROM "books"
WHERE "publisher_id" = 5;

These two queries are not connected and hence cannot be called as subqueries.

Let's combine these queries:

SELECT "title" 
FROM "books"
WHERE "publisher_id" =(
    SELECT "id" 
    FROM "publishers"
    WHERE "publisher"='Firtzcarraldo Editions'
);

The subquery is in parentheses. The query that is furthest inside parantheses will be run first, followed by outer queries.The inner query is indented. This is done as per style conventions for subqueries, to increase readability.

## IN Keyword

1. This keyword is used to check whether the desired value is in a given list or set of values.

**Example**:

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

Note that the innermost query uses = and not the IN operator. This is because we expect to find just one author named Fernanda Melchor.

## JOINS
This keyword allow us to combine one or more table together.

**Example**
1. sea lions table
   |id|name|
   |---|-----|
   |10484|Ayah|
   |11728|Spot|
   |11729|Tiger|
   |11732|Mable|
   |11734|Rick|
   |11790|Jolee|

2. migrations table
   |id|distance|days|
   |--|--------|----|
   |10484|1000|107|
   |11728|1531|56|
   |11729|1370|37|
   |11732|1622|62|
   |11734|1491|58|
   |11735|2723|82|
   |11736|1571|52|
   |11790|1957|92|
   
sqlite>SELECT * 
       FROM "sea_lions";
sqlite>SELECT * 
       FROM "migrations";
sqlite>SELECT * 
       FROM "sea_lions"
       JOIN "migrations"
       ON "sea_lions"."id" = "migrations"."id";


## INNER JOINS:


**Examples:**
Let's break these two table into smaller parts to analyze data clearly.

sea_lions table

|id|name|
|---|-----|
|10484|Ayah|
|11728|Spot|
|11790|Jolee|


migrations table
|id|distance|
|----|------|
|10484|1000|
|11728|1531|
|11735|2723|

After jointing these two tables, the table look likes this:

|id|name|id|distance|
|--|----|--|--------|
|10484|Ayah|10484|1000|
|11728|Spot|11728|1531|
|11790|Jolee|11735|2723|

We notice the in the last row the two id's didn't match, we don't no how much Jolee travels. So in this case we can't find matches for any of the two id's, then these id are not the part of joined table anymore.

## Note:
There is left or right in the Database

## Comparing LEFT, RIGHT and FULL JOINS

**Examples:**

1. LEFT JOIN
   
       SELECT * 
       FROM "sea_lions"
       LEFT JOIN "migrations"
       ON "migrations"."id" = "sea_lions"."id";

| id | name | species | id | distance | days |
|---:|------|---------|---:|---------:|----:|
| 10484 | Ayah | *Zalophus californianus* | 10484 | 1000 | 107 |
| 11728 | Spot | *Zalophus californianus* | 11728 | 1531 | 56 |
| 11729 | Tiger | *Zalophus californianus* | 11729 | 1370 | 37 |
| 11732 | Mabel | *Zalophus californianus* | 11732 | 1622 | 62 |
| 11734 | Rick | *Zalophus californianus* | 11734 | 1491 | 58 |
| 11790 | Jolee | *Zalophus californianus* | NULL | NULL | NULL |

--> Jolee doesn't have a distance or a number of days. We actually haven't tracked data yet for Jolee but we still see them in table.

1. RIGHT JOIN
   
       SELECT * 
       FROM "sea_lions"
       RIGHT JOIN "migrations"
       ON "migrations"."id" = "sea_lions"."id";
       

| id | name | species | id | distance | days |
|---:|------|---------|---:|---------:|----:|
| 10484 | Ayah | *Zalophus californianus* | 10484 | 1000 | 107 |
| 11728 | Spot | *Zalophus californianus* | 11728 | 1531 | 56 |
| 11729 | Tiger | *Zalophus californianus* | 11729 | 1370 | 37 |
| 11732 | Mabel | *Zalophus californianus* | 11732 | 1622 | 62 |
| 11734 | Rick | *Zalophus californianus* | 11734 | 1491 | 58 |
| NULL | NULL | NULL | 11735 | 2723 | 82 |
| NULL | NULL | NULL | 11736 | 1571 | 52 |
| NULL | NULL | NULL | 11737 | 1957 | 92 |

--> We've actually left of sea_lions. We only have those whose id's were in the right table. Again we've don't have names for these sea_lions we still include in our data set. And we can see that we have sone data missing and it has some special value called NULL.

1. FULL JOIN: allow us to allows us to see the entirety of both tables and which values are missing.
   
       SELECT * 
       FROM "sea_lions"
       FULL JOIN "migrations"
       ON "migrations"."id" = "sea_lions"."id";


| id | name | species | id | distance | days |
|---:|------|---------|---:|---------:|----:|
| 10484 | Ayah | *Zalophus californianus* | 10484 | 1000 | 107 |
| 11728 | Spot | *Zalophus californianus* | 11728 | 1531 | 56 |
| 11729 | Tiger | *Zalophus californianus* | 11729 | 1370 | 37 |
| 11732 | Mabel | *Zalophus californianus* | 11732 | 1622 | 62 |
| 11734 | Rick | *Zalophus californianus* | 11734 | 1491 | 58 |
| 11790 | Jolee | *Zalophus californianus* | NULL | NULL | NULL |
| NULL | NULL | NULL | 11735 | 2723 | 82 |
| NULL | NULL | NULL | 11736 | 1571 | 52 |
| NULL | NULL | NULL | 11737 | 1957 | 92 |

--> We see both table in entirety. We have Jolee here still Jolee doesn't have number of days or distance.

## Note:
1. LEFT JOIN, RIGHT JOIN, FULL JOIN are all part of this family called OUTER JOIN.
2. An OUTER JOIN lets us keep some data even if the JOIN is not going to quite work out for us much as ww would want it to in an INNER JOIN. We might have some NULL or empty values in this JOIN after we run it.
   
## FULL OUTER JOIN

**Example:**

|id|name|
|---|-----|
|10484|Ayah|
|11728|Spot|
|11790|Jolee|

|id|distance|
|----|--------|
|10484|1000|
|11728|1531|
|11735|2723|