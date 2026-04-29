USE CSE581projects;
GO

-- This stored procedure uses a cursor to list all course offerings for a given semester one row at a time.
CREATE OR ALTER PROCEDURE wfei01.sp_ListCourseOfferingsBySemester_Cursor
    @SemesterId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM wfei01.Semester
        WHERE SemesterId = @SemesterId
    )
    BEGIN
        RAISERROR('Invalid SemesterId. Semester does not exist.', 16, 1);
        RETURN;
    END;

    DECLARE
        @CRN INT,
        @CourseTitle VARCHAR(100),
        @ActualEnrollment INT;

    DECLARE course_cursor CURSOR FOR
        SELECT co.CRN, c.CourseTitle, co.ActualEnrollment
        FROM wfei01.CourseOffering co
        INNER JOIN wfei01.Course c
            ON co.CourseId = c.CourseId
        WHERE co.SemesterId = @SemesterId;

    OPEN course_cursor;

    FETCH NEXT FROM course_cursor
    INTO @CRN, @CourseTitle, @ActualEnrollment;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'CRN: ' + CAST(@CRN AS VARCHAR(10))
            + ', Course: ' + @CourseTitle
            + ', Enrollment: ' + CAST(@ActualEnrollment AS VARCHAR(10));

        FETCH NEXT FROM course_cursor
        INTO @CRN, @CourseTitle, @ActualEnrollment;
    END;

    CLOSE course_cursor;
    DEALLOCATE course_cursor;
END;
GO


-- This stored procedure updates an employee benefit record after validating the input values.
CREATE OR ALTER PROCEDURE wfei01.sp_UpdateEmployeeBenefit
    @EmployeeId INT,
    @BenefitTypeId INT,
    @CoverageTypeId INT,
    @EmployeePremiumAmount DECIMAL(10,2),
    @EmployerPremiumAmount DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM wfei01.Employee
        WHERE EmployeeId = @EmployeeId
    )
    BEGIN
        RAISERROR('Invalid EmployeeId.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM wfei01.BenefitType
        WHERE BenefitTypeId = @BenefitTypeId
    )
    BEGIN
        RAISERROR('Invalid BenefitTypeId.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM wfei01.CoverageType
        WHERE CoverageTypeId = @CoverageTypeId
    )
    BEGIN
        RAISERROR('Invalid CoverageTypeId.', 16, 1);
        RETURN;
    END;

    IF @EmployeePremiumAmount < 0 OR @EmployerPremiumAmount < 0
    BEGIN
        RAISERROR('Premium amounts cannot be negative.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM wfei01.EmployeeBenefit
        WHERE EmployeeId = @EmployeeId
          AND BenefitTypeId = @BenefitTypeId
    )
    BEGIN
        RAISERROR('EmployeeBenefit record does not exist.', 16, 1);
        RETURN;
    END;

    UPDATE wfei01.EmployeeBenefit
    SET CoverageTypeId = @CoverageTypeId,
        EmployeePremiumAmount = @EmployeePremiumAmount,
        EmployerPremiumAmount = @EmployerPremiumAmount
    WHERE EmployeeId = @EmployeeId
      AND BenefitTypeId = @BenefitTypeId;

    PRINT 'Employee benefit updated successfully.';
END;
GO


-- This stored procedure deletes a coverage type record and rolls back the transaction if a foreign key error occurs.
CREATE OR ALTER PROCEDURE wfei01.sp_DeleteCoverageType
    @CoverageTypeId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM wfei01.CoverageType
        WHERE CoverageTypeId = @CoverageTypeId
    )
    BEGIN
        RAISERROR('CoverageTypeId does not exist.', 16, 1);
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM wfei01.CoverageType
        WHERE CoverageTypeId = @CoverageTypeId;

        COMMIT TRANSACTION;
        PRINT 'Coverage type deleted successfully.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Delete failed.';
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO


