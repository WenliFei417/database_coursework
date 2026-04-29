USE CSE581labs;
GO


/* ------------------------------------------------------------
1.	Insert USERS
------------------------------------------------------------ */
INSERT INTO wfei01.Users (NTID, FirstName, MiddleI, LastName, EmailAddress, Password)
VALUES
('01-HJPotter',   'Harry',    'J', 'Potter',   'hp@hw.edu', 'Hedwig'),
('02-RBWeasley',  'Ron',      'B', 'Weasley',  'rw@hw.edu', 'Scabbers'),
('03-HJGranger',  'Hermione', 'J', 'Granger',  'hg@hw.edu', 'Crookshanks'),
('10-Rlupin',     'Remus',    NULL,'Lupin',    'rl@hw.edu', 'moon'),
('11-Fflitwick',  'Filius',   NULL,'Flitwick', 'ff@hw.edu', NULL),
('16-Rhagrid',    'Rubeus',   NULL,'Hagrid',   'rh@hw.edu', 'BuckBeak');
GO

SELECT * FROM wfei01.Users ORDER BY NTID;
SELECT GETDATE() AS TimeStamp;
GO



/* ------------------------------------------------------------
2.	Insert COURSES
------------------------------------------------------------ */
INSERT INTO wfei01.Courses (CourseCode, CourseTitle, Faculty, OpenSeats)
VALUES
('DADA101', 'Defence Against the Dark Arts BASIC',        '10-Rlupin',    3),
('DADA201', 'Defence Against the Dark Arts INTERMEDIATE', '10-Rlupin',    2),
('DADA301', 'Defence Against the Dark Arts ADVANCED',     '10-Rlupin',    1),
('CHMS101', 'Charms BASIC',                               '11-Fflitwick', 2),
('CHMS201', 'Charms INTERMEDIATE',                        '11-Fflitwick', 0),
('CHMS301', 'Charms ADVANCED',                            '11-Fflitwick', 4),
('HOM101',  'History of Magic BASIC',                     NULL,          10);
GO

SELECT * FROM wfei01.Courses ORDER BY CourseId;
SELECT GETDATE() AS TimeStamp;
GO



/* ------------------------------------------------------------
3.	Insert LETTER GRADES
------------------------------------------------------------ */
INSERT INTO wfei01.LetterGrades (LetterGrade, Description)
VALUES
('O', 'Outstanding'),
('E', 'Exceeds Expectations'),
('A', 'Acceptable'),
('P', 'Poor'),
('D', 'Dreadful'),
('T', 'Troll');
GO

SELECT * FROM wfei01.LetterGrades ORDER BY LetterGradeId;
SELECT GETDATE() AS TimeStamp;
GO




/* ------------------------------------------------------------
4.	Insert COURSE GRADING
------------------------------------------------------------ */
INSERT INTO wfei01.CourseGrade ( LetterGradeId, CourseId, GradeValue)
VALUES
(1, 1,  95),
(2, 1,  90),
(3, 1,  80),
(4, 1,  70),
(5, 1,  60),
(6, 1,   0),
(1, 2, 100),
(2, 2,  90),
(3, 2,  85),
(4, 2,  75),
(5, 2,  64),
(6, 2,   0);
GO

SELECT * FROM wfei01.CourseGrade ORDER BY GradingScaleId;
SELECT GETDATE() AS TimeStamp;
GO




/* ------------------------------------------------------------
5.	Insert COURSE ENROLLMENT
------------------------------------------------------------ */
INSERT INTO wfei01.CourseEnrollment (StudentId, CourseId, FinalGrade)
VALUES
('01-HJPotter',  1, NULL),
('01-HJPotter',  4, NULL),
('03-HJGranger', 1, NULL),
('03-HJGranger', 4, NULL),
('02-RBWeasley', 1, NULL),
('02-RBWeasley', 7, NULL);
GO

SELECT * FROM wfei01.CourseEnrollment ORDER BY EnrollmentId;
SELECT GETDATE() AS TimeStamp;
GO




/* ------------------------------------------------------------
a)	Lupin has been fired. Assign his classes to Hagrid. Remove Lupin from the database.
------------------------------------------------------------ */
UPDATE wfei01.Courses
SET Faculty = '16-Rhagrid'
WHERE Faculty = '10-Rlupin';
GO

DELETE FROM wfei01.Users
WHERE NTID = '10-Rlupin';
GO

SELECT GETDATE() AS TimeStamp;
GO




/* ------------------------------------------------------------
b)	Harry has received a final grade of 96 in Defence Against the Dark Arts, and 91 in Charms.
------------------------------------------------------------ */
UPDATE wfei01.CourseEnrollment
SET FinalGrade = 96
WHERE StudentId = '01-HJPotter' AND CourseId = 1;
GO

UPDATE wfei01.CourseEnrollment
SET FinalGrade = 91
WHERE StudentId = '01-HJPotter' AND CourseId = 4;
GO

SELECT GETDATE() AS TimeStamp;
GO




/* ------------------------------------------------------------
c)	Ron has received a final grade of 91 in Defence Against the Dark Arts, and 88 in Charms
------------------------------------------------------------ */
UPDATE wfei01.CourseEnrollment
SET FinalGrade = 91
WHERE StudentId = '02-RBWeasley' AND CourseId = 1;
GO

INSERT INTO wfei01.CourseEnrollment (StudentId, CourseId, FinalGrade)
VALUES ('02-RBWeasley', 4, 88);
GO

SELECT GETDATE() AS TimeStamp;
GO




/* ------------------------------------------------------------
d)	Hermione has received a final grade of 92 in Defence Against the Dark Arts, and 99 in Charms.
------------------------------------------------------------ */
UPDATE wfei01.CourseEnrollment
SET FinalGrade = 92
WHERE StudentId = '03-HJGranger' AND CourseId = 1;
GO

UPDATE wfei01.CourseEnrollment
SET FinalGrade = 99
WHERE StudentId = '03-HJGranger' AND CourseId = 4;
GO

SELECT GETDATE() AS TimeStamp;
GO




/* ------------------------------------------------------------
e)	Enroll Harry in Intermediate Defence Against the Dark Arts.
------------------------------------------------------------ */
INSERT INTO wfei01.CourseEnrollment (StudentId, CourseId, FinalGrade)
VALUES ('01-HJPotter', 2, NULL);
GO

SELECT GETDATE() AS TimeStamp;
GO




/* ------------------------------------------------------------
f)	Enroll Hermione in Advanced Charms.
------------------------------------------------------------ */
INSERT INTO wfei01.CourseEnrollment (StudentId, CourseId, FinalGrade)
VALUES ('03-HJGranger', 6, NULL);
GO

SELECT GETDATE() AS TimeStamp;
GO



/* ------------------------------------------------------------
    provide a screenshot of all related tables, displaying the new data.
------------------------------------------------------------ */
SELECT * FROM wfei01.Users ORDER BY NTID;
SELECT * FROM wfei01.Courses ORDER BY CourseId;
SELECT * FROM wfei01.CourseEnrollment ORDER BY EnrollmentId;

SELECT GETDATE() AS TimeStamp;
GO




