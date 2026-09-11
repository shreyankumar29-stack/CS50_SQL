# CS50 SQL — Week 5 Notes

## Optimizing

---

# 1. Introduction

In previous weeks, we learned how to:

* Design databases
* Relate tables
* Write SQL queries
* Create views

In Week 5, we learn how to **optimize SQL queries**.

Optimization means making queries:

* Faster
* More efficient
* Less expensive in terms of space

We will also learn how databases handle **multiple queries at the same time**, which is called **concurrency**.

For this week, CS50 uses a large database based on the **Internet Movies Database (IMDb)**.

The database contains information about:

```text
people
movies
ratings
stars
```

The `stars` table implements the many-to-many relationship between people and movies.

---

# 2. Index

An **index** is a data structure used to speed up the retrieval of rows from a table.

Think about the index of a textbook.

Instead of reading every page to find a topic, we use the index to quickly locate it.

Databases can use indexes in a similar way.

---

# 3. Table Scan

Suppose we want to find the movie `Cars`.

```sql
SELECT *
FROM "movies"
WHERE "title" = 'Cars';
```

Without an index on `title`, SQLite may need to perform a **scan**.

A scan means checking the table from beginning to end, one row at a time.

```text
movies table

Row 1 → check
Row 2 → check
Row 3 → check
Row 4 → check
...
Row N → check
```

For a small database this may be fine.

For a huge database like IMDb, this can be slow.

---

# 4. Measuring Query Time

SQLite provides:

```sql
.timer on
```

This enables query timing.

After enabling it, when we run a query SQLite displays timing information.

The important measurement is:

```text
real
```

`real` represents the actual elapsed time between running the query and receiving the result.

---

# 5. Creating an Index

We can create an index on the `title` column:

```sql
CREATE INDEX "title_index"
ON "movies" ("title");
```

Now SQLite can use the index to find movies by title more efficiently.

Then:

```sql
SELECT *
FROM "movies"
WHERE "title" = 'Cars';
```

can execute much faster.

### Remember

```text
Without index
     ↓
Table scan
     ↓
Slower search

With index
     ↓
Index search
     ↓
Faster search
```

---

# 6. EXPLAIN QUERY PLAN

We can see how SQLite plans to execute a query using:

```sql
EXPLAIN QUERY PLAN
```

### Example

```sql
EXPLAIN QUERY PLAN
SELECT *
FROM "movies"
WHERE "title" = 'Cars';
```

This allows us to determine whether SQLite is:

```text
SCANNING
```

the table or:

```text
SEARCHING USING INDEX
```

---

# 7. Dropping an Index

To remove an index:

```sql
DROP INDEX "title_index";
```

After dropping the index, the query plan can return to scanning the table.

---

# 8. Primary Key and Automatic Index

In SQLite and many other DBMSs, an index is automatically created for a **primary key**.

For example:

```sql
CREATE TABLE "movies" (
    "id" INTEGER,
    "title" TEXT,
    PRIMARY KEY ("id")
);
```

SQLite can automatically create an index that helps search by:

```sql
"id"
```

However, regular columns such as:

```text
"title"
```

do not necessarily have an automatic index.

### NOTE

Don't assume every column is automatically indexed.

---

# 9. Should We Create an Index for Every Column?

It might seem like a good idea to create an index for every column.

But indexes have **trade-offs**.

Indexes:

* Occupy additional storage space
* Take time to maintain
* Can make `INSERT` operations slower

Therefore, we should create indexes where they are actually useful.

---

# 10. Index Across Multiple Tables

Suppose we want to find all movies in which **Tom Hanks** starred.

We can use:

```sql
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
```

This query involves:

```text
people
   ↓
stars
   ↓
movies
```

---

# 11. Query Plan for Multiple Tables

We can inspect the query:

```sql
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
```

Without suitable indexes, SQLite may need to scan:

```text
people
stars
```

The `movies` table does not need a normal scan for the ID lookup because its primary key is indexed.

---

# 12. Creating Indexes for Multiple Tables

We can create:

```sql
CREATE INDEX "person_index"
ON "stars" ("person_id");
```

and:

```sql
CREATE INDEX "name_index"
ON "people" ("name");
```

Now SQLite can search these columns using indexes instead of scanning the entire tables.

---

# 13. Covering Index

A **covering index** is an index that contains all the information needed for a query.

Normally, a database might need to:

```text
1. Search the index
       ↓
2. Go to the table
       ↓
3. Retrieve the required data
```

With a covering index:

```text
Search index
     ↓
Get everything needed
```

So the table does not need to be accessed separately for the required information.

---

# 14. Creating a Covering Index

