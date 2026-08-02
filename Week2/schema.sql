CREATE TABLE    "riders" (
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

CREATE TABLE "visits" (
    "id" INTEGER,
    "rider_id" INTEGER NOT NULL,
    "station_id" INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("rider_id") REFERENCES "riders"("id"),
    FOREIGN KEY("station_id") REFERENCES "stations"("id")
);


