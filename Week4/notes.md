# CS50 SQL — Week 4 Notes

## Viewing

---

# 1. Introduction

So far, we learned how to:

* Design databases
* Create tables
* Define relationships
* Insert data
* Update data
* Delete data
* Query data

In Week 4, we learn how to **obtain useful views from databases**.

For example, in `longlist.db`, information about books and authors is stored across three tables:

```text
authors
   ↓
authored
   ↓
books
```

To find which books were written by a particular author, we need to work through these related tables.

We can use `JOIN` to combine information from these tables into one result.

### Example

```sql
SELECT "name", "title"
FROM "authors"
JOIN "authored"
    ON "authors"."id" = "authored"."author_id"
JOIN "books"
    ON "books"."id" = "authored"."book_id";
```

This gives us a result where the author name appears next to the title of the book they wrote.

---

# 2. What is a View?

A **view is a virtual table defined by a query**.

It allows us to save the result structure of a query and use it later as if it were a table.

### Example

```sql
CREATE VIEW "longlist" AS
SELECT "name", "title"
FROM "authors"
JOIN "authored"
    ON "authors"."id" = "authored"."author_id"
JOIN "books"
    ON "books"."id" = "authored"."book_id";
```

Now we can query:

```sql
SELECT * FROM "longlist";
```

### Important

A view is **virtual**.

The actual data remains in the underlying tables.

The view provides a simpler way to access that data.

---

# 3. Why Use Views?

CS50 focuses on four main uses of views:

### 1. Simplifying

Putting data from different tables together so that it can be queried more easily.

### 2. Aggregating

Using aggregate functions such as:

```text
COUNT()
SUM()
AVG()
MIN()
MAX()
```

and storing the resulting query as a view.

### 3. Partitioning

Breaking a large set of data into smaller logical pieces.

### 4. Securing

Hiding or anonymizing columns that should not be exposed.

---

# 4. Simplifying

Suppose we want to find books written by `Fernanda Melchor`.

Without a view, we could use a nested query:

```sql
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
```

This query contains **three SELECT statements**, so it is relatively complex.

---

# 5. Using JOIN to Simplify

We can first combine the three tables:

```sql
SELECT "name", "title"
FROM "authors"
JOIN "authored"
    ON "authors"."id" = "authored"."author_id"
JOIN "books"
    ON "books"."id" = "authored"."book_id";
```

### Important

We need to specify **how the tables are joined**.

Usually:

```text
Primary Key
     ↓
Foreign Key
```

For example:

```sql
"authors"."id" = "authored"."author_id"
```

and:

```sql
"books"."id" = "authored"."book_id"
```

---

# 6. Creating the `longlist` View

We can save the previous query as a view:

```sql
CREATE VIEW "longlist" AS
SELECT "name", "title"
FROM "authors"
JOIN "authored"
    ON "authors"."id" = "authored"."author_id"
JOIN "books"
    ON "books"."id" = "authored"."book_id";
```

Now the view is called:

```text
longlist
```

We can use it like a table:

```sql
SELECT * FROM "longlist";
```

And finding books by Fernanda Melchor becomes much simpler:

```sql
SELECT "title"
FROM "longlist"
WHERE "name" = 'Fernanda Melchor';
```

### Remember

```text
Complex JOIN query
       ↓
CREATE VIEW
       ↓
Simple reusable view
```

---

# 7. Ordering a View

We can order the results of a view using `ORDER BY`.

For example:

```sql
SELECT "name", "title"
FROM "longlist"
ORDER BY "title";
```

We can also include `ORDER BY` in the query used to create the view.

### NOTE

A view can be queried and displayed differently depending on the query we use against it.

---

# 8. Disk Space and Views

A view does not normally create another copy of all the underlying data.

The actual data remains in the underlying tables.

The view provides a simplified way of accessing that data.

### Remember

```text
Underlying tables
       ↓
     Data
       ↓
      View
       ↓
Simplified access
```

---

# 9. Aggregating with Views

Views can also be used with aggregate functions.

Suppose `ratings` contains individual ratings for books.

We can find the average rating of each book:

```sql
SELECT "book_id",
       ROUND(AVG("rating"), 2) AS "rating"
FROM "ratings"
GROUP BY "book_id";
```

---

# 10. Joining Ratings with Books

We can also include the book title and year.

```sql
SELECT "book_id",
       "title",
       "year",
       ROUND(AVG("rating"), 2) AS "rating"
FROM "ratings"
JOIN "books"
    ON "ratings"."book_id" = "books"."id"
GROUP BY "book_id";
```

Here:

1. `ratings` and `books` are joined.
2. The join happens using `book_id`.
3. Rows are grouped by book.
4. `AVG()` calculates the average rating.
5. `ROUND(..., 2)` rounds it to two decimal places.

---

# 11. Creating an Aggregated View

