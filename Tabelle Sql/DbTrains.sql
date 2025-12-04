---------------------------------------------------
-- 1) CATEGORY
---------------------------------------------------
INSERT INTO CATEGORY (TrainCategory, PriorityValue)
VALUES 
    ('transito', 5),
    ('freccia', 4),
    ('veloce', 3),
    ('regionale', 2),
    ('stazionario', 1);

---------------------------------------------------
-- 2) TRAINS
-- NOTA: CategoryID corrisponde all’ordine inserito sopra
-- 1=transito, 2=freccia, 3=veloce, 4=regionale, 5=stazionario
---------------------------------------------------
INSERT INTO TRAINS
    (Destination, Vagons, TimeDelay, DepartureTrain, ArrivalTrain, CategoryID)
VALUES
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

    ('Scalo Merci Verona', 15, 30, '2025-11-13 04:00:00', '2025-11-13 08:00:00', 1),
    ('Deposito Mestre', 12, 0, '2025-11-13 04:15:00', '2025-11-13 04:45:00', 5),
    ('Interporto Padova', 14, 10, '2025-11-13 04:30:00', '2025-11-13 07:00:00', 1),
    ('Scalo Merci Napoli', 15, 60, '2025-11-13 05:00:00', '2025-11-13 11:00:00', 1),
    ('Deposito Torino', 10, 0, '2025-11-13 05:15:00', '2025-11-13 06:00:00', 5);

---------------------------------------------------
-- 3) RAIL
---------------------------------------------------
INSERT INTO RAIL (RailName)
VALUES
    ('Binario 1'),
    ('Binario 2'),
    ('Binario 3'),
    ('Scalo Merci Est'),
    ('Area Manovra A');

---------------------------------------------------
-- 4) SEGMENTRAIL
-- I SegmentRailID seguiranno l'ordine IDENTITÀ
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
-- 5) STOPLIGHT
-- SegmentRailID è quello generato dall’IDENTITY (1–7)
---------------------------------------------------
INSERT INTO STOPLIGHT (SegmentRailID, Redlight)
VALUES
    (1, 1),
    (3, 0),
    (5, 0);

---------------------------------------------------
-- 6) CROSSROADS
---------------------------------------------------
INSERT INTO CROSSROADS (SegmentTrait1, SegmentTrait2, Changelane, IsOccupied)
VALUES
    (2, 4, 1, 0),
    (6, 7, 0, 0);

---------------------------------------------------
-- 7) WAGONS
-- TrainID e SegmentRailID seguono l’ordine di creazione
---------------------------------------------------
INSERT INTO WAGONS (TrainID, WagonsSegment, Capacity)
VALUES
    (1, 1, 50),
    (1, 1, 75),
    (1, 1, 75),

    (3, 3, 80),
    (3, 3, 80),

    (9, 5, 1500),
    (9, 5, 1500),
    (9, 5, 1200);
