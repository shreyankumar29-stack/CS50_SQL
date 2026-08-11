CREATE TABLE "collections" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "accession_number" TEXT NOT NULL UNIQUE,
    "acquired" NUMERIC,
    PRIMARY KEY("id")
);

INSERT INTO "collections" ("title", "accession_number", "acquired") 
SELECT "title", "accession_number", "acquired" FROM "temp";

DROP TABLE "temp";

DELETE FROM "collections" WHERE "title" = 'Spring outing';

DELETE FROM "collections" WHERE "acquired" IS  NULL;

DELETE FROM "collections" WHERE "acquired" < '1909-01-01';

SELECT * FROM "collections";