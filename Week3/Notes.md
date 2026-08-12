# CRUD Operations

CRUD stands for:

* **C → Create**
* **R → Read**
* **U → Update**
* **D → Delete**

In SQL:

* `INSERT` → Create/Add new data
* `SELECT` → Read data
* `UPDATE` → Update existing data
* `DELETE` → Delete data

---

# INSERT

`INSERT` is used to add new rows/data into a table.

## Example: Inserting values for Museum of Fine Arts

```sql
INSERT INTO "collections" ("title", "accession_number", "acquired")
VALUES ('Profusion of flowers', '56.257', '1956-04-01');

INSERT INTO "collections" ("title", "accession_number", "acquired")
VALUES ('Farmers working at dawn', '11.6152', '1911-08-03');

INSERT INTO "collections" ("title", "accession_number", "acquired")
VALUES ('Spring Outing', '14.76', '1941-01-08');
```

The table will look like:

| id | title                   | accession_number | acquired   |
| -- | ----------------------- | ---------------- | ---------- |
| 1  | Profusion of flowers    | 56.257           | 1956-04-01 |
| 2  | Farmers working at dawn | 11.6152          | 1911-08-03 |
| 3  | Spring Outing           | 14.76            | 1941-01-08 |

---

## INSERT with NULL

Let's try one more:

```sql
INSERT INTO "collections" ("title", "accession_number", "acquired")
VALUES (NULL, NULL, '1900-01-10');
```

### Reason why this won't work

If `"title"` and `"accession_number"` are defined as `NOT NULL` in our schema, SQLite will not allow us to insert `NULL` into these columns.

The `NOT NULL` constraint means that a value must be provided for that column.

---

## Syntax

```sql
INSERT INTO table(column0, ...)
VALUES(value0, ...);
```

---

# INSERTING MULTIPLE ROWS

We can insert multiple rows using a single `INSERT` statement.

### Syntax

```sql
INSERT INTO table(column0, ...)
VALUES
(value0, ...),
(value1, ...);
```

### Example

```sql
INSERT INTO "collections" ("title", "accession_number", "acquired")
VALUES
('Imaginative landscape', '56.496', NULL),
('Peonies and butterfly', '06.1899', '1906-01-01');
```

---

# Importing CSV Files

CSV stands for **Comma-Separated Values**.

A CSV file stores data in rows and columns.

### Example

```text
id,title,accession_number,acquired

1,Profusion of flowers,56.257,1956-04-12

2,Farmers working at dawn,11.6152,1911-08-03

3,Spring outing,14.76,1914-01-08

4,Imaginative landscape,56.496,

5,Peonies and butterfly,06.1899,1906-01-10
```

SQLite provides the `.import` command to import data from a CSV file.

### Example

```sql
.import --csv --skip 1 mfa.csv collections
```

### Explanation

* `--csv` → tells SQLite that the file is a CSV file.
* `--skip 1` → skips the first row (usually the header).
* `mfa.csv` → the CSV file that contains the data.
* `collections` → the table where the data will be imported.

---

# DELETE

`DELETE` is used to remove rows/data from a table.

### Syntax

```sql
DELETE FROM table
WHERE condition;
```

### Example

```sql
DELETE FROM "collections"
WHERE "id" = 3;
```

This deletes the row whose `id` is `3`.

**NOTE:** Be careful when using `DELETE` without a `WHERE` clause:

```sql
DELETE FROM "collections";
```

This will delete **all rows** from the table.

---

# FOREIGN KEY CONSTRAINTS

A **foreign key** is a column in one table that references the **primary key** of another table.

It is used to create a relationship between tables.

### Example

```sql
FOREIGN KEY ("artist_id")
REFERENCES "artists"("id")
```

Here:

* `"artist_id"` → Foreign key in the current table
* `"artists"` → Table being referenced
* `"id"` → Primary key in the `artists` table

So:

```text
artists
   |
   | id
   ↓
created
   |
   | artist_id
```

The foreign key helps maintain **referential integrity** between the tables.

---

# ON DELETE

`ON DELETE` specifies what should happen to a foreign-key value when the referenced row in the parent table is deleted.

### Example

```sql
FOREIGN KEY ("artist_id")
REFERENCES "artists"("id")
ON DELETE CASCADE
```

There are several actions we can use.

---

## 1. ON DELETE RESTRICT

```sql
ON DELETE RESTRICT
```

Prevents the parent row from being deleted if it is still referenced by a foreign key.

**In simple words:**

> If another table is using this row, don't allow me to delete it.

---

## 2. ON DELETE NO ACTION

```sql
ON DELETE NO ACTION
```

Does not automatically delete or modify the related row.

If deleting the parent row would violate the foreign key constraint, the deletion will fail.

**NOTE:** `NO ACTION` is the default behavior in SQLite if no `ON DELETE` action is specified.

---

## 3. ON DELETE SET NULL

```sql
ON DELETE SET NULL
```

If the referenced parent row is deleted, the foreign-key column in the child table is changed to `NULL`.

Example:

```text
Before:

artist_id
---------
3

Artist 3 is deleted.

After:

artist_id
---------
NULL
```

**Important:** The foreign-key column must allow `NULL`. It cannot be defined as `NOT NULL`.

---

## 4. ON DELETE SET DEFAULT

```sql
ON DELETE SET DEFAULT
```

When the referenced parent row is deleted, the foreign-key column is changed to its defined `DEFAULT` value.

For this to work correctly, the default value must satisfy the foreign-key constraint.

---

## 5. ON DELETE CASCADE

```sql
ON DELETE CASCADE
```

When the parent row is deleted, the related rows in the child table are automatically deleted.

### Example

If:

```text
artists
id = 3
```

is deleted, and `created` contains:

```text
artist_id = 3
```

then the corresponding row in `created` will also be deleted.

**In simple words:**

> Delete the parent → automatically delete the related child rows.

---

## Quick Revision

```text
ON DELETE RESTRICT
→ Don't allow deletion if the row is referenced.

ON DELETE NO ACTION
→ Don't automatically do anything; constraint violation can prevent deletion.

ON DELETE SET NULL
→ Change the foreign key to NULL.

ON DELETE SET DEFAULT
→ Change the foreign key to its DEFAULT value.

ON DELETE CASCADE
→ Delete the related child rows automatically.
```

### Important

`SET NULL` and `SET DEFAULT` do not mean that the parent row is kept. The **parent row is deleted**, and the foreign-key value in the child table is changed according to the specified action.

### UPDATE 

UPDATE table 
SET column0 = value0, ...
WHERE condition;

