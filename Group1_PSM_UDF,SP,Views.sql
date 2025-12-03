USE WeatherForecastDB;
GO

CREATE OR ALTER PROCEDURE dbo.usp_InsertObservationWithQC
    @Station_ID          INT,
    @Sensor_ID           INT,
    @Measurement_Type_ID INT,
    @Observed_Time       DATETIME2,
    @Value               DECIMAL(10,4),
    @Message             VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        -- Check if sensor belongs to this station
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Sensor
            WHERE Sensor_ID = @Sensor_ID
              AND Station_ID = @Station_ID
        )
        BEGIN
            SET @Message = 'Error: Sensor does not belong to this station';
            ROLLBACK TRAN;
            RETURN;
        END;

        -- Calculate QC flag (G/B)
        DECLARE @QC CHAR(1);

        SELECT @QC =
            CASE WHEN @Value BETWEEN st.Min_Range AND st.Max_Range THEN 'G'
                 ELSE 'B'
            END
        FROM dbo.Sensor s
        JOIN dbo.Sensor_Type st ON st.Sensor_Type_ID = s.Sensor_Type_ID
        WHERE s.Sensor_ID = @Sensor_ID;

        -- Insert observation
        INSERT INTO dbo.Observation
            (Station_ID, Sensor_ID, Measurement_Type_ID, Observed_Time, Value, Quality_Flag_Control)
        VALUES
            (@Station_ID, @Sensor_ID, @Measurement_Type_ID, @Observed_Time, @Value, @QC);

        COMMIT TRAN;

        SET @Message = 'Inserted successfully. QC = ' + @QC;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        SET @Message = 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


CREATE OR ALTER PROCEDURE dbo.usp_UpsertForecastWithValues
    @Station_ID INT,
    @Model_ID INT,
    @Issued_Date DATETIME2,
    @Valid_From DATETIME2,
    @Valid_To DATETIME2,
    @Measurement_Type_ID INT,
    @Value_Time DATETIME2,
    @Value DECIMAL(8,3),
    @Message VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Forecast_ID INT;

    BEGIN TRY
        BEGIN TRAN;

        -- Find existing forecast
        SELECT @Forecast_ID = Forecast_ID
        FROM dbo.Forecast
        WHERE Station_ID = @Station_ID
          AND Model_ID = @Model_ID
          AND Issued_Date = @Issued_Date;

        IF @Forecast_ID IS NULL
        BEGIN
            INSERT INTO dbo.Forecast (Station_ID, Model_ID, Issued_Date, Valid_From, Valid_To)
            VALUES (@Station_ID, @Model_ID, @Issued_Date, @Valid_From, @Valid_To);

            SET @Forecast_ID = SCOPE_IDENTITY();
            SET @Message = 'New forecast created. ';
        END
        ELSE
        BEGIN
            UPDATE dbo.Forecast
            SET Valid_From = @Valid_From,
                Valid_To = @Valid_To
            WHERE Forecast_ID = @Forecast_ID;

            SET @Message = 'Forecast updated. ';
        END;

        -- Remove old forecast value if exists
        DELETE FROM dbo.Forecast_Value
        WHERE Forecast_ID = @Forecast_ID
          AND Measurement_Type_ID = @Measurement_Type_ID
          AND [Time] = @Value_Time;

        -- Insert new forecast value
        INSERT INTO dbo.Forecast_Value (Measurement_Type_ID, Forecast_ID, [Time], [Value])
        VALUES (@Measurement_Type_ID, @Forecast_ID, @Value_Time, @Value);

        COMMIT TRAN;

        SET @Message = @Message + 'Forecast value inserted.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        SET @Message = 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_CreateAlertForLocations
    @Alert_Type_ID INT,
    @Start_Time DATETIME2,
    @End_Time DATETIME2,
    @Description VARCHAR(200),
    @Location_ID INT,
    @Message VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Alert_ID INT;

    BEGIN TRY
        BEGIN TRAN;

        IF (@End_Time < @Start_Time)
        BEGIN
            SET @Message = 'Error: End_Time cannot be before Start_Time.';
            ROLLBACK TRAN;
            RETURN;
        END;

        INSERT INTO dbo.Alert (Alert_Type_ID, Start_Time, End_Time, Description)
        VALUES (@Alert_Type_ID, @Start_Time, @End_Time, @Description);

        SET @Alert_ID = SCOPE_IDENTITY();

        INSERT INTO dbo.Alert_Location (Alert_ID, Location_ID, Notification_Sent)
        VALUES (@Alert_ID, @Location_ID, 0);

        COMMIT TRAN;

        SET @Message = 'Alert created successfully. Alert_ID = ' + CAST(@Alert_ID AS VARCHAR(10));
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        SET @Message = 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

USE WeatherForecastDB;
GO

