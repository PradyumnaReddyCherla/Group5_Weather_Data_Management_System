--------------------------------------------------------------------
-- 1. ALERT TYPES (10)
--------------------------------------------------------------------
INSERT INTO dbo.Alert_Type (Code, Severity, Description)
VALUES
('HEAT_WARN',  'High',      'High temperature warning'),
('COLD_WARN',  'High',      'Low temperature warning'),
('STORM_WARN', 'Critical',  'Severe storm warning'),
('FLOOD_WARN', 'Critical',  'Flooding possible or ongoing'),
('WIND_WARN',  'Medium',    'Strong wind warning'),
('AIR_QUAL',   'Medium',    'Poor air quality'),
('SNOW_WARN',  'High',      'Heavy snowfall expected'),
('FOG_WARN',   'Low',       'Reduced visibility due to fog'),
('UV_WARN',    'Medium',    'High UV index levels'),
('INFO',       'Low',       'General informational alert');

--------------------------------------------------------------------
-- 2. ROLES (10)
--------------------------------------------------------------------
INSERT INTO dbo.Role (Name, [Permissions])
VALUES
('Admin',          'manage_users,manage_stations,manage_alerts,view_all'),
('Meteorologist',  'view_observations,create_forecasts,view_alerts'),
('Technician',     'manage_sensors,log_maintenance,view_stations'),
('DataEngineer',   'manage_etl,manage_views,view_all'),
('Viewer',         'view_observations,view_forecasts,view_alerts'),
('CityOfficial',   'view_alerts,view_city_observations'),
('Researcher',     'view_observations,export_data'),
('AlertManager',   'create_alerts,update_alerts,view_alerts'),
('StationManager', 'manage_stations,manage_sensors,view_observations'),
('QA_Analyst',     'view_observations,view_forecasts,flag_quality');

--------------------------------------------------------------------
-- 3. LOCATIONS (10)
--------------------------------------------------------------------
INSERT INTO dbo.Location (City, Country, Latitude, Longitude, Elevation)
VALUES
('Boston',      'USA',  42.36010,  -71.05890,   5.00),
('New York',    'USA',  40.71280,  -74.00600,  10.00),
('Chicago',     'USA',  41.87810,  -87.62980, 181.00),
('Miami',       'USA',  25.76170,  -80.19180,   2.00),
('Denver',      'USA',  39.73920, -104.99030,1609.00),
('Seattle',     'USA',  47.60620, -122.33210,  52.00),
('Los Angeles', 'USA',  34.05220, -118.24370,  71.00),
('Dallas',      'USA',  32.77670,  -96.79700, 131.00),
('London',      'UK',   51.50740,   -0.12780,  35.00),
('Hyderabad',   'India',17.38500,   78.48670, 505.00);

--------------------------------------------------------------------
-- 4. SENSOR TYPES (10)
--------------------------------------------------------------------
INSERT INTO dbo.Sensor_Type (Name, Unit, Min_Range, Max_Range)
VALUES
('Temperature',    'degC',   -50.00,   60.00),
('Pressure',       'hPa',    870.00, 1080.00),
('Precipitation',  'mm',       0.00,  500.00),
('Wind Speed',     'm/s',      0.00,   75.00),
('Wind Direction', 'degrees',  0.00,  360.00),
('Humidity',       'percent',  0.00,  100.00),
('Visibility',     'km',       0.00,   50.00),
('Cloud Cover',    'percent',  0.00,  100.00),
('PM2.5',          'µg/m3',    0.00,  500.00),
('UV Index',       'index',    0.00,   15.00);

--------------------------------------------------------------------
-- 5. MEASUREMENT TYPES (10)
--------------------------------------------------------------------
INSERT INTO dbo.Measurement_Type (Code, Description, Default_Unit)
VALUES
('TEMP',    'Air temperature at 2m',          'degC'),
('PRES',    'Surface pressure',               'hPa'),
('PRECIP',  'Precipitation depth',           'mm'),
('WINDSPD', 'Wind speed at 10m',             'm/s'),
('WINDDIR', 'Wind direction at 10m',         'degrees'),
('HUMID',   'Relative humidity at 2m',       'percent'),
('VISIB',   'Horizontal visibility',         'km'),
('CLOUD',   'Total cloud cover',             'percent'),
('PM25',    'Fine particulate matter (PM2.5)','µg/m3'),
('UVIDX',   'UV index values',               'index');

