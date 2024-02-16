-- 1
SELECT COUNT(*) n_courses, d.did 
FROM course c, dpartment d 
WHERE c.did = d.did 
GROUP BY d.did 
HAVING COUNT(c.cid) >= 2;

-- 2
SELECT COUNT(*) n_courses, d.did 
FROM course c, department d 
WHERE c.did = d.did 
GROUP BY d.did 
HAVING COUNT(c.cid) <= 2;

-- 3
WITH dept_info AS (
    SELECT d.did, d.dname , COUNT(*) n_courses
    FROM course c, department d 
    WHERE c.did = d.did 
    GROUP BY d.did
)

SELECT did, dname FROM dept_info WHERE n_courses = (SELECT MAX(n_courses) FROM dept_info);

-- 4
WITH dept_info AS (
    SELECT d.did, d.dname , COUNT(*) n_courses
    FROM course c, department d 
    WHERE c.did = d.did 
    GROUP BY d.did
)

SELECT did, dname FROM dept_info WHERE n_courses = (SELECT MIN(n_courses) FROM dept_info);

-- 5
SELECT cname FROM course 
WHERE credit = (SELECT MAX(credit) FROM course WHERE credit NOT IN (SELECT MAX(credit) FROM course));

-- Alternate query

SELECT cname FROM course 
WHERE credit = (
    SELECT DISTINCT credit FROM course t1 WHERE (SELECT COUNT(DISTINCT credit) FROM course t2 WHERE t2.credit < t1.credit) = 1
);

-- 6
SELECT f.fname, a.title FROM faculty f, advisor a WHERE f.fid = a.fid AND a.title LIKE '%AI%';

-- 7
SELECT f.fname FROM faculty f WHERE f.fid NOT IN (SELECT t.fid FROM teaches t);

-- 8
SELECT faculty.fid, faculty.fname
FROM faculty
WHERE NOT EXISTS (
    SELECT course.cid FROM course, teaches
    WHERE faculty.fid = teaches.fid AND course.cid = teaches.cid
    AND course.did = faculty.did
) AND EXISTS (
    SELECT course.cid FROM course, teaches
    WHERE faculty.fid = teaches.fid AND course.cid = teaches.cid
    AND course.did != faculty.did
)
UNION
SELECT faculty.fid, faculty.fname
FROM faculty
WHERE NOT EXISTS (
    SELECT course.cid FROM course, teaches
    WHERE faculty.fid = teaches.fid AND course.cid = teaches.cid
    AND course.did != faculty.did
) AND EXISTS (
    SELECT course.cid FROM course, teaches
    WHERE faculty.fid = teaches.fid AND course.cid = teaches.cid
    AND course.did = faculty.did
);

-- 9
SELECT faculty.fid, faculty.fname
FROM faculty
WHERE NOT EXISTS (
    SELECT course.cid FROM course, teaches
    WHERE faculty.fid = teaches.fid AND course.cid = teaches.cid
    AND course.did != faculty.did
) AND EXISTS (
    SELECT course.cid FROM course, teaches
    WHERE faculty.fid = teaches.fid AND course.cid = teaches.cid
    AND course.did = faculty.did
);

-- 10
SELECT faculty.fid, faculty.fname
FROM faculty
WHERE NOT EXISTS (
    SELECT course.cid FROM course, teaches
    WHERE faculty.fid = teaches.fid AND course.cid = teaches.cid
    AND course.did = faculty.did
) AND EXISTS (
    SELECT course.cid FROM course, teaches
    WHERE faculty.fid = teaches.fid AND course.cid = teaches.cid
    AND course.did != faculty.did
);

-- 11
WITH student_info (avg_age, cid) AS (
    SELECT AVG(s.age), t.cid FROM student s, takes t WHERE s.sid = t.sid GROUP BY t.cid
)
SELECT cid, avg_age FROM student_info WHERE avg_age = (SELECT MIN(avg_age) FROM student_info);

