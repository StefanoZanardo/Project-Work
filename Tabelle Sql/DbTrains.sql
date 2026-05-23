---------------------------------------------------
-- 1) CATEGORY
---------------------------------------------------
CREATE TABLE CATEGORY (
    CategoryID    INT IDENTITY(1,1) PRIMARY KEY,
    TrainCategory NVARCHAR(50) NOT NULL,
    PriorityValue INT NOT NULL
);

---------------------------------------------------
-- 2) RAIL
---------------------------------------------------
CREATE TABLE RAIL (
    RailID   INT IDENTITY(1,1) PRIMARY KEY,
    RailName NVARCHAR(50) NOT NULL
);

---------------------------------------------------
-- 3) SEGMENTRAIL
---------------------------------------------------
CREATE TABLE SEGMENTRAIL (
    SegmentRailID INT IDENTITY(1,1) PRIMARY KEY,
    RailID        INT NOT NULL,
    SegmentName   NVARCHAR(50) NOT NULL,
    IsOccupied    BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_SEGMENTRAIL_RAIL FOREIGN KEY (RailID)
        REFERENCES RAIL(RailID)
);

---------------------------------------------------
-- 4) STOPLIGHT
---------------------------------------------------
CREATE TABLE STOPLIGHT (
    StoplightID   INT IDENTITY(1,1) PRIMARY KEY,
    SegmentRailID INT NOT NULL,
    RedLight      BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_STOPLIGHT_SEGMENTRAIL FOREIGN KEY (SegmentRailID)
        REFERENCES SEGMENTRAIL(SegmentRailID)
);

---------------------------------------------------
-- 5) CROSSROADS
---------------------------------------------------
CREATE TABLE CROSSROADS (
    CrossroadID   INT IDENTITY(1,1) PRIMARY KEY,
    SegmentTrait1 INT NOT NULL,
    SegmentTrait2 INT NOT NULL,
    ChangeLane    BIT NOT NULL DEFAULT 1,
    IsOccupied    BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_CROSSROADS_SEGMENT1 FOREIGN KEY (SegmentTrait1)
        REFERENCES SEGMENTRAIL(SegmentRailID),
    CONSTRAINT FK_CROSSROADS_SEGMENT2 FOREIGN KEY (SegmentTrait2)
        REFERENCES SEGMENTRAIL(SegmentRailID)
);

---------------------------------------------------
-- 6) TRAINS
---------------------------------------------------
CREATE TABLE TRAINS (
    TrainID          UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID() PRIMARY KEY,
    Destination      NVARCHAR(100) NOT NULL,
    Vagons           INT NOT NULL,
    TimeDelay        INT NOT NULL,
    DepartureTrain   DATETIME NOT NULL,
    ArrivalTrain     DATETIME NOT NULL,
    CategoryID       INT NULL,
    ActualPositionId INT NULL,
    CONSTRAINT FK_TRAINS_CATEGORY FOREIGN KEY (CategoryID)
        REFERENCES CATEGORY(CategoryID)
);

---------------------------------------------------
-- 7) ACTUALPOSITION
---------------------------------------------------
CREATE TABLE ACTUALPOSITION (
    ActualPositionId INT IDENTITY(1,1) PRIMARY KEY,
    x                REAL NOT NULL DEFAULT 0,
    y                REAL NOT NULL DEFAULT 0,
    speed            REAL NOT NULL DEFAULT 0,
    TrainID          UNIQUEIDENTIFIER NULL,
    CONSTRAINT FK_ACTUALPOSITION_TRAINS FOREIGN KEY (TrainID)
        REFERENCES TRAINS(TrainID)
);

---------------------------------------------------
-- 8) WAGONS
---------------------------------------------------
CREATE TABLE WAGONS (
    WagonID       INT IDENTITY(1,1) PRIMARY KEY,
    TrainID       UNIQUEIDENTIFIER NULL,
    WagonsSegment INT NULL,
    Capacity      INT NOT NULL,
    CONSTRAINT FK_WAGONS_TRAINS FOREIGN KEY (TrainID)
        REFERENCES TRAINS(TrainID),
    CONSTRAINT FK_WAGONS_SEGMENTRAIL FOREIGN KEY (WagonsSegment)
        REFERENCES SEGMENTRAIL(SegmentRailID)
);

---------------------------------------------------
-- 9) CREDENTIAL
---------------------------------------------------
CREATE TABLE [dbo].[credential]
(
    [Id]            INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_credential PRIMARY KEY,
    [NomeUtente]    NVARCHAR(100)     NOT NULL,
    [Password]      NVARCHAR(256)     NOT NULL,
    [Salt]          NVARCHAR(256)     NOT NULL,
    [DataCreazione] DATETIME2(0)      NOT NULL CONSTRAINT DF_credential_DataCreazione DEFAULT (SYSUTCDATETIME())
);

