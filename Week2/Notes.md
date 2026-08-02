# Normalizing: 
To reduce redundancy

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

# Types of Normal Forms:
1. FIRST NORMAL FORM
2. SECOND NORMAL FORM
3. THIRD NORMAL FORM


# Relating
We now need to decide how our entities (riders and stations) are related.

**Example:**
![alt text](image.png)
![alt text](image-1.png)

# CREATE TABLE:
Createing a brand new table.

**Example:**
CREATE TABLE "riders" (
    "id",
    "name"
);

# Data Types and Storage Class:
Five types of Storage Class:-
1. NULL-No data
2. INTEGER- A whole numbers(from 0 to infinity)
3. REAL- decimal or floating point numbers
4. TEXT- 