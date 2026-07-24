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
1. books                                        2. ratings 
   |id |isbn|title|                                 isbn|rating|
   |---|----|-----|                                 |-----|------|
   |1|9788439736967|Boulder|                        |9788439736967|4|
   |2|9780525573067|The White Book|                 |9788439736967|3|
   |3|9781529414431|Standing Heavy|                 |9788439736967|5|
   |4|9781910695432|Flights|                        |9780525573067|2|
                                                    |9780525573067|3|
                                                    |9781529414431|4|
                                                    |9781910695432|5|
                                                    |9781910695432|4|
                                                    

                                                    