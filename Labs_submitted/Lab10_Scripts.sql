USE CSE581labs;
GO


/* =========================================================
   1. Create View 1
   Columns required:
   - Student First Name
   - Student Last Name
   - Course Title
   ========================================================= */
CREATE VIEW wfei01.vw_StudentCourses
AS
SELECT
    u.FirstName AS StudentFirstName,
    u.LastName  AS StudentLastName,
    c.CourseTitle
FROM wfei01.CourseEnrollment ce
INNER JOIN wfei01.Users u
    ON ce.StudentId = u.NTID
INNER JOIN wfei01.Courses c
    ON ce.CourseId = c.CourseId;
GO



/* =========================================================
   2. Select all data from View 1
   ========================================================= */
SELECT *
FROM wfei01.vw_StudentCourses;
GO



/* =========================================================
   3. Create View 2
   Columns required:
   - Student First Name
   - Student Last Name
   - Course Title
   - Course Faculty First Name
   - Course Faculty Last Name
   - Final Grade (number)
   ========================================================= */
CREATE VIEW wfei01.vw_StudentCourseFacultyGrades
AS
SELECT
    s.FirstName AS StudentFirstName,
    s.LastName  AS StudentLastName,
    c.CourseTitle,
    f.FirstName AS CourseFacultyFirstName,
    f.LastName  AS CourseFacultyLastName,
    ce.FinalGrade
FROM wfei01.CourseEnrollment ce
INNER JOIN wfei01.Users s
    ON ce.StudentId = s.NTID
INNER JOIN wfei01.Courses c
    ON ce.CourseId = c.CourseId
LEFT JOIN wfei01.Users f
    ON c.Faculty = f.NTID;
GO



/* =========================================================
   4. Select all data from View 2
   ========================================================= */
SELECT *
FROM wfei01.vw_StudentCourseFacultyGrades;
GO



/* =========================================================
   5. Select Harry's classes only from View 2
   ========================================================= */
SELECT *
FROM wfei01.vw_StudentCourseFacultyGrades
WHERE StudentFirstName = 'Harry';
GO




