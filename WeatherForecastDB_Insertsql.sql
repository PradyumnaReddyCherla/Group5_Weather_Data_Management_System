USE WeatherForecastDB;
GO

INSERT INTO dbo.Alert_Type (Code, Severity, Description) VALUES
('AT01','Low','Local minor advisory'),
('AT02','Medium','Regional advisory'),
('AT03','High','Severe conditions expected'),
('AT04','Critical','Immediate evacuation recommended'),
('AT05','Low','Test type 5'),
('AT06','Medium','Test type 6'),
('AT07','High','Test type 7'),
('AT08','Critical','Test type 8'),
('AT09','Low','Test type 9'),
('AT10','Medium','Test type 10');
GO

INSERT INTO dbo.Location (City, Country, Latitude, Longitude, Elevation) VALUES
('Boston','USA',42.360100,-71.058900,10),
('Seattle','USA',47.606200,-122.332100,53),
('Miami','USA',25.761700,-80.191800,2),
('Denver','USA',39.739200,-104.990300,1609),
('Phoenix','USA',33.448400,-112.074000,331),
('Chicago','USA',41.878100,-87.629800,181),
('Austin','USA',30.267200,-97.743100,149),
('San Jose','USA',37.338200,-121.886300,26),
('New York','USA',40.712800,-74.006000,10),
('Portland','USA',45.515200,-122.678400,15);
GO

INSERT INTO dbo.Role (Name, Permissions) VALUES
('Admin','ALL'),
('Operator','READ,UPDATE'),
('Analyst','READ,ANALYZE'),
('Observer','READ'),
('Technician','MAINTAIN'),
('Manager','OVERVIEW'),
('Auditor','AUDIT'),
('Engineer','DEPLOY'),
('Planner','SCHEDULE'),
('Support','SUPPORT');
GO

INSERT INTO dbo.[User] (Role_ID, Name, Email) VALUES
(1,'Alice Admin','alice.admin@example.com'),
(2,'Bob Operator','bob.operator@example.com'),
(3,'Carol Analyst','carol.analyst@example.com'),
(4,'Dan Observer','dan.observer@example.com'),
(5,'Eve Tech','eve.tech@example.com'),
(6,'Frank Manager','frank.manager@example.com'),
(7,'Grace Auditor','grace.auditor@example.com'),
(8,'Hank Engineer','hank.engineer@example.com'),
(9,'Ivy Planner','ivy.planner@example.com'),
(10,'Joe Support','joe.support@example.com');
GO

INSERT INTO dbo.Weather_Station (Location_ID, Name, Status, Installed_Date) VALUES
(1,'WS-BOS-001','ACTIVE','2020-01-10'),
(2,'WS-SEA-001','ACTIVE','2020-02-15'),
(3,'WS-MIA-001','INACTIVE','2020-03-20'),
(4,'WS-DEN-001','MAINTENANCE','2020-04-25'),
(5,'WS-PHX-001','ACTIVE','2020-05-30'),
(6,'WS-CHI-001','ACTIVE','2020-06-30'),
(7,'WS-AUS-001','ACTIVE','2020-07-20'),
(8,'WS-SJC-001','ACTIVE','2020-08-15'),
(9,'WS-NYC-001','MAINTENANCE','2020-09-05'),
(10,'WS-PDX-001','ACTIVE','2020-10-01');
GO

INSERT INTO dbo.Station_Maintenance (Station_ID, Performed_Date, Notes, Technician) VALUES
(1,'2024-01-10','Routine inspection','Tech-A'),
(2,'2024-02-12','Replaced anemometer','Tech-B'),
(3,'2024-03-14','Calibrated sensors','Tech-C'),
(4,'2024-04-16','Battery replacement','Tech-D'),
(5,'2024-05-18','Firmware upgrade','Tech-E'),
(6,'2024-06-20','Weatherproofing check','Tech-F'),
(7,'2024-07-22','Sensor cleaning','Tech-G'),
(8,'2024-08-24','Diagnostics run','Tech-H'),
(9,'2024-09-26','Full diagnostic','Tech-I'),
(10,'2024-10-28','Routine check','Tech-J');
GO

INSERT INTO dbo.Sensor_Type (Name, Unit, Min_Range, Max_Range) VALUES
('Temperature','C',-50.00,60.00),
('Humidity','%',0.00,100.00),
('Pressure','hPa',300.00,1100.00),
('WindSpeed','m/s',0.00,80.00),
('WindDirection','deg',0.00,360.00),
('Rain','mm',0.00,1000.00),
('Solar','W/m2',0.00,2000.00),
('UV','index',0.00,20.00),
('PM2_5','ug/m3',0.00,1000.00),
('PM10','ug/m3',0.00,1000.00);
GO


INSERT INTO dbo.Sensor (Sensor_Type_ID, Station_ID, Model, Calibrated_Date, Status) VALUES
(1,1,'T1000','2024-06-01','ACTIVE'),
(2,2,'H2000','2024-06-08','ACTIVE'),
(3,3,'P3000','2024-06-15','FAULTY'),
(4,4,'WS4000','2024-06-22','ACTIVE'),
(5,5,'WD5000','2024-06-29','INACTIVE'),
(6,6,'RN6000','2024-07-06','ACTIVE'),
(7,7,'SL7000','2024-07-13','ACTIVE'),
(8,8,'UV8000','2024-07-20','ACTIVE'),
(9,9,'PM25000','2024-07-27','ACTIVE'),
(10,10,'PM10000','2024-08-03','ACTIVE');
GO