We can save this query as a view:

```sql
CREATE VIEW "average_book_ratings" AS
SELECT "book_id" AS "id",
       "title",
       "year",
       ROUND(AVG("rating"), 2) AS "rating"
FROM "ratings"
JOIN "books"
    ON "ratings"."book_id" = "books"."id"
GROUP BY "book_id";
```

Now:

```sql
SELECT * FROM "average_book_ratings";
```

will show the average rating of each book.

---

# 12. Views Automatically Reflect Updated Data

Suppose new ratings are added to the `ratings` table.

We don't need to manually update the view.

Simply query the view again:

```sql
SELECT * FROM "average_book_ratings";
```

The view uses the current data from the underlying tables.

### Remember

```text
Underlying data changes
        ↓
Query view again
        ↓
Updated result
```

---

# 13. Views in the Database Schema

Every normal view we create becomes part of the database schema.

We can check this using:

```sql
.schema
```

For example, we may see:

```sql
CREATE VIEW "longlist" AS ...
```

and:

```sql
CREATE VIEW "average_book_ratings" AS ...
```

---

# 14. Temporary Views

Sometimes we want a view only temporarily.

For that we use:

```sql
CREATE TEMPORARY VIEW
```

### Syntax

```sql
CREATE TEMPORARY VIEW "view_name" AS
SELECT ...;
```

A temporary view exists only for the duration of our connection to the database.

It is **not stored permanently in the database schema**.

---

# 15. Average Rating Per Year

We already have:

```text
average_book_ratings
```

which contains the average rating for each book.

Now we can calculate the average rating per year:

```sql
SELECT "year",
       ROUND(AVG("rating"), 2) AS "rating"
FROM "average_book_ratings"
GROUP BY "year";
```

Here:

```text
average rating per book
          ↓
GROUP BY year
          ↓
average rating per year
```

---

# 16. Creating a Temporary View

We can save the previous result as a temporary view:

```sql
CREATE TEMPORARY VIEW "average_ratings_by_year" AS
SELECT "year",
       ROUND(AVG("rating"), 2) AS "rating"
FROM "average_book_ratings"
GROUP BY "year";
```

Now:

```sql
SELECT * FROM "average_ratings_by_year";
```

### Why use a temporary view?

Temporary views are useful when we want to organize data without storing that organization permanently.

They are also useful for **testing queries**.

---

# 17. Common Table Expression (CTE)

A **CTE (Common Table Expression)** is like a temporary view that exists for **one query only**.

### Comparison

```text
Regular View
→ exists in database schema

Temporary View
→ exists during current database connection

CTE
→ exists only for one query
```

---

# 18. CTE Syntax

A CTE is created using:

```sql
WITH
```

### Example

```sql
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
```

The CTE `average_book_ratings` exists only while this query is executing.

---

# 19. View vs Temporary View vs CTE

| Feature          | View           | Temporary View                 | CTE                  |
| ---------------- | -------------- | ------------------------------ | -------------------- |
| Command          | `CREATE VIEW`  | `CREATE TEMPORARY VIEW`        | `WITH`               |
| Lifetime         | Persistent     | Current connection             | One query            |
| Stored in schema | Yes            | No                             | No                   |
| Reusable         | Yes            | Yes during connection          | No                   |
| Main purpose     | Reusable query | Temporary organization/testing | Complex single query |

### Easy way to remember

```text
VIEW
→ Long-term

TEMP VIEW
→ Current connection

CTE
→ Current query
```

---

# 20. Partitioning

Views can be used to **partition data**.

Partitioning means breaking a large set of data into smaller logical pieces.

For example, the International Booker Prize database stores books from different years in one `books` table.

We could create a separate view for books longlisted in 2022.

```sql
CREATE VIEW "2022" AS
SELECT "id", "title"
FROM "books"
WHERE "year" = 2022;
```

Then:

```sql
SELECT * FROM "2022";
```

will show only books from 2022.

---

# 21. Can Views Be Updated?

A view itself does not contain its own copy of the data.

It pulls data from the underlying tables whenever it is queried.

Therefore, when an underlying table is updated, querying the view again will show the updated data.

### Example

```sql
UPDATE "books"
SET "title" = 'New Title'
WHERE "id" = 1;
```

Then:

```sql
SELECT * FROM "longlist";
```

will reflect the updated data.

### NOTE

Think of a view as a **saved query**, not as a separate copy of the table.

---

# 22. Securing Data with Views

Views can help improve database security by limiting what data is exposed.

Suppose a rideshare database contains:

```text
rides
-----------------------
id
origin
destination
rider
```

An analyst may need:

```text
origin
destination
```

but does not need the rider's name.

Rider names may be considered **Personally Identifiable Information (PII)**.

Instead of giving the analyst access to the original table, we can create a view.

---

# 23. Anonymizing Data

