CREATE PROCEDURE babel_931_proc (@a INT OUTPUT, @b INT OUTPUT) AS
BEGIN
  SET @a=100; PRINT '@a (inner): ' + cast(@a as varchar(10)); 
  SET @b=200; PRINT '@b (inner): ' + cast(@b as varchar(10)); 
  select @a+@b as ret; END;
GO

CREATE PROCEDURE babel_931_caller AS
BEGIN
  EXEC babel_931_proc 2, 3;
END
GO

EXEC babel_931_caller
GO

CREATE PROCEDURE babel_931_caller_2 AS
BEGIN
  DECLARE @b INT;
  EXEC babel_931_proc 2, @b OUT;
  PRINT '@b (outer): ' + cast(@b as varchar(10));
END
GO

EXEC babel_931_caller_2
GO

CREATE PROCEDURE babel_931_caller_3 AS
BEGIN
  DECLARE @a INT;
  DECLARE @b INT;
  EXEC babel_931_proc @a OUT, @b OUT;
  PRINT '@a (outer): ' + cast(@a as varchar(10));
  PRINT '@b (outer): ' + cast(@b as varchar(10));
END
GO

EXEC babel_931_caller_3
GO

DROP PROCEDURE babel_931_proc
GO

DROP PROCEDURE babel_931_caller
GO

DROP PROCEDURE babel_931_caller_2
GO

DROP PROCEDURE babel_931_caller_3
GO
