----------1
SELECT COUNT(*) FROM course;

----------2
WITH course_count (cid, student_count) AS (
    SELECT cid, COUNT(*) FROM takes GROUP BY cid HAVING COUNT(*) > 2) 
    SELECT COUNT(*) FROM course_count;

----------3
WITH course_count (cid, student_count) AS (
    SELECT cid, COUNT(sid) FROM takes GROUP BY cid) 
    SELECT cid, student_count FROM course_count 
    WHERE student_count = (SELECT MAX(student_count) FROM course_count);

----------4
WITH course_count (fid, fname, c_count) AS (
    SELECT f.fid, f.fname, COUNT(*) 
    FROM faculty AS f, teaches AS t
    WHERE t.fid = f.fid 
    GROUP BY f.fid, f.fname HAVING COUNT(*) > 2)
SELECT fid, fname FROM course_count;

----------5
WITH student_count (fid, fname, s_count) AS (
    SELECT f.fid, f.fname, COUNT(*)
    FROM advisor AS a, faculty AS f
    WHERE f.fid = a.fid
    GROUP BY fid, fname 
    HAVING COUNT(*) > 4)
SELECT fname FROM student_count;

----------6
WITH fac_info (fid, fname, cid, credits) AS (
    SELECT t.fid, f.fname, c.cid, c.credit
    FROM teaches AS t, faculty AS f, course AS c
    WHERE c.cid = t.cid AND t.fid = f.fid
    )
SELECT fid, fname FROM fac_info WHERE credits = (SELECT MAX(credits) FROM fac_info) GROUP BY fid;

----------7
WITH credit_info (fid, fname, total_credits) AS (
    SELECT t.fid, f.fname, SUM(credit)
    FROM teaches AS t, course AS c, faculty AS f
    WHERE c.cid = t.cid AND t.fid = f.fid
    GROUP BY t.fid, f.fname
    )
SELECT fname FROM credit_info WHERE total_credits = (SELECT MAX(total_credits) FROM credit_info);

-----------8
NULL

-----------9
WITH fac_info (fid, fname, stud_count) AS (
    SELECT a.fid, f.fname, count(*) 
    FROM faculty AS f, advisor AS a
    WHERE f.fid = a.fid
    GROUP BY a.fid, f.fname
)

SELECT * FROM fac_info WHERE stud_count = (SELECT MAX(stud_count) FROM fac_info);

-----------10 
-- (What is the difference between these 2 queries?)

-- Query number 1
-- WITH student_info (sid, sname, did) AS (
--     SELECT s.sid, s.sname, c.did 
--     FROM student AS s, takes AS t, course AS c
--     WHERE s.sid = t.cid AND t.cid = c.cid
-- )

-- SELECT sname FROM student_info GROUP BY sid, sname HAVING COUNT(did) >= 2;

-- Query number 2
SELECT s.sname 
FROM student s, takes t, course c 
WHERE s.sid = t.sid AND t.cid = c.cid 
GROUP BY s.sid, s.sname 
HAVING COUNT(c.did) >= 2;

----------11
SELECT s.sname 
FROM student s, takes t, course c 
WHERE s.sid = t.sid AND t.cid = c.cid 
GROUP BY s.sid, s.sname 
HAVING COUNT(c.did) = 1;

---------12

-- SELECT ta.sid, ta.cid, te.fid AS teaching_faculty, ad.fid AS advising_faculty 
-- FROM takes ta, teaches te, advisor ad WHERE ta.cid = te.cid AND ad.sid = ta.sid;


-- SELECT st.sid, st.sname, tab.teaching_faculty, tab.advising_faculty 
-- FROM student st, (SELECT ta.sid, ta.cid, te.fid AS teaching_faculty, ad.fid AS advising_faculty 
-- FROM takes ta, teaches te, advisor ad WHERE ta.cid = te.cid AND ad.sid = ta.sid) tab 
-- WHERE st.sid = tab.sid;


-- SELECT ta.sid, st.sname, ta.cid, te.fid AS teaching_faculty, ad.fid AS advising_faculty 
-- FROM takes ta, student st, teaches te, advisor ad WHERE ta.cid = te.cid AND ad.sid = ta.sid AND st.sid = ta.sid;