We can create a view that replaces the real rider name with `Anonymous`.

```sql
CREATE VIEW "analysis" AS
SELECT "id",
       "origin",
       "destination",
       'Anonymous' AS "rider"
FROM "rides";
```

Now:

```sql
SELECT * FROM "analysis";
```

The analyst sees:

```text
id | origin | destination | rider
---|--------|-------------|---------
1  | Delhi  | Mumbai      | Anonymous
2  | Pune   | Delhi       | Anonymous
```

The actual rider names are not included in the view.

---

# 24. Important Security Limitation

Views can hide or anonymize information in the view.

However, **SQLite does not provide access control**.

This means that if someone has access to the original database, they could query the original table directly:

```sql
SELECT * FROM "rides";
```

and potentially see the original rider names.

### NOTE

A view can help limit exposed data, but a view by itself is **not a complete access-control system**.

---

# 25. Soft Deletions

A **soft deletion** means marking a row as deleted instead of actually removing it from the database.

Instead of:

```sql
DELETE FROM "collections"
WHERE "title" = 'Farmers working at dawn';
```

we change a `deleted` column.

For example:

```text
deleted = 0
→ not deleted

deleted = 1
→ deleted
```

---

# 26. Adding a `deleted` Column

Suppose the `collections` table does not have a `deleted` column.

We can add it:

```sql
ALTER TABLE "collections"
ADD COLUMN "deleted" INTEGER DEFAULT 0;
```

The default value is:

```text
0
```

meaning the artwork is not deleted.

---

# 27. Performing a Soft Delete

To soft-delete:

```text
Farmers working at dawn
```

we use:

```sql
UPDATE "collections"
SET "deleted" = 1
WHERE "title" = 'Farmers working at dawn';
```

The row still exists in the table.

Only its `deleted` value has changed.

---

# 28. Creating a View for Current Data

Now we can create a view that only displays data that has not been deleted:

```sql
CREATE VIEW "current_collections" AS
SELECT "id",
       "title",
       "accession_number",
       "acquired"
FROM "collections"
WHERE "deleted" = 0;
```

Then:

```sql
SELECT * FROM "current_collections";
```

The soft-deleted artwork will not appear.

---

# 29. How Soft Deletion Works

```text
collections table
        ↓
deleted = 1
        ↓
Row still exists
        ↓
current_collections view
        ↓
WHERE deleted = 0
        ↓
Deleted row is hidden
```

### Remember

Soft deletion does **not** physically remove the row.

---

# 30. INSTEAD OF Trigger

Normally, we cannot directly insert into or delete from a view in the same way as a normal table.

SQLite provides an **`INSTEAD OF` trigger** to perform an operation on the underlying table when an operation is attempted on a view.

For example, we can create a trigger for deleting from `current_collections`.

```sql
CREATE TRIGGER "delete"
INSTEAD OF DELETE ON "current_collections"
FOR EACH ROW
BEGIN
    UPDATE "collections"
    SET "deleted" = 1
    WHERE "id" = OLD."id";
END;
```

Now:

```sql
DELETE FROM "current_collections"
WHERE "title" = 'Imaginative landscape';
```

will not physically delete the row.

Instead, the trigger executes:

```sql
UPDATE "collections"
SET "deleted" = 1
WHERE "id" = OLD."id";
```

---

# 31. `OLD` Keyword

In the trigger:

```sql
WHERE "id" = OLD."id";
```

`OLD` refers to the row that we are trying to delete from the view.

So:

```text
DELETE from view
       ↓
INSTEAD OF trigger
       ↓
Find OLD row
       ↓
UPDATE underlying table
       ↓
deleted = 1
```

---

# 32. Insert into a View

We can also create a trigger for inserting data into a view.

There are two situations:

### Situation 1

The artwork already exists in the underlying table but was soft-deleted.

### Situation 2

The artwork does not exist in the underlying table.

---

# 33. Insert When Artwork Already Exists

Suppose the accession number already exists in `collections`.

We can use:

```sql
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
```

### What happens?

The `WHEN` condition checks whether the accession number already exists.

If it exists:

```text
deleted = 1
```

can be changed back to:

```text
deleted = 0
```

This effectively **undoes the soft deletion**.

---

# 34. `NEW` Keyword

In:

```sql
NEW."accession_number"
```

`NEW` refers to the values of the row that we are trying to insert.

### Easy way to remember

```text
OLD
→ existing row involved in DELETE/UPDATE

NEW
→ new row/data involved in INSERT/UPDATE
```

---

# 35. Insert When Artwork is New

If the accession number does not already exist, we need to insert a completely new row into `collections`.

```sql
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
        (NEW."title",
         NEW."accession_number",
         NEW."acquired");
END;
```

Here:

```text
accession number does not exist
        ↓
NEW artwork
        ↓
INSERT into collections
```

