# CS50 SQL — Week 6 Notes

## Scaling

---

# 1. Introduction

Until now, we learned how to:

* Design databases
* Create tables and relationships
* Read and write data
* Optimize SQL queries

In Week 6, we learn how to do these things at a **larger scale**.

## Scalability

**Scalability** is the ability to increase or decrease the capacity of an application or database to meet demand.

Examples of applications that need scalability:

* Social media platforms
* Banking systems
* Large web applications

CS50 introduces two database management systems:

* **MySQL**
* **PostgreSQL**

Unlike SQLite, which is an **embedded database**, MySQL and PostgreSQL are **database servers**.

```text
SQLite
→ Embedded database

MySQL / PostgreSQL
→ Database servers
```

Database servers can run on dedicated hardware and can be accessed over a network.

---

# 2. MySQL

MySQL is a database server that can be used when applications need to scale beyond what is practical with SQLite.

CS50 continues using the **MBTA database**.

The database contains:

```text
Cards
Swipes
Stations
```

---

# 3. Connecting to MySQL

To connect to a local MySQL server:

```bash
mysql -u root -h 127.0.0.1 -P 3306 -p
```

### Meaning of the options

| Option | Meaning             |
| ------ | ------------------- |
| `-u`   | User                |
| `-h`   | Host                |
| `-P`   | Port                |
| `-p`   | Prompt for password |

Example:

```text
root
 ↓
Database administrator

127.0.0.1
 ↓
Local computer

3306
 ↓
Default MySQL port
```

---

# 4. Show Databases

Because MySQL is a database server, it can contain multiple databases.

To see them:

```sql
SHOW DATABASES;
```

---

# 5. Creating a Database in MySQL

Create the MBTA database:

```sql
CREATE DATABASE `mbta`;
```

MySQL uses **backticks** to identify table names and other identifiers in the examples from this lecture.

To switch to the database:

```sql
USE `mbta`;
```

---

# 6. Creating the `cards` Table

MySQL provides more granular integer types than SQLite.

Some MySQL integer types are:

```text
TINYINT
SMALLINT
MEDIUMINT
INT
BIGINT
```

The choice depends on the size of numbers that need to be stored.

Unsigned integers can store a larger positive range than signed integers.

### `cards` table

```sql
CREATE TABLE `cards` (
    `id` INT AUTO_INCREMENT,
    PRIMARY KEY(`id`)
);
```

`AUTO_INCREMENT` automatically generates the next ID for a new row.

---

# 7. `UNSIGNED`

An integer can be explicitly declared as unsigned.

```sql
id INT UNSIGNED
```

This means the column is intended for non-negative values and can use a larger positive range.

---

# 8. Viewing Tables

To see all tables in the current MySQL database:

```sql
SHOW TABLES;
```

---

# 9. DESCRIBE

To see information about a table:

```sql
DESCRIBE `cards`;
```

This provides information about the table's columns and constraints.

---

# 10. MySQL Text Types

MySQL provides several text-related types.

### `CHAR`

Fixed-width string.

### `VARCHAR`

Variable-length string.

Example:

```sql
name VARCHAR(32)
```

### `TEXT`

Used for longer pieces of text.

MySQL also provides:

```text
TINYTEXT
TEXT
MEDIUMTEXT
LONGTEXT
```

There is also:

```text
BLOB
```

for binary strings.

---

# 11. ENUM

`ENUM` restricts a column to one predefined option from a list.

Example:

```sql
size ENUM('M', 'L', 'XL')
```

A column using `ENUM` can contain one of the specified values.

---

# 12. SET

`SET` allows multiple predefined options to be stored in a single cell.

For example, it can be useful when multiple movie genres may apply.

---

# 13. Creating the `stations` Table

```sql
CREATE TABLE `stations` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL UNIQUE,
    `line` ENUM('blue', 'green', 'orange', 'red') NOT NULL,
    PRIMARY KEY(`id`)
);
```

