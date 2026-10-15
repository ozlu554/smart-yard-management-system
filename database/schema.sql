CREATE DATABASE SmartYardDB;
GO

USE SmartYardDB;
GO

CREATE TABLE Docks (
    DockId INT IDENTITY(1,1) PRIMARY KEY,
    DockNumber VARCHAR(20) NOT NULL UNIQUE,
    DockType VARCHAR(50) NOT NULL,
    CurrentStatus VARCHAR(30) NOT NULL DEFAULT 'Available',
    MaxWeightCapacityKG DECIMAL(10,2) NULL,
    CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME()
);
GO

CREATE TABLE Vehicles (
    VehicleId INT IDENTITY(1,1) PRIMARY KEY,
    PlateNumber VARCHAR(30) NOT NULL UNIQUE,
    CarrierCompany VARCHAR(100) NOT NULL,
    DriverName VARCHAR(100) NULL,
    DriverPhone VARCHAR(30) NULL,
    CargoType VARCHAR(50) NOT NULL,
    CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME()
);
GO

CREATE TABLE Appointments (
    AppointmentId INT IDENTITY(1,1) PRIMARY KEY,
    VehicleId INT NOT NULL,
    ScheduledArrivalTime DATETIME2 NOT NULL,
    EstimatedProcessMinutes INT NOT NULL DEFAULT 45,
    Status VARCHAR(30) NOT NULL DEFAULT 'Scheduled',
    CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Appointments_Vehicles FOREIGN KEY (VehicleId) REFERENCES Vehicles(VehicleId)
);
GO

CREATE TABLE DockAssignments (
    AssignmentId INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentId INT NOT NULL,
    DockId INT NOT NULL,
    AssignedAt DATETIME2 DEFAULT SYSUTCDATETIME(),
    ProcessStartTime DATETIME2 NULL,
    ProcessEndTime DATETIME2 NULL,
    Status VARCHAR(30) NOT NULL DEFAULT 'Assigned',
    CONSTRAINT FK_Assignments_Appointments FOREIGN KEY (AppointmentId) REFERENCES Appointments(AppointmentId),
    CONSTRAINT FK_Assignments_Docks FOREIGN KEY (DockId) REFERENCES Docks(DockId)
);
GO

CREATE TABLE YardLogs (
    LogId BIGINT IDENTITY(1,1) PRIMARY KEY,
    VehicleId INT NOT NULL,
    GateCheckInTime DATETIME2 NOT NULL,
    DockArrivalTime DATETIME2 NULL,
    DockReleaseTime DATETIME2 NULL,
    GateCheckOutTime DATETIME2 NULL,
    TotalYardMinutes AS DATEDIFF(MINUTE, GateCheckInTime, GateCheckOutTime),
    CONSTRAINT FK_YardLogs_Vehicles FOREIGN KEY (VehicleId) REFERENCES Vehicles(VehicleId)
);
GO