USE master;
GO

-- test volatility of function in batch
-- should see different id values with each iteration
DECLARE @i INT = 1
DECLARE @num_iter INT = 5
CREATE TABLE newid_volatile (u uniqueidentifier)
WHILE @i <= @num_iter
BEGIN
    INSERT INTO newid_volatile VALUES (NEWID())
    SET @i = @i + 1
END

-- should be equal to @num_iter
select count(distinct u) from newid_volatile
go

-- test volatility of function in procedure
-- should see different id values with each iteration
CREATE PROC p_newid AS
DECLARE @num_iter INT = 5
DECLARE @i INT = 1
CREATE TABLE newid_volatile_proc (u uniqueidentifier)
WHILE @i <= @num_iter
BEGIN
    INSERT INTO newid_volatile_proc VALUES (NEWID())
    SET @i = @i + 1
END
go
EXEC p_newid
-- should be equal to @num_iter
select count(distinct u) from newid_volatile_proc
GO


DROP TABLE newid_volatile
GO