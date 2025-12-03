CREATE OR ALTER TRIGGER trg_Sensor_Failure_AutoMaintenance
ON dbo.Sensor
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Station_Maintenance
    (
        Station_ID,
        Performed_Date,
        Notes,
        Technician
    )
    SELECT 
        i.Station_ID,
        CAST(SYSDATETIME() AS DATE),
        CONCAT('Auto-generated maintenance: Sensor ID ', i.Sensor_ID, ' changed to FAULTY'),
        'System Auto-Generated'
    FROM inserted i
    JOIN deleted d 
        ON i.Sensor_ID = d.Sensor_ID
    WHERE d.Status <> 'FAULTY'       -- sensor was not faulty before
      AND i.Status = 'FAULTY';       -- sensor is now faulty
END;
GO


