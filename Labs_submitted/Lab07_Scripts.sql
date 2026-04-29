USE CSE581labs;
GO

CREATE SCHEMA wfei01;
GO




CREATE TABLE wfei01.Users (
    NTID VARCHAR(20) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    MiddleI VARCHAR(1),
    LastName VARCHAR(50) NOT NULL,
    EmailAddress VARCHAR(100),
    Password VARCHAR(50)
);
GO
GRANT SELECT ON wfei01.Users TO Graders;
GO




CREATE TABLE wfei01.Courses (
    CourseId INT IDENTITY(1,1) PRIMARY KEY,
    CourseCode VARCHAR(10) NOT NULL,
    CourseTitle VARCHAR(50) NOT NULL,
    Faculty VARCHAR(20),
    OpenSeats INT NOT NULL,
    FOREIGN KEY (Faculty) REFERENCES wfei01.Users(NTID)
);
GO
GRANT SELECT ON wfei01.Courses TO Graders;
GO




CREATE TABLE wfei01.LetterGrades (
    LetterGradeId INT IDENTITY(1,1) PRIMARY KEY,
    LetterGrade VARCHAR(2) NOT NULL,
    Description VARCHAR(50)
);
GO
GRANT SELECT ON wfei01.LetterGrades TO Graders;
GO




CREATE TABLE wfei01.CourseGrade (
    GradingScaleId INT IDENTITY(1,1) PRIMARY KEY,
    LetterGradeId INT NOT NULL,
    CourseId INT NOT NULL,
    GradeValue INT NOT NULL CHECK (GradeValue >= 0),
    FOREIGN KEY (LetterGradeId) REFERENCES wfei01.LetterGrades(LetterGradeId),
    FOREIGN KEY (CourseId) REFERENCES wfei01.Courses(CourseId)
);
GO
GRANT SELECT ON wfei01.CourseGrade TO Graders;
GO




CREATE TABLE wfei01.CourseEnrollment (
    EnrollmentId INT IDENTITY(1,1) PRIMARY KEY,
    StudentId VARCHAR(20) NOT NULL,
    CourseId INT NOT NULL,
    FinalGrade DECIMAL(5,2) CHECK (FinalGrade >= 0 AND FinalGrade <= 100),
    FOREIGN KEY (StudentId) REFERENCES wfei01.Users(NTID),
    FOREIGN KEY (CourseId) REFERENCES wfei01.Courses(CourseId)
);
GO
GRANT SELECT ON wfei01.CourseEnrollment TO Graders;
GO