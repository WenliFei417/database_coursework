USE CSE581labs;
GO


CREATE FUNCTION wfei01.fn_CalculateStudentAverage
(
    @StudentId VARCHAR(20)
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @FinalGrade DECIMAL(5,2);
    DECLARE @Total DECIMAL(10,2) = 0;
    DECLARE @Count INT = 0;
    DECLARE @Average DECIMAL(5,2);

    DECLARE grade_cursor CURSOR FOR
        SELECT FinalGrade
        FROM wfei01.CourseEnrollment
        WHERE StudentId = @StudentId
          AND FinalGrade IS NOT NULL;

    OPEN grade_cursor;

    FETCH NEXT FROM grade_cursor INTO @FinalGrade;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Total = @Total + @FinalGrade;
        SET @Count = @Count + 1;

        FETCH NEXT FROM grade_cursor INTO @FinalGrade;
    END

    CLOSE grade_cursor;
    DEALLOCATE grade_cursor;

    IF @Count = 0
        SET @Average = NULL;
    ELSE
        SET @Average = ROUND(@Total / @Count, 2);

    RETURN @Average;
END;
GO






-- Execute the function for one student
SELECT 
    '01-HJPotter' AS StudentId,
    wfei01.fn_CalculateStudentAverage('01-HJPotter') AS AverageGrade;
GO

SELECT 
    '02-RBWeasley' AS StudentId,
    wfei01.fn_CalculateStudentAverage('02-RBWeasley') AS AverageGrade;
GO

SELECT 
    '03-HJGranger' AS StudentId,
    wfei01.fn_CalculateStudentAverage('03-HJGranger') AS AverageGrade;
GO







SELECT 
    ce.StudentId,
    ROUND(AVG(CAST(ce.FinalGrade AS DECIMAL(10,2))), 2) AS ExpectedAverage
FROM wfei01.CourseEnrollment ce
WHERE ce.FinalGrade IS NOT NULL
GROUP BY ce.StudentId
ORDER BY ce.StudentId;
GO






SELECT 
    EnrollmentId,
    StudentId,
    CourseId,
    FinalGrade
FROM wfei01.CourseEnrollment
ORDER BY StudentId, CourseId;
GO

