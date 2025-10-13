CREATE TABLE Trains (
    TrainID INT PRIMARY KEY,
    TrainName VARCHAR(100) NOT NULL,
    Capacity INT NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    Origin VARCHAR(100) NOT NULL,
    Destination VARCHAR(100) NOT NULL
);

