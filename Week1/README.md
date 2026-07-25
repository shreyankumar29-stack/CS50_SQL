# CS50 SQL - Week 1: Relating

## Overview

Week 1 introduces the concept of **Relational Databases** and explains how multiple tables can be connected using relationships. This week focuses on retrieving data from related tables using different types of SQL joins and organizing grouped data with aggregate functions.

---

## Learning Objectives

After completing this week, I learned:

- What a Relational Database is.
- Why relational databases are better than storing everything in a single table.
- Primary Keys and Foreign Keys.
- One-to-One, One-to-Many, and Many-to-Many relationships.
- INNER JOIN
- LEFT OUTER JOIN
- RIGHT OUTER JOIN
- FULL OUTER JOIN (Concept)
- NATURAL JOIN
- GROUP BY
- HAVING
- Aggregate Functions
  - COUNT()
  - SUM()
  - AVG()
  - MIN()
  - MAX()

---

## Topics Covered

### Relational Databases
- Database Relationships
- Primary Keys
- Foreign Keys

### SQL Joins
- INNER JOIN
- LEFT OUTER JOIN
- RIGHT OUTER JOIN (Concept)
- FULL OUTER JOIN (Concept)
- NATURAL JOIN

### Aggregate Functions
- COUNT()
- SUM()
- AVG()
- MIN()
- MAX()

### Grouping Data
- GROUP BY
- HAVING

---

## Folder Structure

```text
Week1/
│
├── README.md
├── notes.md
├── lecture.sql
│
└── src1/
    ├── books.csv
    ├── authors.csv
    ├── ratings.csv
    ├── longlist.db
    ├── sea_lions.db
    ├── ...
```

---

## Files Included

| File | Description |
|------|-------------|
| `README.md` | Overview of Week 1 concepts |
| `notes.md` | Personal notes written while watching the lecture |
| `lecture.sql` | SQL queries demonstrated during the lecture |
| `practice.sql` | Additional SQL queries written for practice |
| `src1/` | Official CS50 Week 1 datasets and database files |

---

## Key Concepts Learned

- Understanding relationships between multiple tables.
- Connecting tables using JOIN operations.
- Difference between INNER, LEFT, RIGHT, FULL OUTER, and NATURAL JOIN.
- Using aggregate functions to summarize data.
- Grouping rows using `GROUP BY`.
- Filtering grouped data using `HAVING`.
- Understanding why aggregate functions cannot be used with the `WHERE` clause.

---

## Notes

- These notes are written in my own words to make future revision easier.
- The `src1` folder contains the original datasets and databases provided with the CS50 SQL course.
- Examples and practice queries are based on the lecture content.

---

## Resources

- CS50 SQL Week 1 Lecture
- CS50 SQL Official Notes
- CS50 SQL Problem Set 1

---

## Progress

- [x] Week 1 Lecture Completed
- [x] Notes Completed
- [x] SQL Queries Practiced
- [ ] Problem Set Completed
- [ ] Additional Practice

---

## What I Learned This Week

This week helped me understand how relational databases organize data across multiple tables instead of storing everything in one place. I learned how SQL joins retrieve related information, how aggregate functions summarize data, and how `GROUP BY` and `HAVING` work together to analyze grouped records.