Our original index was:

```sql
CREATE INDEX "person_index"
ON "stars" ("person_id");
```

But our query also needs:

```text
movie_id
```

So we can include both columns:

```sql
CREATE INDEX "person_index"
ON "stars" ("person_id", "movie_id");
```

Now the index contains:

```text
person_id
movie_id
```

which are both needed for the search.

Before creating the new index, remove the old one:

```sql
DROP INDEX "person_index";
```

Then create the new one:

```sql
CREATE INDEX "person_index"
ON "stars" ("person_id", "movie_id");
```

---

# 15. Checking the Covering Index

We can verify the query plan:

```sql
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
```

The query plan should show that indexes are being used.

---

# 16. Space Trade-off

Indexes improve query speed, but they require additional storage space.

```text
More indexes
     ↓
Faster searches
     +
More storage required
```

So indexes involve a **space trade-off**.

---

# 17. B-Tree

SQLite stores indexes using a data structure called a:

**B-Tree (Balanced Tree)**

A tree contains:

* Nodes
* Root node
* Child nodes
* Leaf nodes

```text
             Root
           /  |  \
         /    |    \
      Node   Node   Node
      / \           / \
   Leaf Leaf      Leaf Leaf
```

The root is where the tree starts.

Leaf nodes are nodes at the edges of the tree that do not point to other nodes.

---

# 18. How an Index Works

Suppose we create an index on:

```text
movies.title
```

Conceptually, the database creates a sorted structure based on movie titles.

For example:

```text
Cars
Frozen
Soul
...
```

The index points back to the corresponding movie IDs/rows.

This allows the database to find data efficiently without scanning the entire table.

---

# 19. Time Trade-off

Indexes don't only have a space cost.

They also have a **time cost when modifying data**.

Suppose we insert a new movie.

```sql
INSERT INTO "movies" ...
```

The new value may also need to be added to the index.

The B-Tree needs to be traversed to determine where the new value belongs.

Therefore:

```text
Indexes
   ↓
Faster SELECT
   +
More work during INSERT/UPDATE
```

---

# 20. Partial Index

A **partial index** contains only a subset of rows from a table.

This can save space compared with indexing the entire table.

It is useful when we know that queries frequently access only a particular subset of data.

---

# 21. Creating a Partial Index

Suppose users frequently search for movies released in 2023.

We can create:

```sql
CREATE INDEX "recents"
ON "movies" ("titles")
WHERE "year" = 2023;
```

### NOTE

The provided CS50 example uses `"titles"` in this command.

When applying the idea to the actual `movies` schema, make sure the column name matches the schema you are using.

---

# 22. Checking a Partial Index

We can check whether SQLite uses the partial index:

```sql
EXPLAIN QUERY PLAN
SELECT "title"
FROM "movies"
WHERE "year" = 2023;
```

The query plan can show that the `movies` table is being searched using the partial index.

---

# 23. Indexes and Schema

Indexes are saved in the SQLite database schema.

We can check them using:

```sql
.schema
```

The indexes we created should appear in the schema.

---

# 24. VACUUM

SQLite has a command called:

```sql
VACUUM;
```

It helps clean up unused space in the database.

When data or indexes are deleted, SQLite may mark the space as available for future use rather than immediately shrinking the database file.

`VACUUM` reorganizes the database and can reclaim that unused space.

---

# 25. Checking Database Size

On the terminal, the CS50 notes use:

```bash
du -b movies.db
```

This shows the size of the database file in bytes.

For example:

```text
158000000 bytes
```

approximately corresponds to:

```text
158 MB
```

---

# 26. Dropping an Index and VACUUM

Suppose we remove an index:

```sql
DROP INDEX "person_index";
```

The database file may not immediately become smaller.

We can then run:

```sql
VACUUM;
```

SQLite reorganizes the database and removes unused space.

### Remember

```text
DROP INDEX
     ↓
Space becomes unused
     ↓
VACUUM
     ↓
Unused space reclaimed
```

---

# 27. Deleted Data and VACUUM

Before `VACUUM`, deleted information may still exist in unused portions of the database file.

Forensic techniques can sometimes recover data that we think has been deleted.

After `VACUUM`, SQLite reorganizes the database, and according to the CS50 material, previously deleted rows would no longer be recoverable from that database file.

---

# 28. Concurrency

So far, we optimized individual queries.

Now we learn about **concurrency**.

**Concurrency** means handling multiple queries or interactions at the same time.

This is important for:

* Websites
* Banking systems
* Financial services
* Large applications

where many users may access the database simultaneously.

---

# 29. Transactions

A **transaction** is an individual unit of work.

