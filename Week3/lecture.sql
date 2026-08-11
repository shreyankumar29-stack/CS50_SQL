CREATE TABLE "artists" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "collections" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "created" (
    "artist_id" INTEGER,
    "collection_id" INTEGER,
    PRIMARY KEY ("artist_id", "collection_id"),
    FOREIGN KEY ("artist_id") REFERENCES "artists"("id"),
    FOREIGN KEY ("collection_id") REFERENCES "collections"("id")
);


INSERT INTO "artists" ("id", "name")
VALUES
(1, 'Li Yin'),
(2, 'Qian Weicheng'),
(3, 'Unidentified artist'),
(4, 'Zhou Chen');


INSERT INTO "collections" ("id", "title")
VALUES
(1, 'Farmers working at dawn'),
(2, 'Imaginative landscape'),
(3, 'Profusion of flowers'),
(4, 'Spring outing');


INSERT INTO "created" ("artist_id", "collection_id")
VALUES
(1, 2),
(2, 3),
(3, 1),
(4, 4);

SELECT * FROM "artists";
SELECT * FROM "collections";
SELECT * FROM "created";

DELETE FROM "artists" WHERE "artist_id" = (
    SELECT "id" FROM "artists" WHERE "name" = 'Unidentified artist'
);

DELETE FROM "created" WHERE "artist_id" = (
    SELECT "id" FROM "artists" WHERE "name" = 'Unidentified artist'
);

