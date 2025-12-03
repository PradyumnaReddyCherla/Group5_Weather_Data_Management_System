--------------------------------------------
-- STEP 1: Create Master Key (ONLY ONCE)
--------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    CREATE MASTER KEY 
    ENCRYPTION BY PASSWORD = 'StrongMasterKey@123';
END
GO

--------------------------------------------
-- STEP 2: Create Certificate
--------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.certificates WHERE name = 'UserEmailCert')
BEGIN
    CREATE CERTIFICATE UserEmailCert
    WITH SUBJECT = 'Certificate for Email Encryption';
END
GO

--------------------------------------------
-- STEP 3: Create Symmetric Key (AES256)
--------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'UserEmailKey')
BEGIN
    CREATE SYMMETRIC KEY UserEmailKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE UserEmailCert;
END
GO

--------------------------------------------
-- STEP 4: Add encrypted column to User table
--------------------------------------------
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE Name = 'Encrypted_Email' 
      AND Object_ID = Object_ID('User')
)
BEGIN
    ALTER TABLE [User]
    ADD Encrypted_Email VARBINARY(MAX);
END
GO

--------------------------------------------
-- STEP 5: Encrypt existing Email values
--------------------------------------------
OPEN SYMMETRIC KEY UserEmailKey
DECRYPTION BY CERTIFICATE UserEmailCert;

UPDATE [User]
SET Encrypted_Email = EncryptByKey(
        Key_GUID('UserEmailKey'),
        Email
    );

CLOSE SYMMETRIC KEY UserEmailKey;
GO

--------------------------------------------
-- STEP 6: Test decryption
--------------------------------------------
OPEN SYMMETRIC KEY UserEmailKey
DECRYPTION BY CERTIFICATE UserEmailCert;

SELECT 
    User_ID,
    Role_ID,
    Name,
    CONVERT(VARCHAR(200), DecryptByKey(Encrypted_Email)) AS DecryptedEmail
FROM [User];

CLOSE SYMMETRIC KEY UserEmailKey;
GO