Here:

* `AUTO_INCREMENT` generates IDs
* `VARCHAR(32)` stores station names
* `NOT NULL` requires a value
* `UNIQUE` prevents duplicate station names
* `ENUM` restricts the subway line values

---

# 14. `VARCHAR` Length

Suppose we use:

```sql
VARCHAR(300)
```

This is valid, but choosing a very large length when strings are normally small can have a memory/storage trade-off.

The CS50 notes suggest starting with a smaller length and increasing it later if necessary.

---

# 15. Date and Time Types in MySQL

Unlike SQLite, MySQL provides dedicated date/time types.

Important types include:

```text
DATE
YEAR
TIME
DATETIME
TIMESTAMP
```

The last three can support optional precision.

For real-number values, MySQL provides:

```text
FLOAT
DOUBLE PRECISION
```

MySQL also provides:

```text
DECIMAL
```

for fixed-precision decimal values.

---

# 16. Creating the `swipes` Table

```sql
CREATE TABLE `swipes` (
    `id` INT AUTO_INCREMENT,
    `card_id` INT,
    `station_id` INT,
    `type` ENUM('enter', 'exit', 'deposit') NOT NULL,
    `datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `amount` DECIMAL(5,2) NOT NULL CHECK(`amount` != 0),
    PRIMARY KEY(`id`),
    FOREIGN KEY(`station_id`) REFERENCES `stations`(`id`),
    FOREIGN KEY(`card_id`) REFERENCES `cards`(`id`)
);
```

Important points:

* `card_id` references `cards`
* `station_id` references `stations`
* `type` is restricted using `ENUM`
* `CURRENT_TIMESTAMP` automatically provides the current time when no value is supplied
* `DECIMAL(5,2)` provides fixed decimal precision
* `CHECK` enforces a condition

---

# 17. MySQL Foreign Keys in `DESCRIBE`

When describing the table, MySQL may show:

```text
MUL
```

under the `Key` field for foreign-key columns.

`MUL` indicates that the column can contain repeating values, as foreign keys commonly do.

---

# 18. MySQL Data Types vs SQLite Type Affinity

SQLite uses **type affinities**.

MySQL instead has actual data types such as:

```text
INT
VARCHAR
DECIMAL
```

MySQL does not work like SQLite's type-affinity system where a value of another type can simply be converted and stored according to affinity.

---

# 19. ALTER TABLE in MySQL

MySQL allows more fundamental table alterations than SQLite in the examples covered here.

For example, we can add `silver` to the possible station lines:

```sql
ALTER TABLE `stations`
MODIFY `line` ENUM('blue', 'green', 'orange', 'red', 'silver') NOT NULL;
```

`MODIFY` allows us to modify the definition of an existing column.

---

# 20. Stored Procedures

A **stored procedure** is a way to store SQL statements in the database so they can be executed repeatedly.

Think of it somewhat like a function:

```text
Stored Procedure
       ↓
Reusable SQL statements
       ↓
CALL procedure
```

---

# 21. MFA Soft Deletion in MySQL

Previously, in SQLite, CS50 used a view to implement soft deletion.

The `collections` table needs a `deleted` column:

```sql
ALTER TABLE `collections`
ADD COLUMN `deleted` TINYINT DEFAULT 0;
```

`TINYINT` is suitable here because the column stores values such as:

```text
0 → not deleted
1 → deleted
```

The default is `0`, so existing collections remain active.

---

# 22. Changing the MySQL Delimiter

Stored procedures contain multiple SQL statements.

Normally MySQL uses:

```text
;
```

as the statement delimiter.

Before creating a procedure, we temporarily change it:

```sql
delimiter //
```

This allows the `;` characters inside the procedure to be interpreted correctly.

---

# 23. Creating a Stored Procedure

```sql
CREATE PROCEDURE `current_collection`()
BEGIN
    SELECT `title`, `accession_number`, `acquired`
    FROM `collections`
    WHERE `deleted` = 0;
