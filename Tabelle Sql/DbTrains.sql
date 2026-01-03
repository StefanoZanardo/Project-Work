---------------------------------------------------
-- 1) CATEGORY
---------------------------------------------------
CREATE TABLE CATEGORY (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    TrainCategory NVARCHAR(50) NOT NULL,
    PriorityValue INT NOT NULL
);

---------------------------------------------------
-- 2) TRAINS
---------------------------------------------------
CREATE TABLE TRAINS (
    TrainID INT IDENTITY(1,1) PRIMARY KEY,
    Destination NVARCHAR(100) NOT NULL,
    Vagons INT NOT NULL,
    TimeDelay INT NOT NULL,  -- in minuti
    DepartureTrain DATETIME NOT NULL,
    ArrivalTrain DATETIME NOT NULL,
    CategoryID INT NOT NULL,
    CONSTRAINT FK_TRAINS_CATEGORY FOREIGN KEY (CategoryID)
        REFERENCES CATEGORY(CategoryID)
);

---------------------------------------------------
-- 3) RAIL
---------------------------------------------------
CREATE TABLE RAIL (
    RailID INT IDENTITY(1,1) PRIMARY KEY,
    RailName NVARCHAR(50) NOT NULL
);

---------------------------------------------------
-- 4) SEGMENTRAIL
---------------------------------------------------
CREATE TABLE SEGMENTRAIL (
    SegmentRailID INT IDENTITY(1,1) PRIMARY KEY,
    RailID INT NOT NULL,
    SegmentName NVARCHAR(50) NOT NULL,
    IsOccupied BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_SEGMENTRAIL_RAIL FOREIGN KEY (RailID)
        REFERENCES RAIL(RailID)
);

---------------------------------------------------
-- 5) STOPLIGHT
---------------------------------------------------
CREATE TABLE STOPLIGHT (
    StoplightID INT IDENTITY(1,1) PRIMARY KEY,
    SegmentRailID INT NOT NULL,
    Redlight BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_STOPLIGHT_SEGMENTRAIL FOREIGN KEY (SegmentRailID)
        REFERENCES SEGMENTRAIL(SegmentRailID)
);

---------------------------------------------------
-- 6) CROSSROADS
---------------------------------------------------
CREATE TABLE CROSSROADS (
    CrossroadID INT IDENTITY(1,1) PRIMARY KEY,
    SegmentTrait1 INT NOT NULL,
    SegmentTrait2 INT NOT NULL,
    Changelane BIT NOT NULL DEFAULT 0,
    IsOccupied BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_CROSSROADS_SEGMENT1 FOREIGN KEY (SegmentTrait1)
        REFERENCES SEGMENTRAIL(SegmentRailID),
    CONSTRAINT FK_CROSSROADS_SEGMENT2 FOREIGN KEY (SegmentTrait2)
        REFERENCES SEGMENTRAIL(SegmentRailID)
);

---------------------------------------------------
-- 7) WAGONS
---------------------------------------------------
CREATE TABLE WAGONS (
    WagonID INT IDENTITY(1,1) PRIMARY KEY,
    TrainID INT NOT NULL,
    WagonsSegment INT NOT NULL,
    Capacity INT NOT NULL,
    CONSTRAINT FK_WAGONS_TRAINS FOREIGN KEY (TrainID)
        REFERENCES TRAINS(TrainID),
    CONSTRAINT FK_WAGONS_SEGMENTRAIL FOREIGN KEY (WagonsSegment)
        REFERENCES SEGMENTRAIL(SegmentRailID)
);
