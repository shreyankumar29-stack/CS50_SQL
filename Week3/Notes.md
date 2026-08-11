CREATE, READ, UPDATE, DELETE, INSERT

---

## Example: Inserting values for Meuseum of Fine Arts

|id|title|accession_number|acquired|
|--|-----|----------------|--------|
|1|Profusion of flowers|56.257|1956-04-01|
|2|Farmers working at down|11.6152|1911-08-03|
|3|Spring Outing|14.76|1941-01-08|

---

**SYNTAX:**

INSERT INTO table(column0,.......) VALUES(value0,......);

INSERT INTO museum(title,accession_number,acquired) VALUES('Profusion of flowers','56.257','1956-04-01');
INSERT INTO museum(title,accession_number,acquired) VALUES('Farmers working at down','11.6152','1911-08-03');
INSERT INTO museum(title,accession_number,acquired) VALUES('Spring Outing','14.76','1941-01-08');