CREATE, READ, UPDATE, DELETE, INSERT

---

## Example: Inserting values for Meuseum of Fine Arts

INSERT INTO museum(title,accession_number,acquired) VALUES('Profusion of flowers','56.257','1956-04-01');

INSERT INTO museum(title,accession_number,acquired) VALUES('Farmers working at down','11.6152','1911-08-03');

INSERT INTO museum(title,accession_number,acquired) VALUES('Spring Outing','14.76','1941-01-08');


|id|title|accession_number|acquired|
|--|-----|----------------|--------|
|1|Profusion of flowers|56.257|1956-04-01|
|2|Farmers working at down|11.6152|1911-08-03|
|3|Spring Outing|14.76|1941-01-08|


Let's try one more:

INSERT INTO "collections"("title","accession_number","acquired) VALUES (NULL, NULL, '1900-01-10');

# Reason why this won't work

When we try to execute this query in SQL it won't be execute as we have already specified that "title" and "accession_number" as NOT NULL.

---

**SYNTAX:**

INSERT INTO table(column0,.......) VALUES(value0,......);

---

