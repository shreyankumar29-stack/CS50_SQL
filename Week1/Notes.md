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
    |  isbn  |rating|                                   
    |--------|------|                                  
    |9788439736967|4|                                               
    |9788439736967|3|   
    |9788439736967|5|                                             
    |9780525573067|2|
    |9780525573067|3|
    |9781529414431|4|  
    |9781910695432|5|              
    |9781910695432|4|          

    Notice how the primary key of the books table is now a column in the ratings table. This helps form a one-to-many relationship between the two tables — a book with a title (found in the books table) can have multiple ratings (found in the ratings table).
    The ISBN, as we can see, is a long identifier. If each character occupied a byte of memory, storing a single ISBN (including the dashes) would take 17 bytes of memory, which is a lot!
    we don’t necessarily have to use the ISBN as a primary key. We can just construct our own using numbers like 1, 2, 3… and so on as long as each book has a unique number to identify it.

## SubQuery: 
One SQL query inside another Query.                    
**Example**: