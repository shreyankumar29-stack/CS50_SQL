CREATE TABLE "riders" (
    "id" INTEGER NOT NULL,
    "name" TEXT,
    PRIMARY KEY ("id")
);

CREATE TABLE "stations" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "line" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "swipes" (
    "id" INTEGER,
    "rider_id" INTEGER NOT NULL,
    "station_id" INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("rider_id") REFERENCES "riders"("id"),
    FOREIGN KEY("station_id") REFERENCES "stations"("id")
);
ALTER TABLE "visits" RENAME TO "swipes";

DROP TABLE "riders";

ALTER TABLE "swipes" ADD COLUMN "ttpe" TEXT;

ALTER TABLE "swipes" RENAME COLUMN "ttpe" TO "type";

ALTER TABLE "swipes" DROP COLUMN "type";