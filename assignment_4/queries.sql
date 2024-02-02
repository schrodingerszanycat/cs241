SELECT COUNT(*) FROM course;

----------

WITH course_count (cid, student_count) AS (
    SELECT cid, COUNT(*) FROM takes GROUP BY cid HAVING COUNT(*) > 2) 
    SELECT COUNT(*) FROM course_count;

----------

WITH course_count (cid, student_count) AS (
    SELECT cid, COUNT(sid) FROM takes GROUP BY cid) 
    SELECT cid, student_count FROM course_count 
    WHERE student_count = (SELECT MAX(student_count) FROM course_count);

---------

WITH course_count (fid, fname, c_count) AS (
    SELECT f.fid, f.fname, COUNT(*) 
    FROM faculty AS f, teaches AS t
    WHERE t.fid = f.fid 
    GROUP BY f.fid, f.fname HAVING COUNT(*) > 2)
SELECT fid, fname FROM course_count;

----------

WITH student_count (fid, fname, s_count) AS (
    SELECT f.fid, f.fname, COUNT(*)
    FROM advisor AS a, faculty AS f
    WHERE f.fid = a.fid
    GROUP BY fid, fname 
    HAVING COUNT(*) > 4)
SELECT fname FROM student_count;

-------------

WITH fac_info (fid, fname, cid, credits) AS (
    SELECT t.fid, f.fname, c.cid, c.credit
    FROM teaches AS t, faculty AS f, course AS c
    WHERE c.cid = t.cid AND t.fid = f.fid
    )
SELECT fid, fname FROM fac_info WHERE credits = (SELECT MAX(credits) FROM fac_info) GROUP BY fid;

-------- Trial 7

WITH fac_info (fid, fname, cid, total_credits) AS (
    SELECT t.fid, f.fname, c.cid, SUM(c.credit)
    FROM teaches AS t, faculty AS f, course AS c
    WHERE c.cid = t.cid AND t.fid = f.fid
    GROUP BY t.fid, f.fname, c.cid
    )
SELECT * FROM fac_info WHERE total_credits = (SELECT MAX(total_credits) FROM fac_info);

WITH fac_info AS (
    SELECT t.fid, f.fname, SUM(c.credit) AS total_credits
    FROM teaches AS t
    JOIN faculty AS f ON t.fid = f.fid
    JOIN course AS c ON c.cid = t.cid
    GROUP BY t.fid, f.fname
)

SELECT fid, fname
FROM fac_info
WHERE total_credits = (SELECT MAX(total_credits) FROM fac_info);


-- to print aggregated table
WITH fac_info (fid, fname, cid, credits) AS (
    SELECT t.fid, f.fname, c.cid, c.credit
    FROM teaches AS t, faculty AS f, course AS c
    WHERE c.cid = t.cid AND t.fid = f.fid
    GROUP BY t.fid, f.fname, c.cid
    )

SELECT * FROM fac_info GROUP BY fid;

WITH fac_info (fid, fname, cid, credit) AS (
    SELECT t.fid, f.fname, c.cid, c.credit
    FROM teaches AS t, faculty AS f, course AS c
    WHERE c.cid = t.cid AND t.fid = f.fid
    GROUP BY t.fid, f.fname, c.cid
    )

SELECT fid, SUM(credit) AS total_credits FROM fac_info GROUP BY fid;

------8
NULL

----- 9

WITH fac_info (fid, fname, stud_count) AS (
    SELECT a.fid, f.fname, count(*) 
    FROM faculty AS f, advisor AS a
    WHERE f.fid = a.fid
    GROUP BY a.fid, f.fname
)

SELECT * FROM fac_info WHERE stud_count = (SELECT MAX(stud_count) FROM fac_info);

---------10

-- WITH department_info (did, dname, sid, sname) AS (
--     SELECT c.did, d.dname, 
-- )