INSERT INTO dbo.Measurement_Type (Code, Description, Default_Unit) VALUES
('TEMP','Air Temperature','C'),
('HUM','Relative Humidity','%'),
('PRES','Atmospheric Pressure','hPa'),
('WSPD','Wind Speed','m/s'),
('WDIR','Wind Direction','deg'),
('RAIN','Rainfall','mm'),
('SOL','Solar Radiation','W/m2'),
('UVX','UV Index','index'),
('PM25','Particulate Matter 2.5','ug/m3'),
('PM10','Particulate Matter 10','ug/m3');
GO


INSERT INTO dbo.Observation (Station_ID, Sensor_ID, Measurement_Type_ID, Observed_Time, Value, Quality_Flag_Control) VALUES
(1,1,1,'2025-01-01 06:00:00',15.2750,'G'),
(2,2,2,'2025-01-01 07:00:00',63.5000,'G'),
(3,3,3,'2025-01-01 08:00:00',1013.1200,'U'),
(4,4,4,'2025-01-01 09:00:00',7.4000,'B'),
(5,5,5,'2025-01-01 10:00:00',195.0000,'G'),
(6,6,6,'2025-01-01 11:00:00',0.5000,'U'),
(7,7,7,'2025-01-01 12:00:00',930.0000,'G'),
(8,8,8,'2025-01-01 13:00:00',6.0000,'B'),
(9,9,9,'2025-01-01 14:00:00',12.3450,'G'),
(10,10,10,'2025-01-01 15:00:00',20.0000,'U');
GO


INSERT INTO dbo.Forecast_Model (Name, Version, Forecast_Duration) VALUES
('WRF','v1.0',24),
('GFS','v1.1',48),
('ECMWF','v2.0',72),
('NAM','v1.2',24),
('HRRR','v1.0',18),
('ICON','v1.0',36),
('UKMET','v1.0',48),
('CMC','v1.0',24),
('ARW','v1.0',120),
('MPAS','v1.0',240);
GO

INSERT INTO dbo.Forecast (Station_ID, Model_ID, Issued_Date, Valid_From, Valid_To) VALUES
(1,1,'2025-02-01 00:00:00','2025-02-01 01:00:00','2025-02-02 01:00:00'),
(2,2,'2025-02-01 02:00:00','2025-02-01 03:00:00','2025-02-02 03:00:00'),
(3,3,'2025-02-01 04:00:00','2025-02-01 05:00:00','2025-02-02 05:00:00'),
(4,4,'2025-02-01 06:00:00','2025-02-01 07:00:00','2025-02-02 07:00:00'),
(5,5,'2025-02-01 08:00:00','2025-02-01 09:00:00','2025-02-02 09:00:00'),
(6,6,'2025-02-01 10:00:00','2025-02-01 11:00:00','2025-02-02 11:00:00'),
(7,7,'2025-02-01 12:00:00','2025-02-01 13:00:00','2025-02-02 13:00:00'),
(8,8,'2025-02-01 14:00:00','2025-02-01 15:00:00','2025-02-02 15:00:00'),
(9,9,'2025-02-01 16:00:00','2025-02-01 17:00:00','2025-02-02 17:00:00'),
(10,10,'2025-02-01 18:00:00','2025-02-01 19:00:00','2025-02-02 19:00:00');
GO

INSERT INTO dbo.Forecast_Value (Measurement_Type_ID, Forecast_ID, Time, Value) VALUES
(1,1,'2025-02-01 01:00:00',14.8000),
(2,2,'2025-02-01 03:00:00',61.0000),
(3,3,'2025-02-01 05:00:00',1012.5000),
(4,4,'2025-02-01 07:00:00',6.2000),
(5,5,'2025-02-01 09:00:00',180.0000),
(6,6,'2025-02-01 11:00:00',0.8000),
(7,7,'2025-02-01 13:00:00',920.0000),
(8,8,'2025-02-01 15:00:00',7.5000),
(9,9,'2025-02-01 17:00:00',11.2500),
(10,10,'2025-02-01 19:00:00',19.9000);
GO


INSERT INTO dbo.Alert (Alert_Type_ID, Start_Time, End_Time, Description) VALUES
(1,'2025-03-01 00:00:00','2025-03-01 06:00:00','Minor advisory for region A'),
(2,'2025-03-02 00:00:00','2025-03-02 12:00:00','Moderate advisory for region B'),
(3,'2025-03-03 00:00:00','2025-03-03 18:00:00','Severe alert for region C'),
(4,'2025-03-04 00:00:00','2025-03-04 23:59:59','Critical event D'),
(5,'2025-03-05 00:00:00','2025-03-05 06:00:00','Info E'),
(6,'2025-03-06 00:00:00','2025-03-06 06:00:00','Info F'),
(7,'2025-03-07 00:00:00','2025-03-07 06:00:00','Info G'),
(8,'2025-03-08 00:00:00','2025-03-08 06:00:00','Info H'),
(9,'2025-03-09 00:00:00','2025-03-09 06:00:00','Info I'),
(10,'2025-03-10 00:00:00','2025-03-10 06:00:00','Info J');
GO


INSERT INTO dbo.Alert_Location (Alert_ID, Location_ID, Notification_Sent) VALUES
(1,1,0),
(2,2,1),
(3,3,0),
(4,4,1),
(5,5,0),
(6,6,1),
(7,7,0),
(8,8,1),
(9,9,0),
(10,10,1);
GO
