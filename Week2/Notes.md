
# Normalization

Normalization is the process of organizing data to reduce redundancy and improve data integrity.

**Example:**

Riders
|id|name|
|--|----|
|1|Charlie|
|2|Alice|
|3|Bob|

stations
|id|locations|
|--|--------|
|1|Harvard|
|2|MIT|
|3|Park Street|

---

# Types of Normal Forms:
1. FIRST NORMAL FORM
2. SECOND NORMAL FORM
3. THIRD NORMAL FORM

---

# Relating
We now need to decide how our entities (riders and stations) are related.

**Example:**
![alt text](image.png)
![alt text](image-1.png)

---
# CREATE TABLE:
Creating a brand new table.

**Example:**
CREATE TABLE "riders" (
    "id",
    "name"
);

---

# Data Types and Storage Class:
Five types of Storage Class:-
1. NULL-No data
2. INTEGER - Whole numbers (positive, negative, or zero)
3. REAL - Decimal (floating-point) numbers
4. TEXT - Text or character strings
5. BLOB - Binary Large Object (images, files, videos, etc.)
   
**NOTE:** Data Types and Storage Classes are very similar but have distinct meanings in SQLite.

**Example:**

**INTEGER**

0-BYTES

1-BYTES

2-BYTES

3-BYTES

4-BYTES

6-BYTES

8-BYTES

---

# Type Affinities
SQLite tries to convert inserted values to the storage class that matches the column's type affinity whenever possible.

1. INTEGER- A whole numbers(from 0 to infinity)
2. REAL- decimal or floating point numbers
3. TEXT- Characters
4. BLOB- Binary Large Object
5. NUMERIC- an integer or real value

---

# DROP TABLE:
Deletes a table and all of its data permanently.

---

## Creating a Database Schema (`schema.sql`)

Instead of creating tables one by one inside the SQLite terminal, we can write all `CREATE TABLE` statements inside a separate file called `schema.sql`.

### Why use `schema.sql`?

- Keeps the database structure organized.
- Makes the schema easy to read and modify.
- Allows us to recreate the entire database whenever needed.
- Common practice in real-world database development.

---

## Creating the `visits` Table

The `visits` table stores the relationship between riders and stations.

```sql
CREATE TABLE "visits" (
    "rider_id" INTEGER,
    "station_id" INTEGER
);
```

### Explanation

- `rider_id` stores the ID of a rider.
- `station_id` stores the ID of a station.
- Both columns use the `INTEGER` type because they reference IDs from other tables.

---

## Database Schema

After creating all three tables, the database schema consists of:

- `riders`
- `stations`
- `visits`

Together, these tables define the overall structure of the MBTA database.

---

## Applying the Schema to the Database

After writing all the `CREATE TABLE` statements in `schema.sql`, we need to execute them inside our database.

Open the database:

```bash
sqlite3 mbta.db
```

Read and execute the SQL commands from the file:

```sql
.read schema.sql
```

The `.read` command executes every SQL statement stored in the specified file.

---

## Verify the Schema

To check whether the tables were created successfully:

```sql
.schema
```

This displays the complete database schema, including all tables.

---

## Advantages of Using `schema.sql`

- Create multiple tables at once.
- Easily recreate the database if it is deleted.
- Modify the schema without retyping every command.
- Keep database structure separate from SQL queries.

---

## Remember

```text
schema.sql
      ↓
Stores the database structure
      ↓
CREATE TABLE statements
      ↓
.read schema.sql
      ↓
Creates all tables inside the database
```

---

## Key Commands

```bash
sqlite3 mbta.db      # Open the database

.read schema.sql     # Execute all SQL commands in schema.sql

.schema              # Display the database schema
```
---

# Table Constraints:
A constraint means that some values have to be a certain way.

---

# COLUMN CONSTRAINTS
NOT NULL

DEFAULT

UNIQUE

CHECK

---

# ALTERING TABLES

DROP TABLE

RENAME TO

ADD COLUMN 

DROP COLUMN 