END//
```

Then reset the delimiter:

```sql
delimiter ;
```

---

# 24. Calling a Stored Procedure

Use:

```sql
CALL current_collection();
```

This executes the stored procedure.

For example, after soft-deleting an artwork:

```sql
UPDATE `collections`
SET `deleted` = 1
WHERE `title` = 'Farmers working at dawn';
```

calling:

```sql
CALL current_collection();
```

will no longer return that deleted collection.

---

# 25. Stored Procedures with Parameters

Stored procedures can accept input parameters.

This allows us to reuse the same procedure for different rows.

---

# 26. Transactions Table

Create a transactions table:

```sql
CREATE TABLE `transactions` (
    `id` INT AUTO_INCREMENT,
    `title` VARCHAR(64) NOT NULL,
    `action` ENUM('bought', 'sold') NOT NULL,
    PRIMARY KEY(`id`)
);
```

The table records whether artwork was:

```text
bought
sold
```

---

# 27. `sell` Stored Procedure

We can combine multiple operations into one stored procedure:

```sql
delimiter //

CREATE PROCEDURE `sell`(IN `sold_id` INT)
BEGIN
    UPDATE `collections`
    SET `deleted` = 1
    WHERE `id` = `sold_id`;

    INSERT INTO `transactions` (`title`, `action`)
    VALUES (
        (SELECT `title`
         FROM `collections`
         WHERE `id` = `sold_id`),
        'sold'
    );
END//

delimiter ;
```

The parameter:

```text
sold_id
```

identifies the artwork being sold.

---

# 28. Calling the Procedure

For example:

```sql
CALL `sell`(2);
```

This:

1. Marks the collection as deleted
2. Adds a corresponding transaction

---

# 29. PostgreSQL

After MySQL, CS50 introduces **PostgreSQL**.

PostgreSQL is also a database server and can provide capabilities useful for scaling.

CS50 again uses the MBTA database to demonstrate PostgreSQL.

---

# 30. Connecting to PostgreSQL

The command-line interface is called **PSQL**.

Example:

```bash
psql postgresql://postgres@127.0.0.1:5432/postgres
```

Important parts:

```text
postgres
   ↓
User

127.0.0.1
   ↓
Local host

5432
   ↓
PostgreSQL port
```

---

# 31. PostgreSQL Database Commands

List databases:

```sql
\l
```

Create a database:

```sql
CREATE DATABASE "mbta";
```

Connect to a database:

```sql
\c "mbta"
```

List tables:

```sql
\dt
```

Describe a table:

```sql
\d "cards"
```

Exit PostgreSQL:

```sql
\q
```

---

# 32. PostgreSQL `SERIAL`

PostgreSQL provides:

```text
SERIAL
```

A serial value is an integer commonly used for automatically generated primary-key values.

Example:

```sql
CREATE TABLE "cards" (
    "id" SERIAL,
    PRIMARY KEY("id")
);
```

---

# 33. PostgreSQL `stations` Table

```sql
CREATE TABLE "stations" (
    "id" SERIAL,
    "name" VARCHAR(32) NOT NULL UNIQUE,
    "line" VARCHAR(32) NOT NULL,
    PRIMARY KEY("id")
);
```

Here, `VARCHAR` is used for both the station name and subway line.

---

# 34. PostgreSQL ENUM

PostgreSQL can create its own enumerated type.

First:

```sql
CREATE TYPE "swipe_type"
AS ENUM('enter', 'exit', 'deposit');
```

Then this type can be used in a table.

---

# 35. PostgreSQL Date and Time Types

PostgreSQL provides:

```text
TIMESTAMP
DATE
TIME
INTERVAL
```

`INTERVAL` represents a duration or the distance between times.

For fixed-precision decimal values, PostgreSQL uses:

```text
NUMERIC
```

rather than MySQL's `DECIMAL` terminology in this example.

---

# 36. PostgreSQL `swipes` Table

```sql
CREATE TABLE "swipes" (
    "id" SERIAL,
    "card_id" INT,
    "station_id" INT,
    "type" "swipe_type" NOT NULL,
    "datetime" TIMESTAMP NOT NULL DEFAULT now(),
    "amount" NUMERIC(5,2) NOT NULL CHECK("amount" != 0),
    PRIMARY KEY("id"),
    FOREIGN KEY("station_id") REFERENCES "stations"("id"),
    FOREIGN KEY("card_id") REFERENCES "cards"("id")
);
```

PostgreSQL uses:

```sql
now()
```

to get the current timestamp.

---

# 37. Scaling

When an application's demand increases, the number of database reads and writes can increase.

This can cause:

```text
More requests
      ↓
