DECLARE @a char(10)
SELECT @a = '12345678901234567890123456789012345';
SELECT LEN(@a), DATALENGTH(@a)
SELECT @a
GO

DECLARE @a nchar(10)
SELECT @a = '12345678901234567890123456789012345';
SELECT LEN(@a), DATALENGTH(@a)
SELECT @a
GO

DECLARE @a varchar(10)
SELECT @a = '12345678901234567890123456789012345';
SELECT LEN(@a), DATALENGTH(@a)
SELECT @a
GO

DECLARE @a nvarchar(10)
SELECT @a = '12345678901234567890123456789012345';
SELECT LEN(@a), DATALENGTH(@a)
SELECT @a
GO
