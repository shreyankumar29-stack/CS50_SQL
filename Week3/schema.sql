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