--------------------------------------------------------------------
-- 6. FORECAST MODELS (10)
--------------------------------------------------------------------
INSERT INTO dbo.Forecast_Model (Name, [Version], Forecast_Duration)
VALUES
('GFS',            '1.0',  24),
('GFS',            '1.1',  48),
('ECMWF',          '2.0',  24),
('ECMWF',          '2.1',  72),
('HRRR',           '3.0',  18),
('ICON',           '1.0',  48),
('NAM',            '4.0',  36),
('UKMET',          '1.0',  24),
('LocalNowcast',   '0.9',   6),
('EnsembleBlend',  '1.0', 120);


INSERT INTO dbo.[User] (Role_ID, [Name], Email)
VALUES
(1,  'Alice Admin',           'alice.admin@example.com'),
(1,  'Usha Admin',            'usha.admin@example.com'),
(2,  'Brian Meteorologist',   'brian.met@example.com'),
(2,  'Kiran Meteorologist',   'kiran.met@example.com'),
(3,  'Cara Technician',       'cara.tech@example.com'),
(3,  'Lara Technician',       'lara.tech@example.com'),
(4,  'Daniel Engineer',       'daniel.de@example.com'),
(4,  'Priya DataEng',         'priya.de@example.com'),
(5,  'Eva Viewer',            'eva.viewer@example.com'),
(5,  'Tom Viewer',            'tom.viewer@example.com'),
(5,  'Manoj Viewer',          'manoj.viewer@example.com'),
(6,  'Frank Official',        'frank.city@example.com'),
(6,  'Omar Official',         'omar.city@example.com'),
(7,  'Grace Researcher',      'grace.research@example.com'),
(7,  'Nina Researcher',       'nina.research@example.com'),
(8,  'Hari AlertMgr',         'hari.alerts@example.com'),
(9,  'Isha StationMgr',       'isha.station@example.com'),
(9,  'Rahul StationMgr',      'rahul.station@example.com'),
(10, 'Jack QA',               'jack.qa@example.com'),
(10, 'Sara QA',               'sara.qa@example.com');

INSERT INTO dbo.Weather_Station (Location_ID, Name, Status, Installed_Date)
VALUES
-- Boston (1)
(1, 'Boston Central Station',      'ACTIVE',       '2023-10-01'),
(1, 'Boston Harbor Station',       'ACTIVE',       '2023-09-20'),

-- New York (2)
(2, 'New York Central Station',    'ACTIVE',       '2023-09-15'),
(2, 'New York Bronx Station',      'MAINTENANCE',  '2023-08-10'),

-- Chicago (3)
(3, 'Chicago O''Hare Station',     'ACTIVE',       '2023-08-20'),
(3, 'Chicago Downtown Station',    'ACTIVE',       '2023-08-05'),

-- Miami (4)
(4, 'Miami Beach Station',         'ACTIVE',       '2023-07-10'),
(4, 'Miami Airport Station',       'ACTIVE',       '2023-07-01'),

-- Denver (5)
(5, 'Denver Mountain Station',     'ACTIVE',       '2023-06-01'),
(5, 'Denver City Station',         'ACTIVE',       '2023-06-15'),

-- Seattle (6)
(6, 'Seattle Center Station',      'ACTIVE',       '2023-05-15'),
(6, 'Seattle North Station',       'INACTIVE',     '2023-05-01'),

-- Los Angeles (7)
(7, 'LA Downtown Station',         'ACTIVE',       '2023-04-12'),
(7, 'LA West Coast Station',       'ACTIVE',       '2023-04-05'),

-- Dallas (8)
(8, 'Dallas North Station',        'ACTIVE',       '2023-03-20'),
(8, 'Dallas South Station',        'ACTIVE',       '2023-03-10'),

-- London (9)
(9, 'London City Station',         'ACTIVE',       '2023-02-25'),
(9, 'London Heathrow Station',     'ACTIVE',       '2023-02-10'),

-- Hyderabad (10)
(10, 'Hyderabad Central Station',  'ACTIVE',       '2023-01-30'),
(10, 'Hyderabad Gachibowli Station','ACTIVE',      '2023-01-20');



INSERT INTO dbo.Station_Maintenance (Station_ID, Performed_Date, Notes, Technician)
VALUES
-- Station 1
(1, '2024-03-10', 'Routine checkup and calibration', 'Cara Technician'),
(1, '2024-06-15', 'Replaced worn-out wiring', 'Lara Technician'),
(1, '2024-09-20', 'Post-storm inspection', 'Cara Technician'),

