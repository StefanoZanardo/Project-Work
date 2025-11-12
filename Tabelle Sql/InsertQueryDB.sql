INSERT INTO public.category(
	 traincategory, priorityvalue)
	VALUES ('transito', 5),
		 ('freccia', 4),
		 ('veloce', 3),
		 ('regionale', 2),
		 ('stazionario', 1);


INSERT INTO TRAINS
    (Destination, Vagons, TimeDelay, DepartureTrain, ArrivalTrain, CategoryID)
VALUES
    -- 10 Treni Passeggeri (ID 2, 3, 4)
    ('Torino Porta Nuova', 11, 0, '2025-11-13 10:00:00', '2025-11-13 14:30:00', 2), -- Freccia
    ('Verona Porta Nuova', 7, 10, '2025-11-13 10:10:00', '2025-11-13 11:50:00', 4), -- Regionale
    ('Genova Piazza Principe', 9, 5, '2025-11-13 10:20:00', '2025-11-13 12:30:00', 3), -- Veloce
    ('Bari Centrale', 10, 0, '2025-11-13 10:30:00', '2025-11-13 15:00:00', 2), -- Freccia
    ('Treviso Centrale', 5, 20, '2025-11-13 10:40:00', '2025-11-13 11:10:00', 4), -- Regionale
    ('Padova', 8, 0, '2025-11-13 10:50:00', '2025-11-13 11:40:00', 3), -- Veloce
    ('Siena', 6, 5, '2025-11-13 11:00:00', '2025-11-13 12:30:00', 4), -- Regionale
    ('Milano Centrale', 12, 0, '2025-11-13 11:10:00', '2025-11-13 14:10:00', 2), -- Freccia
    ('Salerno', 9, 10, '2025-11-13 11:20:00', '2025-11-13 14:00:00', 3), -- Veloce
    ('Vicenza', 7, 0, '2025-11-13 11:30:00', '2025-11-13 12:00:00', 4), -- Regionale

    -- 5 Treni Cargo (ID 1, 5)
    ('Scalo Merci Verona', 15, 30, '2025-11-13 04:00:00', '2025-11-13 08:00:00', 1), -- Transito
    ('Deposito Mestre', 12, 0, '2025-11-13 04:15:00', '2025-11-13 04:45:00', 5), -- Stazionario
    ('Interporto Padova', 14, 10, '2025-11-13 04:30:00', '2025-11-13 07:00:00', 1), -- Transito
    ('Scalo Merci Napoli', 15, 60, '2025-11-13 05:00:00', '2025-11-13 11:00:00', 1), -- Transito
    ('Deposito Torino', 10, 0, '2025-11-13 05:15:00', '2025-11-13 06:00:00', 5); -- Stazionario



    INSERT INTO RAIL (RailName)
VALUES
    ('Binario 1'),  -- ID 1
    ('Binario 2'),  -- ID 2
    ('Binario 3'),  -- ID 3
    ('Scalo Merci Est'), -- ID 4
    ('Area Manovra A'); -- ID 5


    INSERT INTO SEGMENTRAIL (RailID, SegmentName, IsOccupied)
VALUES
    (1, 'B1-Sezione-A', TRUE),  -- ID 1 (Su Binario 1, occupato)
    (1, 'B1-Sezione-B', FALSE), -- ID 2 (Su Binario 1)
    (2, 'B2-Sezione-A', TRUE),  -- ID 3 (Su Binario 2, occupato)
    (2, 'B2-Sezione-B', FALSE), -- ID 4 (Su Binario 2)
    (4, 'SME-Ingresso', TRUE), -- ID 5 (Su Scalo Merci, occupato)
    (4, 'SME-Uscita', FALSE),  -- ID 6 (Su Scalo Merci)
    (5, 'AMA-Girello', FALSE); -- ID 7 (Su Area Manovra)

    INSERT INTO STOPLIGHT (SegmentRailID, Redlight)
VALUES
    (1, TRUE),  -- Semaforo ROSSO all'ingresso del Segmento 1 (B1-A)
    (3, FALSE), -- Semaforo VERDE all'ingresso del Segmento 3 (B2-A)
    (5, FALSE); -- Semaforo VERDE all'ingresso del Segmento 5 (SME-Ingresso)

    INSERT INTO CROSSROADS (SegmentTrait1, SegmentTrait2, Changelane, IsOccupied)
VALUES
    (2, 4, TRUE, FALSE), -- Scambio tra B1-B (ID 2) e B2-B (ID 4)
    (6, 7, FALSE, FALSE); -- Scambio tra SME-Uscita (ID 6) e AMA-Girello (ID 7)


    INSERT INTO WAGONS (TrainID, WagonsSegment, Capacity)
VALUES
    -- Vagoni del Treno 1 (Freccia) - sul Segmento 1 (B1-A)
    (1, 1, 50),  -- Treno 1, Segmento 1
    (1, 1, 75),  -- Treno 1, Segmento 1
    (1, 1, 75),  -- Treno 1, Segmento 1

    -- Vagoni del Treno 3 (Regionale) - sul Segmento 3 (B2-A)
    (3, 3, 80),  -- Treno 3, Segmento 3
    (3, 3, 80),  -- Treno 3, Segmento 3

    -- Vagoni del Treno 9 (Cargo Transito) - sul Segmento 5 (SME-Ingresso)
    (9, 5, 1500), -- Treno 9, Segmento 5
    (9, 5, 1500), -- Treno 9, Segmento 5
    (9, 5, 1200); -- Treno 9, Segmento 5

