---------------------------------------------------
-- INSERT CATEGORY
---------------------------------------------------
INSERT INTO CATEGORY (TrainCategory, PriorityValue)
VALUES 
    ('transito', 5),
    ('freccia', 4),
    ('veloce', 3),
    ('regionale', 2),
    ('stazionario', 1);

---------------------------------------------------
-- INSERT TRAINS
---------------------------------------------------
INSERT INTO TRAINS
    (Destination, Vagons, TimeDelay, DepartureTrain, ArrivalTrain, CategoryID)
VALUES
    -- 10 Treni Passeggeri
    ('Torino Porta Nuova', 11, 0, '2025-11-13 10:00:00', '2025-11-13 14:30:00', 2),
    ('Verona Porta Nuova', 7, 10, '2025-11-13 10:10:00', '2025-11-13 11:50:00', 4),
    ('Genova Piazza Principe', 9, 5, '2025-11-13 10:20:00', '2025-11-13 12:30:00', 3),
    ('Bari Centrale', 10, 0, '2025-11-13 10:30:00', '2025-11-13 15:00:00', 2),
    ('Treviso Centrale', 5, 20, '2025-11-13 10:40:00', '2025-11-13 11:10:00', 4),
    ('Padova', 8, 0, '2025-11-13 10:50:00', '2025-11-13 11:40:00', 3),
    ('Siena', 6, 5, '2025-11-13 11:00:00', '2025-11-13 12:30:00', 4),
    ('Milano Centrale', 12, 0, '2025-11-13 11:10:00', '2025-11-13 14:10:00', 2),
    ('Salerno', 9, 10, '2025-11-13 11:20:00', '2025-11-13 14:00:00', 3),
    ('Vicenza', 7, 0, '2025-11-13 11:30:00', '2025-11-13 12:00:00', 4),

    -- 5 Treni Cargo
    ('Scalo Merci Verona', 15, 30, '2025-11-13 04:00:00', '2025-11-13 08:00:00', 1),
    ('Deposito Mestre', 12, 0, '2025-11-13 04:15:00', '2025-11-13 04:45:00', 5),
    ('Interporto Padova', 14, 10, '2025-11-13 04:30:00', '2025-11-13 07:00:00', 1),
    ('Scalo Merci Napoli', 15, 60, '2025-11-13 05:00:00', '2025-11-13 11:00:00', 1),
    ('Deposito Torino', 10, 0, '2025-11-13 05:15:00', '2025-11-13 06:00:00', 5);

---------------------------------------------------
-- INSERT RAIL
---------------------------------------------------
INSERT INTO RAIL (RailName)
VALUES
    ('Binario 1'),
    ('Binario 2'),
    ('Binario 3'),
    ('Scalo Merci Est'),
    ('Area Manovra A');

---------------------------------------------------
-- INSERT SEGMENTRAIL
---------------------------------------------------
INSERT INTO SEGMENTRAIL (RailID, SegmentName, IsOccupied)
VALUES
    (1, 'B1-Sezione-A', 1),
    (1, 'B1-Sezione-B', 0),
    (2, 'B2-Sezione-A', 1),
    (2, 'B2-Sezione-B', 0),
    (4, 'SME-Ingresso', 1),
    (4, 'SME-Uscita', 0),
    (5, 'AMA-Girello', 0);

---------------------------------------------------
-- INSERT STOPLIGHT
---------------------------------------------------
INSERT INTO STOPLIGHT (SegmentRailID, Redlight)
VALUES
    (1, 1),
    (3, 0),
    (5, 0);

---------------------------------------------------
-- INSERT CROSSROADS
---------------------------------------------------
INSERT INTO CROSSROADS (SegmentTrait1, SegmentTrait2, Changelane, IsOccupied)
VALUES
    (2, 4, 1, 0),
    (6, 7, 0, 0);

---------------------------------------------------
-- INSERT WAGONS
---------------------------------------------------
INSERT INTO WAGONS (TrainID, WagonsSegment, Capacity)
VALUES
    -- Vagoni del Treno 1 (Freccia)
    (1, 1, 50),
    (1, 1, 75),
    (1, 1, 75),

    -- Vagoni del Treno 3 (Regionale)
    (3, 3, 80),
    (3, 3, 80),

    -- Vagoni del Treno 9 (Cargo Transito)
    (9, 5, 1500),
    (9, 5, 1500),
    (9, 5, 1200);

CREATE TABLE ACTUALPOSITION (
    ActualPositionId INT IDENTITY(1,1) NOT NULL,
    x REAL NOT NULL,
    y REAL NOT NULL,
    speed REAL NOT NULL,
    TrainId INT NULL,
    
    -- Definizione della Chiave Primaria
    CONSTRAINT PK_ActualPosition PRIMARY KEY (ActualPositionId),
    
    -- Definizione della Chiave Esterna (Assumendo che esista una tabella 'Train')
    CONSTRAINT FK_ActualPosition_Train FOREIGN KEY (TrainId) REFERENCES TRAINS(TrainId)
);

ALTER TABLE TRAINS
ADD ActualPositionId INT NULL;
GO

-- 2. Crea il vincolo di Chiave Esterna che punta ad ActualPosition
ALTER TABLE TRAINS
ADD CONSTRAINT FK_Train_ActualPosition 
FOREIGN KEY (ActualPositionId) REFERENCES ActualPosition(ActualPositionId);
GO


INSERT INTO [dbo].[ACTUALPOSITION] ([x], [y], [speed], [TrainId])
VALUES 
    (-511.6, 210.0, 0, NULL), -- L1
    (-511.6, 260.0, 0, NULL), -- L2
    (1576.6, 210.0, 0, NULL), -- R1
    (1575.6, 260.0, 0, NULL), -- R2
    (227.0,  708.0, 0, NULL), -- C1
    (294.0,  690.0, 0, NULL); -- C2



INSERT INTO [dbo].[credential]
           ([NomeUtente]
           ,[Password]
           ,[Salt]
           ,[DataCreazione])
     VALUES
           ('admin'
           ,'CC0100C727B22BFAD52EE2E91BC18198D3B15EA387A970CEDAED98BA0357C1FC'
           ,'55CF12AFE04808AA722ECE7963869509'
           ,SYSDATETIME())
GO