-- Station 2
(2, '2024-02-05', 'Routine functionality test', 'Lara Technician'),
(2, '2024-05-12', 'Sensor alignment correction', 'Cara Technician'),
(2, '2024-08-25', 'Firmware update applied', 'Lara Technician'),

-- Station 3
(3, '2024-01-22', 'General maintenance', 'Cara Technician'),
(3, '2024-04-30', 'Wind sensor recalibration', 'Lara Technician'),
(3, '2024-10-01', 'Post-storm performance test', 'Cara Technician'),

-- Station 4
(4, '2024-02-18', 'Humidity sensor cleaned', 'Lara Technician'),
(4, '2024-06-01', 'Battery replacement', 'Cara Technician'),
(4, '2024-09-10', 'Repaired precipitation gauge', 'Lara Technician'),

-- Station 5
(5, '2024-03-03', 'Altitude pressure sensor calibration', 'Cara Technician'),
(5, '2024-06-18', 'Snow buildup removed', 'Lara Technician'),
(5, '2024-09-05', 'Power module replaced', 'Cara Technician'),

-- Station 6
(6, '2024-01-28', 'Routine inspection', 'Cara Technician'),
(6, '2024-05-14', 'Data transmission issue fixed', 'Lara Technician'),
(6, '2024-08-22', 'Replaced faulty wiring', 'Cara Technician'),

-- Station 7
(7, '2024-03-11', 'Salt corrosion cleaning', 'Lara Technician'),
(7, '2024-06-20', 'Calibration patch applied', 'Cara Technician'),
(7, '2024-09-30', 'Wind vane lubrication', 'Lara Technician'),

-- Station 8
(8, '2024-02-10', 'Sensor drift correction', 'Cara Technician'),
(8, '2024-05-22', 'Replaced solar panel', 'Lara Technician'),
(8, '2024-08-28', 'Airport interference test', 'Cara Technician'),

-- Station 9
(9, '2024-01-15', 'Cold-weather recalibration', 'Lara Technician'),
(9, '2024-04-25', 'Firmware update', 'Cara Technician'),
(9, '2024-07-30', 'Wind speed sensor replacement', 'Lara Technician'),

-- Station 10
(10, '2024-02-20', 'Pressure sensor repair', 'Cara Technician'),
(10, '2024-05-18', 'Router reboot & update', 'Lara Technician'),
(10, '2024-09-12', 'Lightning impact check', 'Cara Technician'),

-- Station 11
(11, '2024-03-08', 'Moisture removal from casing', 'Lara Technician'),
(11, '2024-06-11', 'Antenna alignment fix', 'Cara Technician'),
(11, '2024-09-15', 'Cloud cover sensor cleaning', 'Lara Technician'),

-- Station 12
(12, '2024-01-05', 'Routine calibration', 'Cara Technician'),
(12, '2024-04-17', 'Connector replacement', 'Lara Technician'),
(12, '2024-08-29', 'Replaced humidity sensor', 'Cara Technician'),

-- Station 13
(13, '2024-02-16', 'Visibility sensor cleaning', 'Lara Technician'),
(13, '2024-05-09', 'Internal board reboot', 'Cara Technician'),
(13, '2024-09-22', 'Cable wear inspection', 'Lara Technician'),

-- Station 14
(14, '2024-03-21', 'Wind direction sensor fix', 'Cara Technician'),
(14, '2024-07-01', 'Dust buildup cleaning', 'Lara Technician'),
(14, '2024-10-05', 'Updated calibration profile', 'Cara Technician'),

-- Station 15
(15, '2024-01-30', 'Network module reconfigured', 'Cara Technician'),
(15, '2024-04-20', 'Fan replacement', 'Lara Technician'),
(15, '2024-08-10', 'Routine cleaning', 'Cara Technician'),

-- Station 16
(16, '2024-02-25', 'Connectivity issue resolved', 'Lara Technician'),
(16, '2024-06-02', 'Battery replaced', 'Cara Technician'),
(16, '2024-09-18', 'Panel tightening & lubrication', 'Lara Technician'),

-- Station 17
(17, '2024-03-02', 'Fog sensor cleaning', 'Cara Technician'),
(17, '2024-06-14', 'Clock sync correction', 'Lara Technician'),
(17, '2024-10-02', 'Wind mast stability check', 'Cara Technician'),