More database work
      ↓
Longer query wait times
```

There are two major approaches discussed in this lecture:

```text
Vertical Scaling
Horizontal Scaling
```

---

# 38. Vertical Scaling

**Vertical scaling** means increasing the capacity of a database server by increasing its computing power.

For example:

```text
More CPU
More RAM
More computing power
        ↓
More database capacity
```

The database continues running on a more powerful server.

---

# 39. Horizontal Scaling

**Horizontal scaling** means increasing capacity by distributing the workload across multiple servers.

One important technique is:

```text
Replication
```

Replication means maintaining copies of the database on multiple servers.

```text
        Database
           ↓
   ┌───────┼───────┐
   ↓       ↓       ↓
Server  Server  Server
```

---

# 40. Replication Models

The lecture mentions three main replication models:

1. Single-leader
2. Multi-leader
3. Leaderless

CS50 focuses on the **single-leader model**.

---

# 41. Single-Leader Replication

In single-leader replication:

```text
        Leader
          ↓
       Writes
          ↓
   ┌──────┴──────┐
   ↓             ↓
Follower      Follower
(Read replica) (Read replica)
```

The **leader** handles writes.

The **followers** contain copies of the database and act as read replicas.

---

# 42. Synchronous Replication

With **synchronous replication**, the leader waits for followers to replicate changes before proceeding.

Advantage:

```text
Higher consistency
```

Disadvantage:

```text
Potentially slower responses
```

This can be useful when consistency is extremely important, such as in financial or healthcare applications.

---

# 43. Asynchronous Replication

With **asynchronous replication**, the leader communicates with followers asynchronously.

Advantage:

```text
Faster response
```

This approach can be useful in applications where speed is especially important, such as social media.

---

# 44. Sharding

**Sharding** means splitting a database into smaller pieces called **shards** and distributing them across multiple database servers.

```text
Large Database
      ↓
 ┌────┼────┐
 ↓    ↓    ↓
Shard1 Shard2 Shard3
 ↓      ↓      ↓
Server Server Server
```

---

# 45. Database Hotspot

A **database hotspot** occurs when one server receives much more traffic than the others.

Example:

```text
Server 1 → 10% requests
Server 2 → 10% requests
Server 3 → 80% requests
                 ↑
              Hotspot
```

A hotspot can overload one server and reduce the benefit of horizontal scaling.

---

# 46. Single Point of Failure

If sharding is used without replication and one server goes down, part of the database may become unavailable.

This creates a:

**Single Point of Failure**

```text
Server fails
     ↓
Part of database unavailable
     ↓
System affected
```

Replication can help improve availability.

---

# 47. Access Controls

Database servers can support multiple users with different privileges.

Previously, CS50 connected to MySQL using:

```text
root
```

The root user has extensive privileges.

We can create another user:

```sql
CREATE USER 'carter' IDENTIFIED BY 'password';
```

A newly created user has very few privileges by default.

---

# 48. GRANT

Suppose we have an `analysis` view that hides personally identifiable information from the `rides` table.

We can grant a user access to only that view:

```sql
GRANT SELECT
ON `rideshare`.`analysis`
TO 'carter';
```

This gives the user permission to:

```text
SELECT
```

from the specified view.

The user does not automatically gain access to the original `rides` table.

---

# 49. Principle of Limited Access

Access controls allow us to give users only the privileges they need.

For example:

```text
Analyst
   ↓
