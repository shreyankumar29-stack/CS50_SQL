CREATE TABLE "riders" (
    "id" INTEGER,
    "name" TEXT
);

CREATE TABLE "stations" (
    "id" INTEGER,
    "name" TEXT,
    "line" TEXT
);

CREATE TABLE "visits" (
    "rider_id" INTEGER,
    "station_id" INTEGER
);