-- This stored procedure performs the business action of enrolling an active student into a course if space is available.
CREATE OR ALTER PROCEDURE wfei01.sp_EnrollStudentInCourse
    @StudentId INT,
    @CRN INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EnrollmentStatusId INT;
    DECLARE @ActualEnrollment INT;
    DECLARE @Capacity INT;

    IF NOT EXISTS
    (
        SELECT 1
        FROM wfei01.Student
        WHERE StudentId = @StudentId
    )
    BEGIN
        RAISERROR('Invalid StudentId.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM wfei01.CourseOffering
        WHERE CRN = @CRN
    )
    BEGIN
        RAISERROR('Invalid CRN.', 16, 1);
        RETURN;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM wfei01.CourseEnrollment
        WHERE StudentId = @StudentId
          AND CRN = @CRN
    )
    BEGIN
        RAISERROR('Student is already enrolled in this course.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM wfei01.Student s
        INNER JOIN wfei01.StudentStatus ss
            ON s.StudentStatusId = ss.StudentStatusId
        WHERE s.StudentId = @StudentId
          AND ss.StatusName = 'Active'
    )
    BEGIN
        RAISERROR('Only active students can enroll.', 16, 1);
        RETURN;
    END;

    SELECT
        @ActualEnrollment = co.ActualEnrollment,
        @Capacity = c.Capacity
    FROM wfei01.CourseOffering co
    INNER JOIN wfei01.Classroom c
        ON co.ClassroomId = c.ClassroomId
    WHERE co.CRN = @CRN;

    IF @ActualEnrollment >= @Capacity
    BEGIN
        RAISERROR('Course is full.', 16, 1);
        RETURN;
    END;

    SELECT @EnrollmentStatusId = EnrollmentStatusId
    FROM wfei01.EnrollmentStatus
    WHERE StatusName = 'Enrolled';

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO wfei01.CourseEnrollment
        (
            StudentId, CRN, EnrollmentStatusId, MidtermGrade, FinalGrade
        )
        VALUES
        (
            @StudentId, @CRN, @EnrollmentStatusId, NULL, NULL
        );

        UPDATE wfei01.CourseOffering
        SET ActualEnrollment = ActualEnrollment + 1
        WHERE CRN = @CRN;

        COMMIT TRANSACTION;
        PRINT 'Student enrolled successfully.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Enrollment failed.';
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO


GRANT EXECUTE ON SCHEMA::wfei01 TO Graders;
GO


-- This function returns a table showing each course and its prerequisite course list.
CREATE OR ALTER FUNCTION wfei01.fn_CoursePrerequisiteList()
RETURNS TABLE
AS
RETURN
(
    SELECT
        c.CourseId,
        c.CourseCode + ' ' + c.CourseNumber AS Course,
        c.CourseTitle,
        p.CourseId AS PrerequisiteCourseId,
        p.CourseCode + ' ' + p.CourseNumber AS PrerequisiteCourse,
        p.CourseTitle AS PrerequisiteTitle
    FROM wfei01.CoursePrerequisite cp
    INNER JOIN wfei01.Course c
        ON cp.CourseId = c.CourseId
    INNER JOIN wfei01.Course p
        ON cp.PrereqCourseId = p.CourseId
);
GO


GRANT SELECT ON OBJECT::wfei01.fn_CoursePrerequisiteList TO Graders;
GO


-- This view shows each employee's ID, name, benefit type, coverage type, employee premium, and employer premium.
CREATE OR ALTER VIEW wfei01.Benefits
AS
SELECT
    e.EmployeeId,
    pi.FirstName + ' ' + pi.LastName AS EmployeeName,
    bt.BenefitName AS BenefitType,
    ct.CoverageName AS BenefitCoverage,
    eb.EmployeePremiumAmount AS EmployeePremium,
    eb.EmployerPremiumAmount AS EmployerPremium
FROM wfei01.EmployeeBenefit eb
INNER JOIN wfei01.Employee e
    ON eb.EmployeeId = e.EmployeeId
INNER JOIN wfei01.PersonalInfo pi
    ON e.PersonalInfoId = pi.PersonalInfoId
INNER JOIN wfei01.BenefitType bt
    ON eb.BenefitTypeId = bt.BenefitTypeId
INNER JOIN wfei01.CoverageType ct
    ON eb.CoverageTypeId = ct.CoverageTypeId;
GO


GRANT SELECT ON SCHEMA::wfei01 TO Graders;
GO