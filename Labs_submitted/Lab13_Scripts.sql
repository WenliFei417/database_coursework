USE CSE581labs;
GO



CREATE TRIGGER wfei01.trg_CourseEnrollment_OpenSeats
ON wfei01.CourseEnrollment
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    /* -------------------------------
       INSERT only
       "inserted" has data, "deleted" has no data
       ------------------------------- */
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        UPDATE c
        SET c.OpenSeats = c.OpenSeats - 1
        FROM wfei01.Courses c
        INNER JOIN inserted i
            ON c.CourseId = i.CourseId;
    END

    /* -------------------------------
       DELETE only
       "deleted" has data，"inserted" has no data
       ------------------------------- */
    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        UPDATE c
        SET c.OpenSeats = c.OpenSeats + 1
        FROM wfei01.Courses c
        INNER JOIN deleted d
            ON c.CourseId = d.CourseId;
    END

    /* -------------------------------
       UPDATE only
       both"inserted" and "deleted" has data
       "Seats" are adjusted only when the "CourseId" changes
       ------------------------------- */
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        /* Old curriculum seats +1 */
        UPDATE c
        SET c.OpenSeats = c.OpenSeats + 1
        FROM wfei01.Courses c
        INNER JOIN deleted d
            ON c.CourseId = d.CourseId
        INNER JOIN inserted i
            ON d.EnrollmentId = i.EnrollmentId
        WHERE d.CourseId <> i.CourseId;

        /* New curriculum seats -1 */
        UPDATE c
        SET c.OpenSeats = c.OpenSeats - 1
        FROM wfei01.Courses c
        INNER JOIN inserted i
            ON c.CourseId = i.CourseId
        INNER JOIN deleted d
            ON d.EnrollmentId = i.EnrollmentId
        WHERE d.CourseId <> i.CourseId;
    END
END;
GO





-- before INSERT
SELECT * 
FROM wfei01.CourseEnrollment
ORDER BY EnrollmentId;

SELECT * 
FROM wfei01.Courses
ORDER BY CourseId;
GO

-- implement INSERT
INSERT INTO wfei01.CourseEnrollment (StudentId, CourseId, FinalGrade)
VALUES ('01-HJPotter', 6, NULL);
GO

-- after INSERT
SELECT * 
FROM wfei01.CourseEnrollment
ORDER BY EnrollmentId;

SELECT * 
FROM wfei01.Courses
ORDER BY CourseId;
GO




-- before DELETE
SELECT * 
FROM wfei01.CourseEnrollment
ORDER BY EnrollmentId;

SELECT * 
FROM wfei01.Courses
ORDER BY CourseId;
GO

-- implement DELETE
DELETE FROM wfei01.CourseEnrollment
WHERE StudentId = '01-HJPotter'
  AND CourseId = 6;
GO

-- after DELETE
SELECT * 
FROM wfei01.CourseEnrollment
ORDER BY EnrollmentId;

SELECT * 
FROM wfei01.Courses
ORDER BY CourseId;
GO




-- before UPDATE
SELECT * 
FROM wfei01.CourseEnrollment
ORDER BY EnrollmentId;

SELECT * 
FROM wfei01.Courses
ORDER BY CourseId;
GO

-- implement UPDATE
UPDATE wfei01.CourseEnrollment
SET CourseId = 3
WHERE StudentId = '01-HJPotter'
  AND CourseId = 2;
GO

-- after UPDATE
SELECT * 
FROM wfei01.CourseEnrollment
ORDER BY EnrollmentId;

SELECT * 
FROM wfei01.Courses
ORDER BY CourseId;
GO