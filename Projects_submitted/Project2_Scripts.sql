USE CSE581projects;
GO

/* =========================================================
   1. Modification

   Modification 1:
   Created a PersonalInfo table to store shared attributes between Student and Employee.
   Reason: This removes duplicated data and improves normalization.

   Modification 2:
   Created a Race lookup table.
   Reason: Race/Ethnicity was originally stored as text. A lookup table improves consistency and normalization.

   Modification 3:
   Created a States lookup table.
   Reason: State values should be standardized through a lookup table.

   Modification 4:
   Replaced the direct Employee–JobCode relationship with a junction table EmployeeJob.
   Reason: Employees and jobs have a many-to-many relationship, which must be implemented with a junction table.
   ========================================================= */


/* =========================================================
   2. LOOKUP TABLES
   ========================================================= */

CREATE TABLE wfei01.StudentStatus
(
    StudentStatusId INT IDENTITY(1,1) PRIMARY KEY,
    StatusName VARCHAR(30) NOT NULL UNIQUE
);
GO

CREATE TABLE wfei01.CourseLevel
(
    CourseLevelId INT IDENTITY(1,1) PRIMARY KEY,
    LevelName VARCHAR(30) NOT NULL UNIQUE
);
GO

CREATE TABLE wfei01.EnrollmentStatus
(
    EnrollmentStatusId INT IDENTITY(1,1) PRIMARY KEY,
    StatusName VARCHAR(30) NOT NULL UNIQUE
);
GO

CREATE TABLE wfei01.ClassroomType
(
    ClassroomTypeId INT IDENTITY(1,1) PRIMARY KEY,
    TypeName VARCHAR(30) NOT NULL UNIQUE
);
GO