-- Station 18
(18, '2024-01-19', 'Routine inspection', 'Cara Technician'),
(18, '2024-04-27', 'Pressure gauge cleaning', 'Lara Technician'),
(18, '2024-08-26', 'Heat damage inspection', 'Cara Technician'),

-- Station 19
(19, '2024-03-05', 'Heatwave calibration', 'Lara Technician'),
(19, '2024-06-22', 'Replaced PM2.5 filter', 'Cara Technician'),
(19, '2024-09-27', 'Humidity module fixed', 'Lara Technician'),

-- Station 20
(20, '2024-02-12', 'Fan motor cleaning', 'Cara Technician'),
(20, '2024-05-28', 'UV sensor recalibrated', 'Lara Technician'),
(20, '2024-09-14', 'Solar power issue resolved', 'Cara Technician');


INSERT INTO dbo.Sensor (Sensor_Type_ID, Station_ID, Model, Calibrated_Date, Status)
VALUES
-----------------------------------------
-- STATION 1 : Boston Central (ALL 10)
-----------------------------------------
(1, 1, 'Vaisala WXT536',        '2024-09-15', 'ACTIVE'),
(2, 1, 'Vaisala WXT536',        '2024-09-15', 'ACTIVE'),
(3, 1, 'Vaisala WXT536',        '2024-09-15', 'ACTIVE'),
(4, 1, 'Gill WindObserver',     '2024-09-15', 'ACTIVE'),
(5, 1, 'Gill WindObserver',     '2024-09-15', 'ACTIVE'),
(6, 1, 'Vaisala WXT536',        '2024-09-15', 'ACTIVE'),
(7, 1, 'Biral VPF-730',         '2024-09-15', 'ACTIVE'),
(8, 1, 'Kipp & Zonen CUV5',     '2024-09-15', 'ACTIVE'),
(9, 1, 'TSI DustTrak II',       '2024-09-15', 'ACTIVE'),
(10,1, 'Solar Light UV-Biometer','2024-09-15','ACTIVE'),

-----------------------------------------
-- STATION 2 to 18 & 20 → Mandatory 4 Sensors
-----------------------------------------
-- (Temperature, Pressure, Precipitation, Humidity)
-----------------------------------------