---------------------------------------------------
-- 1) CATEGORY
---------------------------------------------------
CREATE TABLE CATEGORY (
    CategoryID    INT IDENTITY(1,1) PRIMARY KEY,
    TrainCategory NVARCHAR(50) NULL,
    PriorityValue INT NOT NULL
);

---------------------------------------------------
-- 2) RAIL
---------------------------------------------------
CREATE TABLE RAIL (
    RailID   INT IDENTITY(1,1) PRIMARY KEY,
    RailName NVARCHAR(50) NULL
);

---------------------------------------------------
-- 3) SEGMENTRAIL
---------------------------------------------------
CREATE TABLE SEGMENTRAIL (
    SegmentRailID INT IDENTITY(1,1) PRIMARY KEY,
    RailID        INT NULL,
    SegmentName   NVARCHAR(50) NULL,
    IsOccupied    BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_SEGMENTRAIL_RAIL FOREIGN KEY (RailID)
        REFERENCES RAIL(RailID)
);

---------------------------------------------------
-- 4) STOPLIGHT
---------------------------------------------------
CREATE TABLE STOPLIGHT (
    StoplightID   INT IDENTITY(1,1) PRIMARY KEY,
    SegmentRailID INT NULL,
    RedLight      BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_STOPLIGHT_SEGMENTRAIL FOREIGN KEY (SegmentRailID)
        REFERENCES SEGMENTRAIL(SegmentRailID)
);

---------------------------------------------------
-- 5) CROSSROADS
---------------------------------------------------
CREATE TABLE CROSSROADS (
    CrossroadID   INT IDENTITY(1,1) PRIMARY KEY,
    SegmentTrait1 INT NULL,
    SegmentTrait2 INT NULL,
    ChangeLane    BIT NOT NULL DEFAULT 1,
    IsOccupied    BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_CROSSROADS_SEGMENT1 FOREIGN KEY (SegmentTrait1)
        REFERENCES SEGMENTRAIL(SegmentRailID),
    CONSTRAINT FK_CROSSROADS_SEGMENT2 FOREIGN KEY (SegmentTrait2)
        REFERENCES SEGMENTRAIL(SegmentRailID)
);

---------------------------------------------------
-- 6) ACTUALPOSITION
---------------------------------------------------
CREATE TABLE ACTUALPOSITION (
    ActualPositionId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID() PRIMARY KEY,
    x                REAL NOT NULL DEFAULT 0,
    y                REAL NOT NULL DEFAULT 0,
    speed            REAL NOT NULL DEFAULT 0
);

---------------------------------------------------
-- 7) TRAINS
---------------------------------------------------
CREATE TABLE TRAINS (
    TrainID          UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID() PRIMARY KEY,
    Destination      NVARCHAR(100) NULL,
    Vagons           INT NOT NULL,
    TimeDelay        INT NOT NULL,
    DepartureTrain   DATETIME NOT NULL,
    ArrivalTrain     DATETIME NOT NULL,
    CategoryID       INT NULL,
    ActualPositionId UNIQUEIDENTIFIER NULL,
    CONSTRAINT FK_TRAINS_CATEGORY FOREIGN KEY (CategoryID)
        REFERENCES CATEGORY(CategoryID),
    CONSTRAINT FK_TRAINS_ACTUALPOSITION FOREIGN KEY (ActualPositionId)
        REFERENCES ACTUALPOSITION(ActualPositionId)
);

---------------------------------------------------
-- 8) WAGONS
---------------------------------------------------
CREATE TABLE WAGONS (
    WagonID       INT IDENTITY(1,1) PRIMARY KEY,
    TrainID       UNIQUEIDENTIFIER NULL,
    WagonsSegment INT NULL,
    Capacity      INT NOT NULL,
    CONSTRAINT FK_WAGONS_TRAINS FOREIGN KEY (TrainID)
        REFERENCES TRAINS(TrainID),
    CONSTRAINT FK_WAGONS_SEGMENTRAIL FOREIGN KEY (WagonsSegment)
        REFERENCES SEGMENTRAIL(SegmentRailID)
);

---------------------------------------------------
-- 9) CREDENTIAL
---------------------------------------------------
CREATE TABLE [dbo].[credential]
(
    [Id]            INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_credential PRIMARY KEY,
    [NomeUtente]    NVARCHAR(100)     NOT NULL,
    [Password]      NVARCHAR(256)     NOT NULL,
    [Salt]          NVARCHAR(256)     NOT NULL,
    [DataCreazione] DATETIME2(0)      NOT NULL CONSTRAINT DF_credential_DataCreazione DEFAULT (SYSUTCDATETIME())
);