CREATE OR ALTER FUNCTION dbo.fn_GetStationHealthScore
(
    @Station_ID INT
)
RETURNS INT
AS
BEGIN
    DECLARE 
        @faulty INT = 0,
        @inactive INT = 0,
        @sensorScore INT = 0,
        @maintenanceScore INT = 0,
        @statusScore INT = 0,
        @lastMaintenanceDate DATE,
        @daysSinceMaintenance INT,
        @finalScore INT = 0,
        @stationStatus VARCHAR(20);

    -----------------------------------------------------------------------
    -- 1️⃣ SENSOR CONDITION SCORE  (0–40 points)
    -----------------------------------------------------------------------
    SELECT 
        @faulty = COUNT(*) 
    FROM dbo.Sensor
    WHERE Station_ID = @Station_ID AND Status = 'FAULTY';

    SELECT 
        @inactive = COUNT(*)
    FROM dbo.Sensor
    WHERE Station_ID = @Station_ID AND Status = 'INACTIVE';

    -- Base value 40, minus penalties
    SET @sensorScore = 40 - (@faulty * 10) - (@inactive * 5);

    -- Clamp score between 0 and 40
    IF @sensorScore < 0 SET @sensorScore = 0;
    IF @sensorScore > 40 SET @sensorScore = 40;


    -----------------------------------------------------------------------
    -- 2️⃣ MAINTENANCE FRESHNESS SCORE (0–30 points)
    -----------------------------------------------------------------------
    SELECT 
        @lastMaintenanceDate = MAX(Performed_Date)
    FROM dbo.Station_Maintenance
    WHERE Station_ID = @Station_ID;

    IF @lastMaintenanceDate IS NOT NULL
    BEGIN
        SET @daysSinceMaintenance = DATEDIFF(DAY, @lastMaintenanceDate, SYSDATETIME());

        IF @daysSinceMaintenance <= 30  
            SET @maintenanceScore = 30;
        ELSE IF @daysSinceMaintenance <= 60 
            SET @maintenanceScore = 20;
        ELSE IF @daysSinceMaintenance <= 120
            SET @maintenanceScore = 10;
        ELSE 
            SET @maintenanceScore = 0;
    END
    ELSE
    BEGIN
        SET @maintenanceScore = 0;
    END


    -----------------------------------------------------------------------
    -- 3️⃣ STATION STATUS SCORE (0–30 points)
    -----------------------------------------------------------------------
    SELECT @stationStatus = Status
    FROM dbo.Weather_Station
    WHERE Station_ID = @Station_ID;

    IF (@stationStatus = 'ACTIVE')
        SET @statusScore = 30;
    ELSE IF (@stationStatus = 'MAINTENANCE')
        SET @statusScore = 15;
    ELSE 
        SET @statusScore = 0;


    -----------------------------------------------------------------------
    -- FINAL SCORE = sensor + maintenance + status (max 100)
    -----------------------------------------------------------------------
    SET @finalScore = @sensorScore + @maintenanceScore + @statusScore;

    IF @finalScore > 100 SET @finalScore = 100;
    IF @finalScore < 0 SET @finalScore = 0;

    RETURN @finalScore;
END;
GO

USE WeatherForecastDB;
GO

CREATE OR ALTER FUNCTION dbo.fn_GetFeelsLikeTemp
(
    @Station_ID INT
)
RETURNS DECIMAL(10,4)
AS
BEGIN
    DECLARE
        @TempC DECIMAL(10,4),
        @Hum DECIMAL(10,4),
        @T_F DECIMAL(10,4),
        @HI_F DECIMAL(10,4),
        @FeelsLikeC DECIMAL(10,4);

    -------------------------------------------------------------------------
    -- 1️⃣ Fetch latest Temperature (Celsius)
    -------------------------------------------------------------------------
    SELECT TOP 1 @TempC = Value
    FROM dbo.Observation
    WHERE Station_ID = @Station_ID
      AND Measurement_Type_ID = 1   -- TEMP
    ORDER BY Observed_Time DESC;

    -------------------------------------------------------------------------
    -- 2️⃣ Fetch latest Humidity (%)
    -------------------------------------------------------------------------
    SELECT TOP 1 @Hum = Value
    FROM dbo.Observation
    WHERE Station_ID = @Station_ID
      AND Measurement_Type_ID = 2   -- HUMIDITY
    ORDER BY Observed_Time DESC;

    -------------------------------------------------------------------------
    -- 3️⃣ If either is missing → return NULL
    -------------------------------------------------------------------------
    IF @TempC IS NULL OR @Hum IS NULL
        RETURN NULL;

    -------------------------------------------------------------------------
    -- 4️⃣ Convert Celsius → Fahrenheit
    -------------------------------------------------------------------------
    SET @T_F = (@TempC * 9.0 / 5.0) + 32;

    -------------------------------------------------------------------------
    -- 5️⃣ NOAA Heat Index Equation
    -------------------------------------------------------------------------
    SET @HI_F =
          -42.379
        + (2.04901523 * @T_F)
        + (10.14333127 * @Hum)
        - (0.22475541 * @T_F * @Hum)
        - (0.00683783 * @T_F * @T_F)
        - (0.05481717 * @Hum * @Hum)
        + (0.00122874 * @T_F * @T_F * @Hum)
        + (0.00085282 * @T_F * @Hum * @Hum)
        - (0.00000199 * @T_F * @T_F * @Hum * @Hum);

    -------------------------------------------------------------------------
    -- 6️⃣ Convert Fahrenheit → Celsius
    -------------------------------------------------------------------------
    SET @FeelsLikeC = (@HI_F - 32) * 5.0 / 9.0;

    RETURN @FeelsLikeC;
