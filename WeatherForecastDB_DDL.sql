SET NOCOUNT ON;

IF DB_ID(N'WeatherForecastDB') IS NOT NULL
BEGIN
    ALTER DATABASE [WeatherForecastDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [WeatherForecastDB];
END;
GO

CREATE DATABASE [WeatherForecastDB];
GO

USE [WeatherForecastDB];
GO


CREATE TABLE dbo.Alert_Type (
    Alert_Type_ID INT IDENTITY(1,1) PRIMARY KEY,
    Code          VARCHAR(15) NOT NULL,
    Severity      VARCHAR(15) NOT NULL CHECK (Severity IN ('Low','Medium','High','Critical')),
    Description   VARCHAR(100)
);
GO

CREATE TABLE dbo.Alert (
    Alert_ID      INT IDENTITY(1,1) PRIMARY KEY,
    Alert_Type_ID INT NOT NULL,
    Start_Time    DATETIME2 NOT NULL,
    End_Time      DATETIME2 NOT NULL,
    Description   VARCHAR(200),
    CONSTRAINT CK_Alert_Time CHECK (End_Time >= Start_Time),
    CONSTRAINT FK_Alert_AlertType FOREIGN KEY (Alert_Type_ID)
        REFERENCES dbo.Alert_Type(Alert_Type_ID)
);
GO

CREATE TABLE dbo.Role (
    Role_ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL UNIQUE,
    [Permissions] VARCHAR(MAX)
);
GO

CREATE TABLE dbo.[User] (
    [User_ID] INT IDENTITY(1,1) PRIMARY KEY,
    Role_ID INT NOT NULL,
    [Name] VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE CHECK (Email LIKE '%@%.%'),
    CONSTRAINT FK_User_Role FOREIGN KEY (Role_ID)
        REFERENCES dbo.Role(Role_ID)
);
GO

CREATE TABLE dbo.Location (
    Location_ID INT IDENTITY(1,1) PRIMARY KEY,
    City        VARCHAR(50) NOT NULL,
    Country     VARCHAR(50) NOT NULL,
    Latitude    DECIMAL(10,8) NOT NULL CHECK (Latitude BETWEEN -90 AND 90),
    Longitude   DECIMAL(11,8) NOT NULL CHECK (Longitude BETWEEN -180 AND 180),
    Elevation   DECIMAL(6,2)
);
GO

CREATE TABLE dbo.Alert_Location (
    Alert_ID INT NOT NULL,
    Location_ID INT NOT NULL,
    Notification_Sent BIT NOT NULL DEFAULT 0,
    CONSTRAINT PK_Alert_Location PRIMARY KEY (Alert_ID, Location_ID),
    CONSTRAINT FK_AlertLocation_Alert FOREIGN KEY (Alert_ID)
        REFERENCES dbo.Alert(Alert_ID) ON DELETE CASCADE,
    CONSTRAINT FK_AlertLocation_Location FOREIGN KEY (Location_ID)
        REFERENCES dbo.Location(Location_ID) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.Weather_Station (
    Station_ID INT IDENTITY(1,1) PRIMARY KEY,
    Location_ID INT NOT NULL,
    Name       VARCHAR(100) NOT NULL,
    Status     VARCHAR(20) NOT NULL CHECK (Status IN ('ACTIVE','INACTIVE','MAINTENANCE')),
    Installed_Date DATE NULL,
    CONSTRAINT FK_Station_Location FOREIGN KEY (Location_ID)
        REFERENCES dbo.Location(Location_ID) ON DELETE NO ACTION
);
GO

CREATE TABLE dbo.Station_Maintenance (
    Maintenance_ID INT IDENTITY(1,1) PRIMARY KEY,
    Station_ID INT NOT NULL,
    Performed_Date DATE NOT NULL,
    Notes VARCHAR(MAX),
    Technician VARCHAR(50),
    CONSTRAINT FK_Maintenance_Station FOREIGN KEY (Station_ID)
        REFERENCES dbo.Weather_Station(Station_ID) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.Sensor_Type (
    Sensor_Type_ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Unit VARCHAR(15) NOT NULL,
    Min_Range DECIMAL(6,2) NOT NULL,
    Max_Range DECIMAL(6,2) NOT NULL,
    CONSTRAINT CK_SensorType_Range CHECK (Max_Range > Min_Range)
);
GO

CREATE TABLE dbo.Sensor (
    Sensor_ID      INT IDENTITY(1,1) PRIMARY KEY,
    Sensor_Type_ID INT NOT NULL,
    Station_ID     INT NOT NULL,
    Model          VARCHAR(100) NOT NULL,
    Calibrated_Date DATE NULL,
    Status         VARCHAR(20) NOT NULL CHECK (Status IN ('ACTIVE','INACTIVE','FAULTY')),
    CONSTRAINT FK_Sensor_SensorType FOREIGN KEY (Sensor_Type_ID)
        REFERENCES dbo.Sensor_Type(Sensor_Type_ID) ON DELETE NO ACTION,
    CONSTRAINT FK_Sensor_Station FOREIGN KEY (Station_ID)
        REFERENCES dbo.Weather_Station(Station_ID) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.Measurement_Type (
    Measurement_Type_ID INT IDENTITY(1,1) PRIMARY KEY,
    Code VARCHAR(10) NOT NULL UNIQUE,
    Description VARCHAR(100),
    Default_Unit VARCHAR(15) NOT NULL
);
GO

CREATE TABLE dbo.Observation (
    Observation_ID INT IDENTITY(1,1) PRIMARY KEY,
    Station_ID INT NOT NULL,
    Sensor_ID INT NOT NULL,
    Measurement_Type_ID INT NOT NULL,
    Observed_Time DATETIME2 NOT NULL,
    Value DECIMAL(10,4) NOT NULL,
    Quality_Flag_Control CHAR(1) NOT NULL CHECK (Quality_Flag_Control IN ('G','B','U')),
    CONSTRAINT FK_Observation_Station FOREIGN KEY (Station_ID)
        REFERENCES dbo.Weather_Station(Station_ID) ON DELETE NO ACTION,
    CONSTRAINT FK_Observation_Sensor FOREIGN KEY (Sensor_ID)
        REFERENCES dbo.Sensor(Sensor_ID) ON DELETE NO ACTION,
    CONSTRAINT FK_Observation_MeasType FOREIGN KEY (Measurement_Type_ID)
        REFERENCES dbo.Measurement_Type(Measurement_Type_ID) ON DELETE NO ACTION
);
GO

CREATE TABLE dbo.Forecast_Model (
    Model_ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    [Version] VARCHAR(10) NOT NULL,
    Forecast_Duration INT NOT NULL CHECK (Forecast_Duration BETWEEN 1 AND 240)
);
GO

CREATE TABLE dbo.Forecast (
    Forecast_ID INT IDENTITY(1,1) PRIMARY KEY,
    Station_ID INT NOT NULL,
    Model_ID INT NOT NULL,
    Issued_Date DATETIME2 NOT NULL,
    Valid_From DATETIME2 NOT NULL,
    Valid_To DATETIME2 NOT NULL,
    CONSTRAINT CK_Forecast_Validity CHECK (Valid_To > Valid_From),
    CONSTRAINT FK_Forecast_Station FOREIGN KEY (Station_ID)
        REFERENCES dbo.Weather_Station(Station_ID) ON DELETE CASCADE,
    CONSTRAINT FK_Forecast_Model FOREIGN KEY (Model_ID)
        REFERENCES dbo.Forecast_Model(Model_ID)
);
GO

CREATE TABLE dbo.Forecast_Value (
    Forecast_Value_ID INT IDENTITY(1,1) PRIMARY KEY,
    Measurement_Type_ID INT NOT NULL,
    Forecast_ID INT NOT NULL,
    [Time] DATETIME2 NOT NULL,
    [Value] DECIMAL(8,3) NOT NULL,
    CONSTRAINT FK_ForecastValue_MeasType FOREIGN KEY (Measurement_Type_ID)
        REFERENCES dbo.Measurement_Type(Measurement_Type_ID),
    CONSTRAINT FK_ForecastValue_Forecast FOREIGN KEY (Forecast_ID)
        REFERENCES dbo.Forecast(Forecast_ID) ON DELETE CASCADE
);
GO