Can access anonymized view

Cannot access
   ↓
Original confidential table
```

This helps protect sensitive information.

---

# 50. SQL Injection

An **SQL injection attack** occurs when malicious input is inserted into an application's SQL query.

Suppose an application creates:

```sql
SELECT `id`
FROM `users`
WHERE `user` = 'Carter'
AND `password` = 'password';
```

If user input is directly inserted into the query, a malicious user may provide SQL code as input.

---

# 51. Example of SQL Injection

A malicious password might contain SQL logic such as:

```text
password' OR '1' = '1
```

This can change the meaning of the original query.

The resulting query could effectively contain:

```sql
OR '1' = '1'
```

Since that condition is always true, the attacker may bypass the intended authentication logic.

---

# 52. Another SQL Injection Example

An attacker might attempt:

```sql
SELECT * FROM `accounts`
WHERE `id` = 1
UNION SELECT * FROM `accounts`;
```

The important problem is that user input is being treated as part of the SQL statement.

---

# 53. Prepared Statements

One way to prevent SQL injection is to use **prepared statements**.

A prepared statement separates the SQL structure from the input values.

Example:

```sql
PREPARE `balance_check`
FROM 'SELECT * FROM `accounts`
WHERE `id` = ?';
```

The:

```text
?
```

acts as a placeholder for the value.

---

# 54. Executing a Prepared Statement

Set the variable:

```sql
SET @id = 1;
```

Then execute:

```sql
EXECUTE `balance_check` USING @id;
```

The `@` convention is used for variables in MySQL.

---

# 55. Prepared Statement Against Malicious Input

Even if the input is:

```text
1 UNION SELECT * FROM `accounts`
```

the prepared statement treats it as a value rather than executable SQL.

```sql
SET @id = '1 UNION SELECT * FROM `accounts`';

EXECUTE `balance_check` USING @id;
```

The malicious SQL is therefore not executed as part of the query.

Prepared statements use escaping to prevent malicious input from becoming executable SQL.

---

# 56. SQL Injection in Python

The same security principle applies when using SQL from Python.

Avoid constructing SQL queries by directly inserting user input into formatted strings.

Instead, use parameterized queries/prepared statements provided by the database library.

```text
User Input
    ↓
Parameterized Query
    ↓
Database
```

This prevents user input from being interpreted as SQL code.

---

# 57. MySQL vs PostgreSQL vs SQLite

| Feature         | SQLite                                       | MySQL              | PostgreSQL                |
| --------------- | -------------------------------------------- | ------------------ | ------------------------- |
| Database type   | Embedded                                     | Server             | Server                    |
| Scaling         | Smaller/local applications                   | Large applications | Large applications        |
| Integer types   | Fewer                                        | More granular      | Several                   |
| Auto ID example | `INTEGER` + behavior                         | `AUTO_INCREMENT`   | `SERIAL`                  |
| ENUM            | Not like MySQL/PostgreSQL                    | `ENUM`             | Custom `TYPE ... AS ENUM` |
| Decimal         | `REAL` etc.                                  | `DECIMAL`          | `NUMERIC`                 |
| Date/time       | Commonly stored using supported SQLite types | Dedicated types    | Dedicated types           |

---

# 58. MySQL Important Commands

### Connect

```bash
mysql -u root -h 127.0.0.1 -P 3306 -p
```

### Show databases

```sql
SHOW DATABASES;
```

### Create database

```sql
CREATE DATABASE `mbta`;
```

### Select database

```sql
USE `mbta`;
```

### Show tables

```sql
SHOW TABLES;
```

### Describe table

```sql
DESCRIBE `cards`;
```

### Change delimiter

```sql
delimiter //
```

### Reset delimiter

```sql
delimiter ;
```

### Call procedure

```sql
CALL current_collection();
```

---

# 59. PostgreSQL Important Commands

### Connect

```bash
psql postgresql://postgres@127.0.0.1:5432/postgres
```

### List databases

```sql
\l
```

### Create database

```sql
CREATE DATABASE "mbta";
```

### Connect to database

```sql
\c "mbta"
```

### List tables

```sql
\dt
```

### Describe table

```sql
\d "cards"
```

### Exit

```sql
\q
```

---

# 60. Scaling Quick Revision

### Vertical Scaling

```text
Increase power of one server
```

### Horizontal Scaling

```text
Add more servers
```

### Replication

```text
Keep copies of database
```

### Sharding

```text
Split database across servers
```

---

# 61. Replication Quick Revision

### Single-Leader

```text
Leader
  ↓