CREATE TABLE wfei01.CoverageType
(
    CoverageTypeId INT IDENTITY(1,1) PRIMARY KEY,
    CoverageName VARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE wfei01.BenefitType
(
    BenefitTypeId INT IDENTITY(1,1) PRIMARY KEY,
    BenefitName VARCHAR(30) NOT NULL UNIQUE
);
GO

CREATE TABLE wfei01.StudentType
(
    StudentTypeId INT IDENTITY(1,1) PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE wfei01.StudentLevel
(
    StudentLevelId INT IDENTITY(1,1) PRIMARY KEY,
    LevelName VARCHAR(30) NOT NULL UNIQUE
);
GO

CREATE TABLE wfei01.TermType
(
    TermTypeId INT IDENTITY(1,1) PRIMARY KEY,
    TermName VARCHAR(30) NOT NULL UNIQUE
);
GO

CREATE TABLE wfei01.Race
(
    RaceId INT IDENTITY(1,1) PRIMARY KEY,
    RaceName VARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE wfei01.States
(
    StateId INT IDENTITY(1,1) PRIMARY KEY,
    StateCode CHAR(2) NOT NULL UNIQUE,
    StateName VARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE wfei01.College
(
    CollegeId INT IDENTITY(1,1) PRIMARY KEY,
    CollegeName VARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE wfei01.Building
(
    BuildingId INT IDENTITY(1,1) PRIMARY KEY,
    BuildingName VARCHAR(100) NOT NULL UNIQUE
);
GO

/* =========================================================
   3. CORE TABLES
   ========================================================= */

CREATE TABLE wfei01.PersonalInfo
(
    PersonalInfoId INT IDENTITY(1,1) PRIMARY KEY,
    NTID VARCHAR(20) NOT NULL UNIQUE,
    [Password] VARCHAR(100) NOT NULL,
    SSN VARCHAR(11) NOT NULL UNIQUE,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50) NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender VARCHAR(20) NOT NULL,
    RaceId INT NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    MailingAddress VARCHAR(200) NOT NULL,
    CellPhone VARCHAR(20) NULL,
    StateId INT NOT NULL,
    CONSTRAINT FK_PersonalInfo_Race
        FOREIGN KEY (RaceId) REFERENCES wfei01.Race(RaceId),
    CONSTRAINT FK_PersonalInfo_States
        FOREIGN KEY (StateId) REFERENCES wfei01.States(StateId)
);
GO

CREATE TABLE wfei01.Student
(
    StudentId INT IDENTITY(1,1) PRIMARY KEY,
    PersonalInfoId INT NOT NULL UNIQUE,
    StudentStatusId INT NOT NULL,
    StudentTypeId INT NOT NULL,
    StudentLevelId INT NOT NULL,
    CONSTRAINT FK_Student_PersonalInfo
        FOREIGN KEY (PersonalInfoId) REFERENCES wfei01.PersonalInfo(PersonalInfoId),
    CONSTRAINT FK_Student_StudentStatus
        FOREIGN KEY (StudentStatusId) REFERENCES wfei01.StudentStatus(StudentStatusId),
    CONSTRAINT FK_Student_StudentType
        FOREIGN KEY (StudentTypeId) REFERENCES wfei01.StudentType(StudentTypeId),
    CONSTRAINT FK_Student_StudentLevel
        FOREIGN KEY (StudentLevelId) REFERENCES wfei01.StudentLevel(StudentLevelId)
);
GO

CREATE TABLE wfei01.Employee
(
    EmployeeId INT IDENTITY(1,1) PRIMARY KEY,
    PersonalInfoId INT NOT NULL UNIQUE,
    AnnualSalary DECIMAL(10,2) NOT NULL,
    CONSTRAINT CHK_Employee_AnnualSalary
        CHECK (AnnualSalary >= 0),
    CONSTRAINT FK_Employee_PersonalInfo
        FOREIGN KEY (PersonalInfoId) REFERENCES wfei01.PersonalInfo(PersonalInfoId)
);
GO

CREATE TABLE wfei01.JobCode
(
    JobCodeId INT IDENTITY(1,1) PRIMARY KEY,
    JobCode VARCHAR(20) NOT NULL UNIQUE,
    JobTitle VARCHAR(100) NOT NULL,
    JobDescription VARCHAR(200) NULL,
    JobType VARCHAR(30) NOT NULL,
    MinPay DECIMAL(10,2) NOT NULL,
    MaxPay DECIMAL(10,2) NOT NULL,
    CONSTRAINT CHK_JobCode_PayRange
        CHECK (MinPay >= 0 AND MaxPay >= MinPay)
);
GO

CREATE TABLE wfei01.EmployeeJob
(
    EmployeeId INT NOT NULL,
    JobCodeId INT NOT NULL,
    CONSTRAINT PK_EmployeeJob PRIMARY KEY (EmployeeId, JobCodeId),
    CONSTRAINT FK_EmployeeJob_Employee
        FOREIGN KEY (EmployeeId) REFERENCES wfei01.Employee(EmployeeId),
    CONSTRAINT FK_EmployeeJob_JobCode
        FOREIGN KEY (JobCodeId) REFERENCES wfei01.JobCode(JobCodeId)
);
GO

CREATE TABLE wfei01.EmployeeBenefit
(
    EmployeeId INT NOT NULL,
    BenefitTypeId INT NOT NULL,
    CoverageTypeId INT NOT NULL,
    EmployeePremiumAmount DECIMAL(10,2) NOT NULL DEFAULT 0,
    EmployerPremiumAmount DECIMAL(10,2) NOT NULL DEFAULT 0,
    CONSTRAINT PK_EmployeeBenefit PRIMARY KEY (EmployeeId, BenefitTypeId),
    CONSTRAINT CHK_EmployeeBenefit_Premiums
        CHECK (EmployeePremiumAmount >= 0 AND EmployerPremiumAmount >= 0),
    CONSTRAINT FK_EmployeeBenefit_Employee
        FOREIGN KEY (EmployeeId) REFERENCES wfei01.Employee(EmployeeId),
    CONSTRAINT FK_EmployeeBenefit_BenefitType
        FOREIGN KEY (BenefitTypeId) REFERENCES wfei01.BenefitType(BenefitTypeId),
    CONSTRAINT FK_EmployeeBenefit_CoverageType
        FOREIGN KEY (CoverageTypeId) REFERENCES wfei01.CoverageType(CoverageTypeId)
);
GO

CREATE TABLE wfei01.Semester
(
    SemesterId INT IDENTITY(1,1) PRIMARY KEY,
    TermTypeId INT NOT NULL,
    [Year] INT NOT NULL,
    BeginDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    CONSTRAINT CHK_Semester_Dates
        CHECK (EndDate >= BeginDate),
    CONSTRAINT FK_Semester_TermType
        FOREIGN KEY (TermTypeId) REFERENCES wfei01.TermType(TermTypeId)
);
GO

CREATE TABLE wfei01.Course
(
    CourseId INT IDENTITY(1,1) PRIMARY KEY,
    CourseCode VARCHAR(20) NOT NULL,
    CourseNumber VARCHAR(20) NOT NULL,
    CourseTitle VARCHAR(100) NOT NULL,
    CourseDepartment VARCHAR(100) NOT NULL,
    CourseDescription VARCHAR(300) NULL,
    CourseLevelId INT NOT NULL,
    CreditHours INT NOT NULL,
    CONSTRAINT UQ_Course_CodeNumber UNIQUE (CourseCode, CourseNumber),
    CONSTRAINT CHK_Course_CreditHours
        CHECK (CreditHours > 0 AND CreditHours <= 6),
    CONSTRAINT FK_Course_CourseLevel
        FOREIGN KEY (CourseLevelId) REFERENCES wfei01.CourseLevel(CourseLevelId)
);
GO

CREATE TABLE wfei01.CoursePrerequisite
(
    CourseId INT NOT NULL,
    PrereqCourseId INT NOT NULL,
    CONSTRAINT PK_CoursePrerequisite PRIMARY KEY (CourseId, PrereqCourseId),
    CONSTRAINT CHK_CoursePrerequisite_NoSelf
        CHECK (CourseId <> PrereqCourseId),
    CONSTRAINT FK_CoursePrerequisite_Course
        FOREIGN KEY (CourseId) REFERENCES wfei01.Course(CourseId),
    CONSTRAINT FK_CoursePrerequisite_PrereqCourse
        FOREIGN KEY (PrereqCourseId) REFERENCES wfei01.Course(CourseId)
);
GO

CREATE TABLE wfei01.Classroom
(
    ClassroomId INT IDENTITY(1,1) PRIMARY KEY,
    BuildingId INT NOT NULL,
    [Level] INT NOT NULL,
    RoomNumber VARCHAR(20) NOT NULL,
    ClassroomTypeId INT NOT NULL,
    Capacity INT NOT NULL,
    EquipmentDescription VARCHAR(200) NULL,
    CONSTRAINT CHK_Classroom_Capacity
        CHECK (Capacity > 0),
    CONSTRAINT FK_Classroom_Building
        FOREIGN KEY (BuildingId) REFERENCES wfei01.Building(BuildingId),
    CONSTRAINT FK_Classroom_ClassroomType
        FOREIGN KEY (ClassroomTypeId) REFERENCES wfei01.ClassroomType(ClassroomTypeId)
);
GO

CREATE TABLE wfei01.Program
(
    ProgramId INT IDENTITY(1,1) PRIMARY KEY,
    CollegeId INT NOT NULL,
    ProgramName VARCHAR(100) NOT NULL,
    CONSTRAINT FK_Program_College
        FOREIGN KEY (CollegeId) REFERENCES wfei01.College(CollegeId)
);
GO

CREATE TABLE wfei01.StudentProgram
(
    StudentId INT NOT NULL,
    ProgramId INT NOT NULL,
    [Role] VARCHAR(20) NOT NULL,
    CONSTRAINT PK_StudentProgram PRIMARY KEY (StudentId, ProgramId),
    CONSTRAINT CHK_StudentProgram_Role
        CHECK ([Role] IN ('Major', 'Minor')),
    CONSTRAINT FK_StudentProgram_Student
        FOREIGN KEY (StudentId) REFERENCES wfei01.Student(StudentId),
    CONSTRAINT FK_StudentProgram_Program
        FOREIGN KEY (ProgramId) REFERENCES wfei01.Program(ProgramId)
);
GO

CREATE TABLE wfei01.CourseOffering
(
    CRN INT PRIMARY KEY,
    CourseId INT NOT NULL,
    SemesterId INT NOT NULL,
    Section VARCHAR(10) NOT NULL,
    InstructorEmployeeId INT NOT NULL,
    ClassroomId INT NOT NULL,
    ActualEnrollment INT NOT NULL DEFAULT 0,
    CONSTRAINT CHK_CourseOffering_ActualEnrollment
        CHECK (ActualEnrollment >= 0),
    CONSTRAINT FK_CourseOffering_Course
        FOREIGN KEY (CourseId) REFERENCES wfei01.Course(CourseId),
    CONSTRAINT FK_CourseOffering_Semester
        FOREIGN KEY (SemesterId) REFERENCES wfei01.Semester(SemesterId),
    CONSTRAINT FK_CourseOffering_Employee
        FOREIGN KEY (InstructorEmployeeId) REFERENCES wfei01.Employee(EmployeeId),
    CONSTRAINT FK_CourseOffering_Classroom
        FOREIGN KEY (ClassroomId) REFERENCES wfei01.Classroom(ClassroomId)
);
GO

CREATE TABLE wfei01.CourseEnrollment
(
    StudentId INT NOT NULL,
    CRN INT NOT NULL,
    EnrollmentStatusId INT NOT NULL,
    MidtermGrade VARCHAR(5) NULL,
    FinalGrade VARCHAR(5) NULL,
    CONSTRAINT PK_CourseEnrollment PRIMARY KEY (StudentId, CRN),
    CONSTRAINT FK_CourseEnrollment_Student
        FOREIGN KEY (StudentId) REFERENCES wfei01.Student(StudentId),
    CONSTRAINT FK_CourseEnrollment_CourseOffering
        FOREIGN KEY (CRN) REFERENCES wfei01.CourseOffering(CRN),
    CONSTRAINT FK_CourseEnrollment_EnrollmentStatus
        FOREIGN KEY (EnrollmentStatusId) REFERENCES wfei01.EnrollmentStatus(EnrollmentStatusId)
);
GO

CREATE TABLE wfei01.CourseMeetingTime
(
    CRN INT NOT NULL,
    DayOfWeek VARCHAR(15) NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    CONSTRAINT PK_CourseMeetingTime PRIMARY KEY (CRN, DayOfWeek),
    CONSTRAINT CHK_CourseMeetingTime_Times
        CHECK (EndTime > StartTime),
    CONSTRAINT FK_CourseMeetingTime_CourseOffering
        FOREIGN KEY (CRN) REFERENCES wfei01.CourseOffering(CRN)
);
GO

/* =========================================================
   4. GRANT ACCESS TO GRADERS
   ========================================================= */

GRANT SELECT ON SCHEMA::wfei01 TO Graders;
GO


/* =========================================================
   5. DUMMY DATA
   Each table targets 3-10 rows, averaging ~6 rows per table.
   ========================================================= */

-- =========================================================
-- Lookup Tables
-- =========================================================

-- StudentStatus  (ER values: active / suspended / in-active)
INSERT INTO wfei01.StudentStatus (StatusName)
VALUES
('Active'),
('Suspended'),
('In-Active');
GO

-- CourseLevel  (ER values: undergraduate / graduate)
INSERT INTO wfei01.CourseLevel (LevelName)
VALUES
('Undergraduate'),
('Graduate');
GO

-- EnrollmentStatus  (ER values: enrolled / dropped / audit)
INSERT INTO wfei01.EnrollmentStatus (StatusName)
VALUES
('Enrolled'),
('Dropped'),
('Audit');
GO

-- ClassroomType  (ER values: lab / instruction)
INSERT INTO wfei01.ClassroomType (TypeName)
VALUES
('Lab'),
('Instruction');
GO

-- CoverageType  (ER values: employee only / employee+children / employee+spouse / family)
INSERT INTO wfei01.CoverageType (CoverageName)
VALUES
('Employee Only'),
('Employee + Children'),
('Employee + Spouse'),
('Family');
GO

-- BenefitType  (ER values: health / vision / dental)
INSERT INTO wfei01.BenefitType (BenefitName)
VALUES
('Health'),
('Vision'),
('Dental');
GO

-- StudentType  (ER values: new freshmen / continue / transfer / re-admitted / new graduate / continue graduate)
INSERT INTO wfei01.StudentType (TypeName)
VALUES
('New Freshmen'),
('Continue'),
('Transfer'),
('Re-Admitted'),
('New Graduate'),
('Continue Graduate');
GO

-- StudentLevel  (ER values: undergraduate / graduate)
INSERT INTO wfei01.StudentLevel (LevelName)
VALUES
('Undergraduate'),
('Graduate');
GO

-- TermType  (ER values: Fall / Spring / Summer I / Summer II / Combined Summer)
INSERT INTO wfei01.TermType (TermName)
VALUES
('Fall'),
('Spring'),
('Summer I'),
('Summer II'),
('Combined Summer');
GO

-- Race
INSERT INTO wfei01.Race (RaceName)
VALUES
('White'),
('Asian'),
('Hispanic or Latino'),
('Black or African American'),
('American Indian or Alaska Native'),
('Two or More Races');
GO

-- States
INSERT INTO wfei01.States (StateCode, StateName)
VALUES
('NY', 'New York'),
('CA', 'California'),
('TX', 'Texas'),
('FL', 'Florida'),
('IL', 'Illinois'),
('WA', 'Washington');
GO

-- College
INSERT INTO wfei01.College (CollegeName)
VALUES
('College of Engineering and Computer Science'),
('College of Arts and Sciences'),
('School of Education'),
('Whitman School of Management'),
('College of Visual and Performing Arts'),
('School of Information Studies');
GO

-- Building
INSERT INTO wfei01.Building (BuildingName)
VALUES
('Link Hall'),
('Hinds Hall'),
('Life Sciences Complex'),
('Newhouse Hall'),
('Bird Library'),
('Hall of Languages');
GO


-- =========================================================
-- PersonalInfo  (12 people: 6 will be students, 6 will be employees)
-- =========================================================

INSERT INTO wfei01.PersonalInfo
(
    NTID, [Password], SSN, FirstName, MiddleName, LastName,
    DateOfBirth, Gender, RaceId, Email, MailingAddress, CellPhone, StateId
)
VALUES
-- Students (PersonalInfoId 1-6)
('jdoe01',  'Pass123!', '111-22-3333', 'John',    'A',  'Doe',
 '2003-05-15', 'Male',   1, 'jdoe01@syr.edu',  '100 University Ave', '315-100-0001', 1),

('mchen01', 'Pass123!', '111-22-3334', 'Mei',     NULL, 'Chen',
 '2002-08-20', 'Female', 2, 'mchen01@syr.edu', '200 Euclid Ave',     '315-100-0002', 2),

('rgarci1', 'Pass123!', '111-22-3335', 'Roberto', NULL, 'Garcia',
 '2001-01-30', 'Male',   3, 'rgarci1@syr.edu', '300 Comstock Ave',   '315-100-0003', 3),

('akim01',  'Pass123!', '111-22-3336', 'Anna',    NULL, 'Kim',
 '2002-02-10', 'Female', 4, 'akim01@syr.edu',  '444 South Ave',      '315-100-0004', 4),

('tlee01',  'Pass123!', '111-22-3337', 'Thomas',  NULL, 'Lee',
 '2001-09-14', 'Male',   5, 'tlee01@syr.edu',  '555 North Ave',      '315-100-0005', 5),

('pmoore1', 'Pass123!', '111-22-3338', 'Paula',   'R',  'Moore',
 '2000-12-01', 'Female', 6, 'pmoore1@syr.edu', '666 Oak St',         '315-100-0006', 6),

-- Employees (PersonalInfoId 7-12)
('ssmith1', 'Pass123!', '111-22-4441', 'Sarah',   'L',  'Smith',
 '1980-03-12', 'Female', 1, 'ssmith1@syr.edu', '710 Walnut Ave',     '315-200-0001', 1),

('bwilso1', 'Pass123!', '111-22-4442', 'Brian',   NULL, 'Wilson',
 '1975-07-25', 'Male',   2, 'bwilso1@syr.edu', '820 Elm St',         '315-200-0002', 2),

('ljones1', 'Pass123!', '111-22-4443', 'Linda',   'M',  'Jones',
 '1982-11-05', 'Female', 3, 'ljones1@syr.edu', '930 Maple Dr',       '315-200-0003', 3),

('jhall01', 'Pass123!', '111-22-4444', 'James',   NULL, 'Hall',
 '1979-04-22', 'Male',   4, 'jhall01@syr.edu', '777 Pine St',        '315-200-0004', 4),

('npatel1', 'Pass123!', '111-22-4445', 'Neha',    NULL, 'Patel',
 '1988-06-18', 'Female', 1, 'npatel1@syr.edu', '888 Walnut St',      '315-200-0005', 5),

('dyoung1', 'Pass123!', '111-22-4446', 'David',   NULL, 'Young',
 '1983-10-08', 'Male',   2, 'dyoung1@syr.edu', '999 Cedar St',       '315-200-0006', 6);
GO


-- =========================================================
-- Student  (6 rows, PersonalInfoId 1-6)
-- =========================================================

INSERT INTO wfei01.Student
(
    PersonalInfoId, StudentStatusId, StudentTypeId, StudentLevelId
)
VALUES
(1, 1, 1, 1),
(2, 1, 2, 1),
(3, 1, 3, 1),
(4, 1, 4, 1),
(5, 2, 5, 2),
(6, 3, 6, 2);
GO


-- =========================================================
-- Employee  (6 rows, PersonalInfoId 7-12)
-- =========================================================

INSERT INTO wfei01.Employee
(
    PersonalInfoId, AnnualSalary
)
VALUES
(7,  70000.00),
(8,  72000.00),
(9,  95000.00),
(10, 62000.00),
(11, 69000.00),
(12, 58000.00);
GO


-- =========================================================
-- JobCode  (6 rows)
-- =========================================================

INSERT INTO wfei01.JobCode
(
    JobCode, JobTitle, JobDescription, JobType, MinPay, MaxPay
)
VALUES
('FAC101', 'Lecturer',        'Teaches undergraduate courses',               'Faculty', 50000.00, 75000.00),
('FAC201', 'Assistant Prof',   'Conducts research and teaches',               'Faculty', 65000.00, 95000.00),
('FAC301', 'Associate Prof',   'Senior faculty with tenure track',            'Faculty', 80000.00, 120000.00),
('LIB401', 'Librarian',        'Supports library services and research help', 'Staff',   42000.00, 68000.00),
('ANA501', 'Data Analyst',     'Analyzes institutional data and reports',     'Staff',   55000.00, 85000.00),
('TEC601', 'Lab Technician',   'Maintains lab equipment and operations',      'Staff',   38000.00, 62000.00);
GO


-- =========================================================
-- EmployeeJob  (6 rows)
-- =========================================================

INSERT INTO wfei01.EmployeeJob
(
    EmployeeId, JobCodeId
)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);
GO


-- =========================================================
-- EmployeeBenefit  (6 rows)
-- =========================================================

INSERT INTO wfei01.EmployeeBenefit
(
    EmployeeId, BenefitTypeId, CoverageTypeId, EmployeePremiumAmount, EmployerPremiumAmount
)
VALUES
(1, 1, 1, 200.00, 600.00),
(2, 2, 2, 50.00,  150.00),
(3, 3, 3, 80.00,  250.00),
(4, 1, 4, 150.00, 450.00),
(5, 2, 1, 40.00,  200.00),
(6, 3, 2, 25.00,  180.00);
GO


-- =========================================================
-- Semester  (6 rows)
-- =========================================================

INSERT INTO wfei01.Semester
(
    TermTypeId, [Year], BeginDate, EndDate
)
VALUES
(1, 2026, '2026-08-25', '2026-12-15'),
(2, 2027, '2027-01-13', '2027-05-05'),
(3, 2027, '2027-05-19', '2027-06-27'),
(4, 2027, '2027-07-07', '2027-08-15'),
(5, 2027, '2027-05-19', '2027-08-15'),
(2, 2028, '2028-01-10', '2028-05-01');
GO


-- =========================================================
-- Course  (6 rows)
-- =========================================================

INSERT INTO wfei01.Course
(
    CourseCode, CourseNumber, CourseTitle, CourseDepartment,
    CourseDescription, CourseLevelId, CreditHours
)
VALUES
('CSE', '581', 'Introduction to Databases', 'Computer Science',
 'Covers relational database concepts and SQL', 2, 3),

('CSE', '384', 'Systems Programming', 'Computer Science',
 'Programming in C and Unix system calls', 1, 3),

('IST', '256', 'Application Programming', 'Information Studies',
 'Introduction to application development', 1, 3),

('IST', '659', 'Database Administration', 'Information Studies',
 'Covers database administration concepts and tools', 2, 3),

('ACC', '201', 'Financial Accounting', 'Accounting',
 'Introduction to accounting principles', 1, 3),

('CSE', '785', 'Distributed Systems', 'Computer Science',
 'Advanced topics in distributed computing', 2, 3);
GO


-- =========================================================
-- CoursePrerequisite  (4 rows)
-- =========================================================

INSERT INTO wfei01.CoursePrerequisite
(
    CourseId, PrereqCourseId
)
VALUES
(4, 1),
(6, 2),
(1, 3),
(5, 3);
GO


-- =========================================================
-- Classroom  (6 rows)
-- =========================================================

INSERT INTO wfei01.Classroom
(
    BuildingId, [Level], RoomNumber, ClassroomTypeId, Capacity, EquipmentDescription
)
VALUES
(1, 1, '105', 2, 40, 'Projector and whiteboard'),
(2, 2, '210', 1, 30, 'Computer lab with 30 workstations'),
(3, 3, '302', 2, 50, 'Lecture hall with mic system'),
(4, 1, '110', 2, 20, 'Art tables and display screen'),
(5, 2, '205', 2, 35, 'Round tables and projector'),
(6, 3, '310', 2, 80, 'Large auditorium seating and microphones');
GO


-- =========================================================
-- Program  (6 rows)
-- =========================================================

INSERT INTO wfei01.Program
(
    CollegeId, ProgramName
)
VALUES
(1, 'Computer Science'),
(2, 'Biology'),
(3, 'Teaching and Leadership'),
(4, 'Business Analytics'),
(5, 'Graphic Design'),
(6, 'Information Management');
GO


-- =========================================================
-- StudentProgram  (6 rows)
-- =========================================================

INSERT INTO wfei01.StudentProgram
(
    StudentId, ProgramId, [Role]
)
VALUES
(1, 1, 'Major'),
(2, 1, 'Major'),
(3, 6, 'Major'),
(4, 4, 'Major'),
(5, 2, 'Minor'),
(6, 3, 'Major');
GO


-- =========================================================
-- CourseOffering  (6 rows)
-- =========================================================

INSERT INTO wfei01.CourseOffering
(
    CRN, CourseId, SemesterId, Section, InstructorEmployeeId, ClassroomId, ActualEnrollment
)
VALUES
(10001, 1, 1, 'M001', 1, 1, 3),
(10002, 2, 1, 'M002', 2, 2, 1),
(10003, 3, 2, 'M001', 3, 3, 0),
(10004, 4, 2, 'M002', 1, 1, 1),
(10005, 5, 3, 'S001', 4, 4, 1),
(10006, 6, 4, 'S002', 5, 5, 1);
GO


-- =========================================================
-- CourseEnrollment  (8 rows – demonstrates relationships)
-- =========================================================

INSERT INTO wfei01.CourseEnrollment
(
    StudentId, CRN, EnrollmentStatusId, MidtermGrade, FinalGrade
)
VALUES
(1, 10001, 1, 'A-', 'A'),
(2, 10001, 1, 'B+', 'B+'),
(3, 10001, 1, 'A',  'A'),
(1, 10002, 1, 'B',  NULL),
(2, 10003, 2, NULL, NULL),
(4, 10004, 1, 'A',  'A'),
(5, 10005, 3, NULL, NULL),
(6, 10006, 1, 'B-', NULL);
GO


-- =========================================================
-- CourseMeetingTime  (8 rows – some courses meet twice a week)
-- =========================================================

INSERT INTO wfei01.CourseMeetingTime
(
    CRN, DayOfWeek, StartTime, EndTime
)
VALUES
(10001, 'Monday',    '09:30:00', '10:45:00'),
(10001, 'Wednesday', '09:30:00', '10:45:00'),
(10002, 'Tuesday',   '14:00:00', '15:15:00'),
(10002, 'Thursday',  '14:00:00', '15:15:00'),
(10003, 'Monday',    '11:00:00', '12:15:00'),
(10004, 'Thursday',  '10:30:00', '11:45:00'),
(10005, 'Friday',    '12:00:00', '13:15:00'),
(10006, 'Saturday',  '09:30:00', '10:45:00');
GO