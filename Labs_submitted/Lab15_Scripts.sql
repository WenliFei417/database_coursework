USE CSE581labs;
GO

CREATE OR ALTER PROCEDURE wfei01.sp_Divide
    @A DECIMAL(10,2),
    @B DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        SELECT @A / @B AS Result;
    END TRY
    BEGIN CATCH
        PRINT 'An error has occurred';
        SELECT -1 AS Result;
    END CATCH
END;
GO

-- Test 1: A = 10, B = 2
EXEC wfei01.sp_Divide 10, 2;
GO

-- Test 2: A = 10, B = 0
EXEC wfei01.sp_Divide 10, 0;
GO

-- Test 3: A = 10.5, B = 2.2
EXEC wfei01.sp_Divide 10.5, 2.2;
GO