END;
GO

USE WeatherForecastDB;
GO

CREATE OR ALTER FUNCTION dbo.fn_GetLatestObservationByStation
(
    @Station_ID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        mt.Measurement_Type_ID,
        mt.Code AS MeasurementCode,
        mt.Description AS MeasurementName,
        o.Sensor_ID,
        o.Observed_Time,
        o.Value,
        o.Quality_Flag_Control
    FROM (
            -- Get the latest observation per measurement type for this station
            SELECT 
                Measurement_Type_ID,
                MAX(Observed_Time) AS LatestTime
            FROM dbo.Observation
            WHERE Station_ID = @Station_ID
            GROUP BY Measurement_Type_ID
        ) latest
    JOIN dbo.Observation o
        ON o.Station_ID = @Station_ID
       AND o.Measurement_Type_ID = latest.Measurement_Type_ID
       AND o.Observed_Time = latest.LatestTime
    JOIN dbo.Measurement_Type mt
        ON mt.Measurement_Type_ID = o.Measurement_Type_ID
);
GO

USE WeatherForecastDB;
GO

CREATE OR ALTER VIEW dbo.v_CurrentWeatherSnapshot
AS
SELECT 
    ws.Station_ID,
    ws.Name AS StationName,
    ws.Status AS StationStatus,
    lo.MeasurementCode,
    lo.MeasurementName,
    lo.Value,
    lo.Observed_Time,
    lo.Quality_Flag_Control AS QC,
    dbo.fn_GetFeelsLikeTemp(ws.Station_ID) AS FeelsLikeTemperatureC
FROM dbo.Weather_Station ws
CROSS APPLY dbo.fn_GetLatestObservationByStation(ws.Station_ID) lo;
GO

USE WeatherForecastDB;
GO

CREATE OR ALTER VIEW dbo.v_StationHealthOverview
AS
SELECT 
    ws.Station_ID,
    ws.Name AS StationName,
    ws.Status AS StationStatus,
    (SELECT COUNT(*) FROM dbo.Sensor WHERE Station_ID = ws.Station_ID) AS TotalSensors,
    (SELECT COUNT(*) FROM dbo.Sensor WHERE Station_ID = ws.Station_ID AND Status = 'FAULTY') AS FaultySensors,
    (SELECT COUNT(*) FROM dbo.Sensor WHERE Station_ID = ws.Station_ID AND Status = 'INACTIVE') AS InactiveSensors,
    (SELECT MAX(Performed_Date) FROM dbo.Station_Maintenance WHERE Station_ID = ws.Station_ID) AS LastMaintenanceDate,
    dbo.fn_GetStationHealthScore(ws.Station_ID) AS HealthScore
FROM dbo.Weather_Station ws;
GO

USE WeatherForecastDB;
GO

CREATE OR ALTER VIEW dbo.v_ForecastVsActualComparison
AS
SELECT 
    f.Forecast_ID,
    f.Station_ID,
    ws.Name AS StationName,
    fm.Name AS ForecastModel,
    fv.Measurement_Type_ID,
    mt.Code AS MeasurementCode,
    fv.Time AS ForecastTime,
    fv.Value AS ForecastValue,
    
    -- Get actual observation matching forecast time
    o.Observed_Time AS ActualTime,
    o.Value AS ActualValue,

    -- Calculate forecast error
    (fv.Value - o.Value) AS ErrorValue
FROM dbo.Forecast f
JOIN dbo.Weather_Station ws 
    ON ws.Station_ID = f.Station_ID
JOIN dbo.Forecast_Model fm 
    ON fm.Model_ID = f.Model_ID
JOIN dbo.Forecast_Value fv 
    ON fv.Forecast_ID = f.Forecast_ID
JOIN dbo.Measurement_Type mt
    ON mt.Measurement_Type_ID = fv.Measurement_Type_ID
LEFT JOIN dbo.Observation o
    ON o.Station_ID = f.Station_ID
   AND o.Measurement_Type_ID = fv.Measurement_Type_ID
   AND o.Observed_Time = fv.Time;  
GO


CREATE TABLE dbo.Sensor_Failure_Log
(
    Log_ID INT IDENTITY PRIMARY KEY,
    Sensor_ID INT,
    Station_ID INT,
    Old_Status VARCHAR(20),
    New_Status VARCHAR(20),
    Logged_Time DATETIME2 DEFAULT SYSDATETIME()
);