WITH student_info (sid, sname, teaching_faculty, advising_faculty) AS (
    SELECT ta.sid, st.sname, te.fid AS teaching_faculty, ad.fid AS advising_faculty 
    FROM takes ta, student st, teaches te, advisor ad 
    WHERE ta.cid = te.cid AND ad.sid = ta.sid AND st.sid = ta.sid
)

SELECT DISTINCT(sname) FROM student_info WHERE teaching_faculty = advising_faculty;

-----------13
WITH student_info (sid, sname, teaching_faculty, advising_faculty) AS (
    SELECT ta.sid, st.sname, te.fid AS teaching_faculty, ad.fid AS advising_faculty 
    FROM takes ta, student st, teaches te, advisor ad 
    WHERE ta.cid = te.cid AND ad.sid = ta.sid AND st.sid = ta.sid
)

SELECT DISTINCT(sname) FROM student_info 
    WHERE sname NOT IN (
        SELECT DISTINCT(sname) 
        FROM student_info 
        WHERE teaching_faculty = advising_faculty
    );

-----------14
-- SELECT t.sid, c.cid, d.did FROM takes t, course c, department d WHERE t.cid = c.cid AND c.did = d.did;

-- SELECT t.sid, d.did FROM takes t, course c, department d WHERE t.cid = c.cid AND c.did = d.did;

-- SELECT t.sid, d.did, d.dname FROM takes t, course c, department d WHERE t.cid = c.cid AND c.did = d.did;

WITH department_info (did, dname, total_students) AS (
    SELECT d.did, d.dname, count(*) total_students 
    FROM takes t, course c, department d 
    WHERE t.cid = c.cid AND c.did = d.did 
    GROUP BY did
)

SELECT dname FROM department_info WHERE total_students = (SELECT MAX(total_students) FROM department_info);

-----------15
-- SELECT t.fid, d.did, d.dname FROM teaches t, course c, department d WHERE t.cid = c.cid AND c.did = d.did;

WITH department_info (did, dname, total_faculty) AS (
    SELECT d.did, d.dname, count(*) total_faculty
    FROM teaches t, course c, department d 
    WHERE t.cid = c.cid AND c.did = d.did 
    GROUP BY did
)

SELECT dname FROM department_info WHERE total_faculty = (SELECT MAX(total_faculty) FROM department_info);

------------16
-- WITH alias AS (
--     SELECT t.fid, t.cid, c.cname, d.did, d.dname 
--     FROM teaches t, course c, department d
--     WHERE t.cid = c.cid AND c.did = d.did AND (dname = "Computer Science" OR dname = "Electronics")
-- )

-- SELECT * FROM alias;
WITH course_info AS (
    SELECT t.fid, t.cid, c.cname, d.did, d.dname 
    FROM teaches t, course c, department d
    WHERE t.cid = c.cid AND c.did = d.did AND d.dname IN ("Computer Science", "Electronics")
)

SELECT t1.cname course1, t2.cname course2 FROM course_info t1, course_info t2 WHERE t1.fid = t2.fid AND t1.cid < t2.cid;

-------------17
SELECT s.sname FROM student s, takes t1, takes t2 
WHERE s.sid = t1.sid    
  AND s.sid = t2.sid 
  AND t1.cid = 1 
  AND t2.cid = 2;

-------------18
WITH department_info AS (
    SELECT f.did, d.dname, AVG(f.salary) AS avg_salary FROM faculty f, department d WHERE f.did = d.did GROUP BY f.did, d.dname
)

SELECT dname FROM department_info WHERE avg_salary = (SELECT MAX(avg_salary) FROM department_info);

------------19
WITH department_info AS (
    SELECT f.did, d.dname, AVG(f.salary) AS avg_salary FROM faculty f, department d WHERE f.did = d.did GROUP BY f.did, d.dname
)

SELECT dname FROM department_info WHERE avg_salary = (SELECT MIN(avg_salary) FROM department_info);

------------20
WITH dept_info AS ( 
    SELECT s.age, d.dname FROM student s, department d WHERE s.did = d.did
)
SELECT DISTINCT dname FROM dept_info WHERE age = (SELECT MIN(age) FROM dept_info);