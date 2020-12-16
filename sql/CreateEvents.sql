CREATE TABLE Event(
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    EventName VARCHAR(50) NOT NULL,
    EventDate DATETIME NOT NULL,
    RepeatsEvery SMALLINT NOT NULL DEFAULT 0,
    Active SMALLINT NOT NULL DEFAULT 1,
    Info TEXT,
    BoundPeople VARCHAR(200),
    Address VARCHAR(200),
    Telephone VARCHAR(50),
    Mail VARCHAR(50)
);

-- CREATE UNIQUE INDEX "Event_id_idx" ON Event( "id" );

