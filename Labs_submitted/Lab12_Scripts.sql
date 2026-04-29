USE CSE581labs;
GO

CREATE FUNCTION wfei01.fn_GetLetterGradeDescription
(
    @CourseId INT,
    @NumericalGrade INT
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @LetterGradeDescription VARCHAR(50);

    SELECT TOP 1
        @LetterGradeDescription = lg.Description
    FROM wfei01.CourseGrade cg
    INNER JOIN wfei01.LetterGrades lg
        ON cg.LetterGradeId = lg.LetterGradeId
    WHERE cg.CourseId = @CourseId
      AND cg.GradeValue <= @NumericalGrade
    ORDER BY cg.GradeValue DESC;

    RETURN @LetterGradeDescription;
END;
GO

SELECT
    cg.CourseId,
    cg.GradeValue AS NumericalGrade,
    lg.Description AS LetterGradeDescription
FROM wfei01.CourseGrade cg
INNER JOIN wfei01.LetterGrades lg
    ON cg.LetterGradeId = lg.LetterGradeId
ORDER BY cg.CourseId, cg.GradeValue DESC;
GO

SELECT wfei01.fn_GetLetterGradeDescription(1, 95) AS Result;
SELECT wfei01.fn_GetLetterGradeDescription(2, 95) AS Result;
SELECT wfei01.fn_GetLetterGradeDescription(2, 85) AS Result;
GO