-- CREATE TABLE marks (
--     sid INT,
--     cid INT,
--     marks INT,
--     CONSTRAINT PK_marks PRIMARY KEY (sid, cid),
--     FOREIGN KEY (sid) REFERENCES student(sid),
--     FOREIGN KEY (cid) REFERENCES course(cid)
-- );

-- INSERT INTO marks (sid, cid, marks) VALUES
-- (1, 1, 100),
-- (11, 1, 60),
-- (1, 2, 70),
-- (2, 2, 70),
-- (12, 2, 70),
-- (2, 3, 60),
-- (3, 3, 55),
-- (13, 3, 80),
-- (3, 4, 75),
-- (4, 4, 50),
-- (14, 4, 40),
-- (4, 5, 30),
-- (5, 5, 20),
-- (15, 5, 55),
-- (5, 6, 20),
-- (6, 6, 15),
-- (16, 6, 10),
-- (7, 7, 75),
-- (17, 7, 80),
-- (8, 8, 60),
-- (18, 8, 50),
-- (9, 9, 35),
-- (19, 9, 50),
-- (10, 10, 85),
-- (20, 10, 90);

-- 12
WITH student_info AS (SELECT sid, SUM(marks) marks_sum FROM marks GROUP BY sid)
SELECT b.sid, b.sname, a.marks_sum 
FROM student_info a, student b 
WHERE a.sid = b.sid AND a.marks_sum = (SELECT MAX(marks_sum) FROM student_info);

-- 13
WITH student_info AS (
    SELECT cid, COUNT(*) n_students FROM marks WHERE marks > 50 GROUP BY cid
)
SELECT st.cid, c.cname 
FROM student_info st, course c 
WHERE st.cid = c.cid AND st.n_students = (SELECT MAX(n_students) FROM student_info);

-- 14 
-- WITH student_info AS (
--     SELECT cid, COUNT(*) n_students FROM marks WHERE marks = 70 GROUP BY cid
-- )
-- SELECT st.cid, c.cname FROM student_info st, course c 
-- WHERE st.cid = c.cid AND st.n_students IN (SELECT COUNT(*) n_students FROM marks GROUP BY cid);

SELECT marks.cid, course.cname
FROM marks, course
WHERE marks.cid = course.cid
GROUP BY cid
HAVING MIN(marks) = 70 AND MAX(marks) = 70;

-- 15
SELECT student.sid, student.sname, AVG(marks) AS avg_marks, 
CASE
    WHEN AVG(marks) >= 80 THEN "AA"
    WHEN AVG(marks) >= 60 THEN "AB"
    WHEN AVG(marks) >= 40 THEN "BB"
    WHEN AVG(marks) >= 20 THEN "BC"
    ELSE "F"
END AS grade
FROM marks, student
WHERE student.sid = marks.sid
GROUP BY sid;

-- 16
DELIMITER //
CREATE FUNCTION get_instructor_count(dept_name VARCHAR(255))
RETURNS INT DETERMINISTIC
BEGIN
  DECLARE instructor_count INT;
  SELECT COUNT(*) INTO instructor_count
  FROM faculty f, department d
  WHERE f.did = d.did 
  AND d.dname = dept_name;
  RETURN instructor_count;
END //
DELIMITER ; 

-- 17
SELECT * FROM department WHERE get_instructor_count(dname) >= 2;

-- 18
DELIMITER //
CREATE FUNCTION get_faculty_count_by_salary(salary NUMERIC(8, 2)) 
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE faculty_count INT;
    SELECT COUNT(*) INTO faculty_count FROM faculty
        WHERE faculty.salary = salary;
    RETURN faculty_count;
END //
DELIMITER ;

-- 19
SELECT get_faculty_count_by_salary(100) AS salary_faculty_count;

-- 20
SELECT * FROM faculty WHERE get_faculty_count_by_salary(salary) >= 2;