Writes
  ↓
Followers
```

### Synchronous

```text
Leader waits for replication
↓
More consistency
↓
Potentially slower
```

### Asynchronous

```text
Leader does not wait
↓
Faster response
↓
Replication happens asynchronously
```

---

# 62. Security Quick Revision

### Access Control

Controls what database users can access.

### `GRANT`

Gives specific privileges.

Example:

```sql
GRANT SELECT
ON `rideshare`.`analysis`
TO 'carter';
```

### SQL Injection

Malicious input becomes part of SQL.

### Prepared Statement

Separates SQL code from user input.

```sql
WHERE `id` = ?
```

---

# 63. Most Important Things to Remember

> **Scalability = Ability to increase or decrease capacity according to demand.**

> **SQLite = Embedded database.**

> **MySQL/PostgreSQL = Database servers.**

> **Vertical scaling = Increase the power of a server.**

> **Horizontal scaling = Distribute workload across servers.**

> **Replication = Keep copies of a database on multiple servers.**

> **Leader = Handles writes in single-leader replication.**

> **Follower = Read replica.**

> **Synchronous replication = Leader waits for followers.**

> **Asynchronous replication = Replication happens asynchronously.**

> **Sharding = Split database across servers.**

> **Hotspot = One server receives too much traffic.**

> **Single point of failure = Failure of one system can make required data unavailable.**

> **Stored procedure = Reusable SQL statements stored in the database.**

> **Access control = Give users only the permissions they need.**

> **SQL injection = Malicious SQL inserted through user input.**

> **Prepared statements = Help prevent SQL injection.**

---

# 64. Week 6 Topic Flow

```text
Scaling
   ↓
MySQL
   ↓
MySQL Data Types
   ↓
AUTO_INCREMENT
   ↓
ENUM / SET
   ↓
Date & Time
   ↓
ALTER TABLE
   ↓
Stored Procedures
   ↓
Stored Procedures with Parameters
   ↓
PostgreSQL
   ↓
SERIAL
   ↓
PostgreSQL Types
   ↓
Vertical Scaling
   ↓
Horizontal Scaling
   ↓
Replication
   ↓
Single-Leader
   ↓
Synchronous / Asynchronous
   ↓
Sharding
   ↓
Access Controls
   ↓
SQL Injection
   ↓
Prepared Statements
```

---

# 65. Final Revision

```text
WEEK 6 = SCALING

Database Servers
       ↓
MySQL + PostgreSQL
       ↓
Stored Procedures
       ↓
Scaling
   ↙       ↘
Vertical   Horizontal
             ↓
        Replication
             ↓
      Single Leader
             ↓
       Sharding
             ↓
      Access Control
             ↓
       SQL Injection
             ↓
    Prepared Statements
```

### Core idea

**Week 6 moves from working with databases locally toward building and securing databases that can support larger applications and more users.**