-- Station 2
(1, 2, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 2, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 2, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 2, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 3
(1, 3, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 3, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 3, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 3, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 4
(1, 4, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 4, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 4, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 4, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 5
(1, 5, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 5, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 5, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 5, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 6
(1, 6, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 6, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 6, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 6, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 7
(1, 7, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 7, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 7, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 7, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 8
(1, 8, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 8, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 8, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 8, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 9
(1, 9, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 9, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 9, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 9, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 10
(1, 10, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 10, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 10, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 10, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 11
(1, 11, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 11, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 11, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 11, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 12
(1, 12, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 12, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 12, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 12, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 13
(1, 13, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 13, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 13, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 13, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 14
(1, 14, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 14, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 14, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 14, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 15
(1, 15, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 15, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 15, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 15, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 16
(1, 16, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 16, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 16, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 16, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 17
(1, 17, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 17, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 17, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 17, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-- Station 18
(1, 18, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 18, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 18, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 18, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),

-----------------------------------------
-- STATION 19 : Hyderabad Central (ALL 10)
-----------------------------------------
(1, 19, 'Vaisala WXT536',        '2024-09-15', 'ACTIVE'),
(2, 19, 'Vaisala WXT536',        '2024-09-15', 'ACTIVE'),
(3, 19, 'Vaisala WXT536',        '2024-09-15', 'ACTIVE'),
(4, 19, 'Gill WindObserver',     '2024-09-15', 'ACTIVE'),
(5, 19, 'Gill WindObserver',     '2024-09-15', 'ACTIVE'),
(6, 19, 'Vaisala WXT536',        '2024-09-15', 'ACTIVE'),
(7, 19, 'Biral VPF-730',         '2024-09-15', 'ACTIVE'),
(8, 19, 'Kipp & Zonen CUV5',     '2024-09-15', 'ACTIVE'),
(9, 19, 'TSI DustTrak II',       '2024-09-15', 'ACTIVE'),
(10,19, 'Solar Light UV-Biometer','2024-09-15','ACTIVE'),

-----------------------------------------
-- STATION 20 (Mandatory 4)
-----------------------------------------
(1, 20, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(2, 20, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(3, 20, 'Vaisala WXT536', '2024-08-01', 'ACTIVE'),
(6, 20, 'Vaisala WXT536', '2024-08-01', 'ACTIVE');



INSERT INTO dbo.Observation 
(Station_ID, Sensor_ID, Measurement_Type_ID, Observed_Time, Value, Quality_Flag_Control)
VALUES
(1, 1, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(1, 2, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(1, 3, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(1, 4, 4, '2025-11-19T06:00:00', 4.5, 'G'),
(1, 5, 5, '2025-11-19T06:00:00', 180, 'G'),
(1, 6, 6, '2025-11-19T06:00:00', 60, 'G'),
(1, 7, 7, '2025-11-19T06:00:00', 8, 'G'),
(1, 8, 8, '2025-11-19T06:00:00', 45, 'G'),
(1, 9, 9, '2025-11-19T06:00:00', 22, 'G'),
(1, 10, 10, '2025-11-19T06:00:00', 3, 'G'),

(2, 11, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(2, 12, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(2, 13, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(2, 14, 6, '2025-11-19T06:00:00', 60, 'G'),

(3, 15, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(3, 16, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(3, 17, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(3, 18, 6, '2025-11-19T06:00:00', 60, 'G'),

(4, 19, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(4, 20, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(4, 21, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(4, 22, 6, '2025-11-19T06:00:00', 60, 'G'),

(5, 23, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(5, 24, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(5, 25, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(5, 26, 6, '2025-11-19T06:00:00', 60, 'G'),

(6, 27, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(6, 28, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(6, 29, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(6, 30, 6, '2025-11-19T06:00:00', 60, 'G'),

(7, 31, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(7, 32, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(7, 33, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(7, 34, 6, '2025-11-19T06:00:00', 60, 'G'),

(8, 35, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(8, 36, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(8, 37, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(8, 38, 6, '2025-11-19T06:00:00', 60, 'G'),

(9, 39, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(9, 40, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(9, 41, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(9, 42, 6, '2025-11-19T06:00:00', 60, 'G'),

(10, 43, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(10, 44, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(10, 45, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(10, 46, 6, '2025-11-19T06:00:00', 60, 'G'),

(11, 47, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(11, 48, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(11, 49, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(11, 50, 6, '2025-11-19T06:00:00', 60, 'G'),

(12, 51, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(12, 52, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(12, 53, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(12, 54, 6, '2025-11-19T06:00:00', 60, 'G'),

(13, 55, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(13, 56, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(13, 57, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(13, 58, 6, '2025-11-19T06:00:00', 60, 'G'),

(14, 59, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(14, 60, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(14, 61, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(14, 62, 6, '2025-11-19T06:00:00', 60, 'G'),

(15, 63, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(15, 64, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(15, 65, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(15, 66, 6, '2025-11-19T06:00:00', 60, 'G'),

(16, 67, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(16, 68, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(16, 69, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(16, 70, 6, '2025-11-19T06:00:00', 60, 'G'),

(17, 71, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(17, 72, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(17, 73, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(17, 74, 6, '2025-11-19T06:00:00', 60, 'G'),

(18, 75, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(18, 76, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(18, 77, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(18, 78, 6, '2025-11-19T06:00:00', 60, 'G'),

(19, 79, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(19, 80, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(19, 81, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(19, 82, 4, '2025-11-19T06:00:00', 4.5, 'G'),
(19, 83, 5, '2025-11-19T06:00:00', 180, 'G'),
(19, 84, 6, '2025-11-19T06:00:00', 60, 'G'),
(19, 85, 7, '2025-11-19T06:00:00', 8, 'G'),
(19, 86, 8, '2025-11-19T06:00:00', 45, 'G'),
(19, 87, 9, '2025-11-19T06:00:00', 22, 'G'),
(19, 88, 10, '2025-11-19T06:00:00', 3, 'G'),

(20, 89, 1, '2025-11-19T06:00:00', 10.0, 'G'),
(20, 90, 2, '2025-11-19T06:00:00', 1008.0, 'G'),
(20, 91, 3, '2025-11-19T06:00:00', 1.2, 'G'),
(20, 92, 6, '2025-11-19T06:00:00', 60, 'G');


INSERT INTO dbo.Alert (Alert_Type_ID, Start_Time, End_Time, Description)
VALUES
(3, '2025-11-19T01:00:00', '2025-11-19T06:00:00', 'Heavy rainfall expected in Boston'),
(4, '2025-11-19T14:00:00', '2025-11-19T23:00:00', 'Severe storm surge in Boston Harbor'),
(2, '2025-11-18T09:00:00', '2025-11-18T13:00:00', 'Strong wind conditions in New York'),
(1, '2025-11-17T05:00:00', '2025-11-17T09:00:00', 'Morning fog alert in Chicago'),
(3, '2025-11-20T03:00:00', '2025-11-20T09:00:00', 'Thunderstorm activity expected in Miami'),
(2, '2025-11-20T05:00:00', '2025-11-20T11:00:00', 'Snow shower advisory in Denver'),
(3, '2025-11-21T12:00:00', '2025-11-21T17:00:00', 'Heavy rain expected in Seattle'),
(2, '2025-11-21T15:00:00', '2025-11-21T20:00:00', 'Moderate wind gusts in Los Angeles'),
(1, '2025-11-20T07:00:00', '2025-11-20T11:00:00', 'Morning haze advisory in Dallas'),
(3, '2025-11-20T04:00:00', '2025-11-20T12:00:00', 'Rain and poor visibility in London'),

(4, '2025-11-19T20:00:00', '2025-11-20T04:00:00', 'Cyclone warning issued for Hyderabad'),
(3, '2025-11-19T18:00:00', '2025-11-19T22:00:00', 'Intense rainfall approaching Hyderabad'),
(2, '2025-11-18T18:00:00', '2025-11-18T23:00:00', 'Strong winds approaching Boston'),
(1, '2025-11-18T08:00:00', '2025-11-18T11:00:00', 'Light drizzle expected in Boston'),
(3, '2025-11-20T09:00:00', '2025-11-20T15:00:00', 'Heavy rainfall expected in Chicago'),

(2, '2025-11-21T13:00:00', '2025-11-21T19:00:00', 'High wind alert in Miami'),
(1, '2025-11-22T06:00:00', '2025-11-22T09:00:00', 'Fog alert in Denver'),
(3, '2025-11-22T05:00:00', '2025-11-22T13:00:00', 'Heavy rainfall expected in Seattle'),
(2, '2025-11-22T11:00:00', '2025-11-22T17:00:00', 'Wind alert in Los Angeles'),

(3, '2025-11-23T04:00:00', '2025-11-23T10:00:00', 'Heavy rain in Dallas'),
(1, '2025-11-23T09:00:00', '2025-11-23T11:00:00', 'Light fog in London'),
(4, '2025-11-23T16:00:00', '2025-11-23T23:00:00', 'Extreme weather alert in Hyderabad'),
(3, '2025-11-24T03:00:00', '2025-11-24T07:00:00', 'Severe rainfall expected in Boston'),
(2, '2025-11-24T12:00:00', '2025-11-24T18:00:00', 'Moderate winds expected in New York');


INSERT INTO dbo.Alert_Location (Alert_ID, Location_ID, Notification_Sent)
VALUES
(1, 1, 0),
(2, 1, 0),
(13, 1, 0),
(14, 1, 0),
(24, 1, 0),

(3, 2, 0),

(4, 3, 0),
(15, 3, 0),

(5, 4, 0),
(16, 4, 0),

(6, 5, 0),
(17, 5, 0),

(7, 6, 0),
(18, 6, 0),

(8, 7, 0),
(19, 7, 0),

(9, 8, 0),
(20, 8, 0),

(10, 9, 0),
(21, 9, 0),

(11, 10, 0),
(12, 10, 0),
(23, 10, 0);





INSERT INTO dbo.Forecast (Station_ID, Model_ID, Issued_Date, Valid_From, Valid_To)
VALUES
(1, 1, '2025-11-19T05:00:00','2025-11-19T06:00:00','2025-11-19T18:00:00'),
(2, 2, '2025-11-19T05:30:00','2025-11-19T06:30:00','2025-11-19T18:30:00'),
(3, 3, '2025-11-19T04:00:00','2025-11-19T05:00:00','2025-11-19T17:00:00'),
(4, 4, '2025-11-19T07:00:00','2025-11-19T08:00:00','2025-11-19T20:00:00'),
(5, 5, '2025-11-19T03:00:00','2025-11-19T04:00:00','2025-11-19T16:00:00'),
(6, 6, '2025-11-19T09:00:00','2025-11-19T10:00:00','2025-11-19T22:00:00'),
(7, 7, '2025-11-19T02:00:00','2025-11-19T03:00:00','2025-11-19T15:00:00'),
(8, 8, '2025-11-19T06:00:00','2025-11-19T07:00:00','2025-11-19T19:00:00'),
(9, 9, '2025-11-19T01:00:00','2025-11-19T02:00:00','2025-11-19T14:00:00'),
(10,10,'2025-11-19T00:30:00','2025-11-19T01:30:00','2025-11-19T13:30:00'),

(11,1,'2025-11-20T05:00:00','2025-11-20T06:00:00','2025-11-20T18:00:00'),
(12,2,'2025-11-20T06:00:00','2025-11-20T07:00:00','2025-11-20T19:00:00'),
(13,3,'2025-11-20T03:00:00','2025-11-20T04:00:00','2025-11-20T16:00:00'),
(14,4,'2025-11-20T02:00:00','2025-11-20T03:00:00','2025-11-20T15:00:00'),
(15,5,'2025-11-20T07:00:00','2025-11-20T08:00:00','2025-11-20T20:00:00'),
(16,6,'2025-11-20T09:00:00','2025-11-20T10:00:00','2025-11-20T22:00:00'),
(17,7,'2025-11-20T01:00:00','2025-11-20T02:00:00','2025-11-20T14:00:00'),
(18,8,'2025-11-20T04:00:00','2025-11-20T05:00:00','2025-11-20T17:00:00'),
(19,9,'2025-11-20T02:30:00','2025-11-20T03:30:00','2025-11-20T15:30:00'),
(20,10,'2025-11-20T00:00:00','2025-11-20T01:00:00','2025-11-20T13:00:00');


INSERT INTO dbo.Forecast_Value (Measurement_Type_ID, Forecast_ID, [Time], [Value])
VALUES
-- Forecast 1 (Station 1)
(1,1,'2025-11-19T06:00:00', 10.5),
(2,1,'2025-11-19T06:00:00', 1007.8),
(3,1,'2025-11-19T06:00:00', 0.4),
(4,1,'2025-11-19T06:00:00', 4.9),
(6,1,'2025-11-19T06:00:00', 61),

(1,1,'2025-11-19T12:00:00', 11.3),
(2,1,'2025-11-19T12:00:00', 1007.2),
(3,1,'2025-11-19T12:00:00', 1.1),
(4,1,'2025-11-19T12:00:00', 5.5),
(6,1,'2025-11-19T12:00:00', 63),

(1,1,'2025-11-19T18:00:00', 9.7),
(2,1,'2025-11-19T18:00:00', 1006.8),
(3,1,'2025-11-19T18:00:00', 1.9),
(4,1,'2025-11-19T18:00:00', 6.1),
(6,1,'2025-11-19T18:00:00', 68),

-- Forecast 2 (Station 2)
(1,2,'2025-11-19T06:30:00', 9.8),
(2,2,'2025-11-19T06:30:00', 1008.9),
(3,2,'2025-11-19T06:30:00', 0.3),
(4,2,'2025-11-19T06:30:00', 4.3),
(6,2,'2025-11-19T06:30:00', 57),

(1,2,'2025-11-19T12:30:00', 10.4),
(2,2,'2025-11-19T12:30:00', 1008.1),
(3,2,'2025-11-19T12:30:00', 0.9),
(4,2,'2025-11-19T12:30:00', 4.9),
(6,2,'2025-11-19T12:30:00', 59),

(1,2,'2025-11-19T18:30:00', 9.1),
(2,2,'2025-11-19T18:30:00', 1007.5),
(3,2,'2025-11-19T18:30:00', 1.2),
(4,2,'2025-11-19T18:30:00', 5.6),
(6,2,'2025-11-19T18:30:00', 66),

-- Forecast 3 (Station 3)
(1,3,'2025-11-19T05:00:00', 8.7),
(2,3,'2025-11-19T05:00:00', 1008.2),
(3,3,'2025-11-19T05:00:00', 0.5),
(4,3,'2025-11-19T05:00:00', 3.8),
(6,3,'2025-11-19T05:00:00', 55),

(1,3,'2025-11-19T11:00:00', 9.5),
(2,3,'2025-11-19T11:00:00', 1007.6),
(3,3,'2025-11-19T11:00:00', 1.0),
(4,3,'2025-11-19T11:00:00', 4.4),
(6,3,'2025-11-19T11:00:00', 58);