---

# 36. Complete Soft Deletion System

The complete flow is:

```text
                 collections
                      │
          ┌───────────┴───────────┐
          │                       │
     deleted = 0             deleted = 1
          │                       │
          ↓                       ↓
 current_collections          Hidden
          │
          ↓
      DELETE
          │
          ↓
 INSTEAD OF DELETE
          │
          ↓
 deleted = 1
```

For INSERT:

```text
INSERT into current_collections
             │
             ↓
       INSTEAD OF INSERT
             │
       ┌─────┴─────┐
       ↓           ↓
   Already       New
   exists        artwork
       ↓           ↓
 deleted=0      INSERT
```

---

# 37. Important SQL Commands of Week 4

### Create View

```sql
CREATE VIEW "view_name" AS
SELECT ...;
```

### Query View

```sql
SELECT * FROM "view_name";
```

### Drop View

```sql
DROP VIEW "view_name";
```

### Temporary View

```sql
CREATE TEMPORARY VIEW "view_name" AS
SELECT ...;
```

### CTE

```sql
WITH "name" AS (
    SELECT ...
)
SELECT ...
FROM "name";
```

### Create Trigger

```sql
CREATE TRIGGER "trigger_name"
...
```

### INSTEAD OF Trigger

```sql
CREATE TRIGGER "name"
INSTEAD OF DELETE ON "view"
...
```

### Check Schema

```sql
.schema
```

---

# 38. Your `longlist` Example

The important view from your Week 4 `longlist.db` is:

```sql
CREATE VIEW "longlist" AS
SELECT "name", "title"
FROM "authors"
JOIN "authored"
    ON "authors"."id" = "authored"."author_id"
JOIN "books"
    ON "books"."id" = "authored"."book_id";
```

Then:

```sql
SELECT * FROM "longlist";
```

To find books written by a particular author:

```sql
SELECT "title"
FROM "longlist"
WHERE "name" = 'Fernanda Melchor';
```

### If you accidentally create the view incorrectly

Remove it:

```sql
DROP VIEW "longlist";
```

Then recreate it correctly.

---

# 39. View vs Table

| Table                            | View                                            |
| -------------------------------- | ----------------------------------------------- |
| Stores data                      | Does not normally store a separate copy of data |
| Physical database object         | Virtual table                                   |
| Data can be directly manipulated | Primarily used to query underlying data         |
| Exists in database               | Exists in database schema                       |
| Can contain actual rows          | Defined by a query                              |

### Remember

**TABLE = stores data**

**VIEW = provides a view of data**

---

# 40. View vs CTE

### View

```sql
CREATE VIEW "longlist" AS ...
```

Reusable in future queries.

### CTE

```sql
WITH "longlist" AS (...)
SELECT ...
```

Only exists for that one query.

### Mental Model

```text
CREATE VIEW
      ↓
Permanent reusable query

CREATE TEMPORARY VIEW
      ↓
Temporary reusable query

WITH (CTE)
      ↓
Temporary query result
```

---

# 41. Week 4 Quick Revision

### VIEW

Virtual table defined by a query.

### CREATE VIEW

Used to create a reusable view.

### Simplifying

Use JOIN + VIEW to simplify complicated queries.

### Aggregating

Views can contain:

```text
COUNT()
SUM()
AVG()
MIN()
MAX()
```

### Temporary View

Exists only during the current database connection.

### CTE

Exists only for one query.

### Partitioning

Break data into smaller logical pieces using views.

### Securing

Use views to hide or anonymize sensitive information.

### Soft Deletion

Mark a row as deleted instead of physically deleting it.

### `INSTEAD OF`

Trigger that performs an alternative operation when an operation is attempted on a view.

### `OLD`

Refers to the existing row involved in the trigger operation.

### `NEW`

Refers to the new row/data involved in the trigger operation.

---

# 42. Most Important Things to Remember

> **VIEW = Virtual table defined by a query**

> **JOIN + VIEW = Simplify complex queries**

> **Aggregate + VIEW = Save useful calculated results**

> **TEMPORARY VIEW = Exists during current connection**

> **CTE = Exists for one query**

> **Partitioning = Break data into logical pieces**

> **Views can help secure sensitive data**

> **SQLite does not provide access control**

> **Soft deletion = Mark as deleted instead of removing**

> **INSTEAD OF trigger = Perform another operation on the underlying table**

> **OLD = Existing row**

> **NEW = New row/data**

---

# 43. Week 4 Topic Flow

```text
Viewing
   ↓
JOIN
   ↓
Views
   ↓
Simplifying
   ↓
Aggregating
   ↓
Temporary Views
   ↓
CTEs
   ↓
Partitioning
   ↓
Securing
   ↓
Soft Deletions
   ↓
INSTEAD OF Triggers
   ↓
OLD / NEW
```