It should appear to an outside observer as though its different operations happen together.

### Example

Suppose Alice wants to send $10 to Bob.

We need two operations:

```text
Alice → -$10
Bob   → +$10
```

If only Bob's balance is updated and Alice's balance has not yet been updated, someone could temporarily see an incorrect total.

Therefore, both operations should belong to the same transaction.

---

# 30. ACID

Transactions have four important properties called **ACID**.

```text
A → Atomicity
C → Consistency
I → Isolation
D → Durability
```

---

# 31. Atomicity

**Atomicity** means a transaction is treated as one indivisible unit.

It cannot be broken into smaller independent pieces.

For example:

```text
Transfer $10

Alice - $10
Bob   + $10
```

Both operations belong to one transaction.

Either the transaction completes or it does not.

---

# 32. Consistency

**Consistency** means a transaction should not violate database constraints.

For example, suppose the `balance` column has a constraint:

```text
balance >= 0
```

If a transaction attempts to make Alice's balance negative, the transaction should fail and be reverted.

---

# 33. Isolation

**Isolation** means transactions should not interfere with one another.

If multiple users access the database at the same time, each transaction should behave as though it is operating independently.

This helps prevent inconsistent intermediate states.

---

# 34. Durability

**Durability** means that once a transaction has successfully completed, its changes remain even if a failure occurs.

```text
COMMIT
   ↓
Changes saved
   ↓
Remain after failure
```

---

# 35. BEGIN TRANSACTION

We start a transaction using:

```sql
BEGIN TRANSACTION;
```

Then we perform the required operations.

Finally:

```sql
COMMIT;
```

saves the transaction.

### Example

Transfer $10 from Alice to Bob:

```sql
BEGIN TRANSACTION;

UPDATE "accounts"
SET "balance" = "balance" + 10
WHERE "id" = 2;

UPDATE "accounts"
SET "balance" = "balance" - 10
WHERE "id" = 1;

COMMIT;
```

Here:

```text
BEGIN TRANSACTION
        ↓
Update Bob
        ↓
Update Alice
        ↓
COMMIT
```

---

# 36. ROLLBACK

If something goes wrong during a transaction, we can use:

```sql
ROLLBACK;
```

This reverts the changes made during the transaction.

### Example

```sql
BEGIN TRANSACTION;

UPDATE "accounts"
SET "balance" = "balance" + 10
WHERE "id" = 2;

UPDATE "accounts"
SET "balance" = "balance" - 10
WHERE "id" = 1;

ROLLBACK;
```

If the transaction fails because of a constraint, `ROLLBACK` returns the database to its previous state.

---

# 37. COMMIT vs ROLLBACK

| Command             | Meaning           |
| ------------------- | ----------------- |
| `BEGIN TRANSACTION` | Start transaction |
| `COMMIT`            | Save changes      |
| `ROLLBACK`          | Revert changes    |

### Easy way to remember

```text
BEGIN
  ↓
Do work
  ↓
 ┌─────────────┐
 ↓             ↓
COMMIT       ROLLBACK
 ↓             ↓
Save          Undo
```

---

# 38. Race Condition

A **race condition** occurs when multiple entities simultaneously access shared data and make decisions based on its current value.

This can result in inconsistent database states.

Race conditions can be especially dangerous in systems such as banking.

---

# 39. Transactions Help Prevent Race Conditions

Transactions are processed with **isolation**.

When multiple transactions work with similar data, the database can process them sequentially so that they don't interfere with one another.

This helps prevent inconsistent intermediate states.

---

# 40. Locks

SQLite and other DBMSs use **locks** to help manage concurrent access.

The database can have different locking states.

### 1. UNLOCKED

No user is currently accessing the database.

```text
UNLOCKED
```

### 2. SHARED

A transaction is reading data.

Other transactions can also read the database.

```text
SHARED
 ↓
Multiple readers allowed
```

### 3. EXCLUSIVE

A transaction needs to write/update data.

An exclusive lock prevents other transactions from occurring at the same time.

```text
EXCLUSIVE
 ↓
No other transaction
```

---

# 41. Exclusive Transaction

SQLite allows us to explicitly begin an exclusive transaction:

```sql
BEGIN EXCLUSIVE TRANSACTION;
```

This obtains a very coarse lock because it locks the entire database.

If another terminal tries to access the database while the exclusive transaction is active, it may receive a:

```text
database is locked
```

error.

---

# 42. Locking and Concurrency

The exact locking granularity depends on the DBMS.

Possible levels conceptually include:

```text
Database
   ↓
Table
   ↓
Row
```

SQLite uses relatively coarse-grained locking compared with some other database systems.

