USE CSE581labs;
GO




/*=====================================================
Add unique constraint on (CourseId, StudentId)
=====================================================*/
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints
    WHERE name = 'UQ_CourseEnrollment_CourseId_StudentId'
)
BEGIN
    ALTER TABLE wfei01.CourseEnrollment
    ADD CONSTRAINT UQ_CourseEnrollment_CourseId_StudentId
    UNIQUE (CourseId, StudentId);
END
GO


/*=====================================================
Recreate stored procedure with transaction
=====================================================*/
DROP PROCEDURE IF EXISTS wfei01.EnrollStudent;
GO

CREATE PROCEDURE wfei01.EnrollStudent
    @CourseId INT,
    @StudentId VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRAN;

        -- check faculty exists
        IF EXISTS (
            SELECT 1
            FROM wfei01.Courses
            WHERE CourseId = @CourseId
              AND Faculty IS NULL
        )
        BEGIN
            PRINT 'Cannot enroll until faculty is selected';
            ROLLBACK TRAN;
            RETURN;
        END;

        -- check open seats
        IF EXISTS (
            SELECT 1
            FROM wfei01.Courses
            WHERE CourseId = @CourseId
              AND OpenSeats <= 0
        )
        BEGIN
            PRINT 'No open seats available';
            ROLLBACK TRAN;
            RETURN;
        END;

        -- insert enrollment
        INSERT INTO wfei01.CourseEnrollment (StudentId, CourseId, FinalGrade)
        VALUES (@StudentId, @CourseId, NULL);

        -- reduce seat count
        UPDATE wfei01.Courses
        SET OpenSeats = OpenSeats - 1
        WHERE CourseId = @CourseId;

        COMMIT TRAN;
        PRINT 'Student enrolled successfully';
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        PRINT 'Enrollment failed. Transaction rolled back.';
    END CATCH
END;
GO


/*=====================================================
View data before execution
=====================================================*/
SELECT * 
FROM wfei01.CourseEnrollment
ORDER BY EnrollmentId;

SELECT * 
FROM wfei01.Courses
ORDER BY CourseId;
GO


/*=====================================================
Successful enrollment test
=====================================================*/
EXEC wfei01.EnrollStudent 6, '01-HJPotter';
GO

SELECT * 
FROM wfei01.CourseEnrollment
ORDER BY EnrollmentId;

SELECT * 
FROM wfei01.Courses
ORDER BY CourseId;
GO


/*=====================================================
Failed enrollment test (duplicate enrollment)
=====================================================*/
EXEC wfei01.EnrollStudent 6, '01-HJPotter';
GO

SELECT * 
FROM wfei01.CourseEnrollment
ORDER BY EnrollmentId;

SELECT * 
FROM wfei01.Courses
ORDER BY CourseId;
GO