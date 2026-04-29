-- 1. View raw data
SELECT * FROM wfei01.CourseEnrollment;
SELECT * FROM wfei01.Courses;
GO

-- 2. Create a procedure
CREATE PROCEDURE wfei01.EnrollStudent
    @CourseId INT,
    @StudentId VARCHAR(20)
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM wfei01.CourseEnrollment
        WHERE CourseId = @CourseId
          AND StudentId = @StudentId
    )
    BEGIN
        PRINT 'The student is already enrolled';
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM wfei01.Courses
        WHERE CourseId = @CourseId
          AND Faculty IS NULL
    )
    BEGIN
        PRINT 'Cannot enroll until faculty is selected';
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM wfei01.Courses
        WHERE CourseId = @CourseId
          AND OpenSeats <= 0
    )
    BEGIN
        PRINT 'No open seats available';
        RETURN;
    END;

    INSERT INTO wfei01.CourseEnrollment (StudentId, CourseId, FinalGrade)
    VALUES (@StudentId, @CourseId, NULL);

    UPDATE wfei01.Courses
    SET OpenSeats = OpenSeats - 1
    WHERE CourseId = @CourseId;

    PRINT 'Student enrolled';
END;
GO

-- 3. Case 1
EXEC wfei01.EnrollStudent 1, '01-HJPotter';
SELECT * FROM wfei01.CourseEnrollment;
SELECT * FROM wfei01.Courses;
GO

-- 4. Case 2
EXEC wfei01.EnrollStudent 7, '03-HJGranger';
SELECT * FROM wfei01.CourseEnrollment;
SELECT * FROM wfei01.Courses;
GO

-- 5. Case 3
EXEC wfei01.EnrollStudent 5, '01-HJPotter';
SELECT * FROM wfei01.CourseEnrollment;
SELECT * FROM wfei01.Courses;
GO

-- 6. Case 4
EXEC wfei01.EnrollStudent 6, '01-HJPotter';
SELECT * FROM wfei01.CourseEnrollment;
SELECT * FROM wfei01.Courses;
GO