---

# 43. Important SQL Commands — Week 5

### Enable Timer

```sql
.timer on
```

### Explain Query Plan

```sql
EXPLAIN QUERY PLAN
SELECT ...;
```

### Create Index

```sql
CREATE INDEX "index_name"
ON "table" ("column");
```

### Drop Index

```sql
DROP INDEX "index_name";
```

### Partial Index

```sql
CREATE INDEX "index_name"
ON "table" ("column")
WHERE condition;
```

### Vacuum

```sql
VACUUM;
```

### Start Transaction

```sql
BEGIN TRANSACTION;
```

### Commit

```sql
COMMIT;
```

### Rollback

```sql
ROLLBACK;
```

### Exclusive Transaction

```sql
BEGIN EXCLUSIVE TRANSACTION;
```

---

# 44. Index vs No Index

| Without Index           | With Index                 |
| ----------------------- | -------------------------- |
| May scan table          | Can search using index     |
| Slower for large tables | Faster retrieval           |
| Less storage            | Additional storage         |
| Faster inserts          | Inserts may take more work |

### Remember

**Index = Faster reads, but costs space and maintenance time.**

---

# 45. Full Index vs Partial Index

| Full Index                  | Partial Index                         |
| --------------------------- | ------------------------------------- |
| Covers all relevant rows    | Covers only selected rows             |
| More storage                | Less storage                          |
| Useful for general searches | Useful when queries focus on a subset |
| Larger index                | Smaller index                         |

---

# 46. View vs Index

Don't confuse Week 4 **Views** with Week 5 **Indexes**.

### View

```text
VIEW
↓
Simplifies access to data
```

### Index

```text
INDEX
↓
Speeds up data retrieval
```

### Easy Memory Trick

```text
VIEW  → How we SEE data
INDEX → How we FIND data faster
```

---

# 47. Transaction Flow

```text
BEGIN TRANSACTION
        ↓
    SQL operations
        ↓
   ┌────┴────┐
   ↓         ↓
COMMIT    ROLLBACK
   ↓         ↓
 Save       Undo
```

---

# 48. ACID Quick Revision

| Letter | Meaning     | Simple Meaning               |
| ------ | ----------- | ---------------------------- |
| A      | Atomicity   | All or nothing               |
| C      | Consistency | Follow database rules        |
| I      | Isolation   | Transactions don't interfere |
| D      | Durability  | Committed changes remain     |

### Remember

**ACID = Reliable Transactions**

---

# 49. Week 5 Quick Revision

### Index

Data structure used to speed up retrieval.

### Table Scan

Checking rows one by one.

### `EXPLAIN QUERY PLAN`

Shows how SQLite plans to execute a query.

### Covering Index

Index contains all information needed for the query.

### B-Tree

Data structure used by SQLite for indexes.

### Space Trade-off

Indexes use additional storage.

### Time Trade-off

Indexes require additional work when inserting/updating indexed data.

### Partial Index

Index containing only a subset of rows.

### VACUUM

Reclaims unused database space.

### Concurrency

Handling multiple database interactions at the same time.

### Transaction

A single logical unit of work.

### ACID

```text
Atomicity
Consistency
Isolation
Durability
```

### Race Condition

Multiple entities access shared data and cause possible inconsistencies.

### Locks

Control concurrent access to the database.

---

# 50. Most Important Things to Remember

> **INDEX = Faster data retrieval**

> **TABLE SCAN = Check rows one by one**

> **EXPLAIN QUERY PLAN = See how SQLite executes a query**

> **COVERING INDEX = Everything needed is available in the index**

> **B-TREE = Data structure used for SQLite indexes**

> **More indexes = More space + more maintenance**

> **PARTIAL INDEX = Index only a subset of rows**

> **VACUUM = Reclaim unused database space**

> **TRANSACTION = One logical unit of work**

> **COMMIT = Save transaction**

> **ROLLBACK = Undo transaction**

> **ACID = Atomicity, Consistency, Isolation, Durability**

> **RACE CONDITION = Concurrent access can cause inconsistent results**

> **LOCK = Controls concurrent database access**

---

# 51. Week 5 Topic Flow

```text
Optimizing
    ↓
Indexes
    ↓
Table Scans
    ↓
EXPLAIN QUERY PLAN
    ↓
Indexes Across Multiple Tables
    ↓
Covering Index
    ↓
Space Trade-off
    ↓
Time Trade-off
    ↓
Partial Index
    ↓
VACUUM
    ↓
Concurrency
    ↓
Transactions
    ↓
ACID
    ↓
Race Conditions
    ↓
Locks
```
