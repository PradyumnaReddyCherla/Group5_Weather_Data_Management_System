--------------------------------------------------------
-- INDEX 1: Observation table (MOST IMPORTANT)
-- Speeds up latest value lookups, UDF 3, View 1, View 3
--------------------------------------------------------
CREATE NONCLUSTERED INDEX IX_Observation_Station_MType_Time
ON Observation (Station_ID, Measurement_Type_ID, Observed_Time DESC);
GO

--------------------------------------------------------
-- INDEX 2: Forecast_Value table
-- Speeds up Forecast vs Actual comparison, View 3, SP2
--------------------------------------------------------
CREATE NONCLUSTERED INDEX IX_ForecastValue_Forecast_MType_Time
ON Forecast_Value (Forecast_ID, Measurement_Type_ID, Time);
GO

--------------------------------------------------------
-- INDEX 3: Sensor table
-- Speeds up Health Score UDF, View 2, Trigger #2
--------------------------------------------------------
CREATE NONCLUSTERED INDEX IX_Sensor_Station_Status
ON Sensor (Station_ID, Status);
GO
