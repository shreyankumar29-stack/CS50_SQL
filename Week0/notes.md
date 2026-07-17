## Introduction
## Tables

A table stores related information in a structured format.

- Each **row** represents one record (item).
- Each **column** represents one attribute (property) of that record.
## Why Use Databases Instead of Spreadsheets?

1. **Scalability** – Handle millions of records efficiently.
2. **Concurrency** – Multiple users can access and modify data simultaneously.
3. **Speed** – Faster searching, filtering, and querying of data.
## Database

A database is an organized collection of data that allows us to create, read, update, and delete (CRUD) information efficiently.

## Types of Databases:
1. MySQL
2. PostgresSQL
3. SQLite
4. MongoDB

## SQL (Structured Query Language)

SQL is a language used to communicate with relational databases. It is used to:

- Create data
- Read data
- Update data
- Delete data

These operations are collectively known as **CRUD**.

## Why do we need to use double quotes while writing the queries?
It is good practice to use double quotes around table and column names, which are called SQL identifiers. SQL also has strings and we use single quotes around strings to differentiate them from identifiers.


## Keywords
SELECT → Retrieves data from one or more columns of a table.
LIMIT:- certain number of rows
NOT:- Negate the condition
AND
OR
()
= Equal to
!= NOT EQUAL TO
<> NOT EQUAL TO
IS NULL:- The value inside the table doesn"t exist
IS NOT NULL:- The value inside the table exists
LIKE:- match pattern in my database
       -(% sign can match any character around a String we give)
       -(_ underscore can match any single character in my string)
<=
>
<
<=
## For example If I write the query:
This query searches for titles that:
 SELECT title FROM books WHERE title LIKE "The%Love%";
- Start with **The**
- Contain **Love** somewhere after **The**
- Can have any number of characters between **The** and **Love**
- Can also have characters after **Love**

If no rows are returned, it means there is no title in the database that matches this pattern.

BETWEEN
AND

OREDR BY:- The ORDER BY clause is used to sort the result of a query in either ascending or descending order.

ORDER BY......ASC
ORDER BY......DESC

## SQL Aggregate Functions
COUNT
AVG
MIN
MAX
SUM
ROUND
DISTINCT
## Would using MAX with the title column give you the longest book title?

No, using MAX with the title column would give you the “largest” (or in this case, last) title alphabetically. Similarly, MIN will give the first title alphabetically.

DISINCT:- Unique entries of datasets
