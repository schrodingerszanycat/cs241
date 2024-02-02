-- Question 1
SELECT COUNT(*) FROM course;
-- +----------+
-- | COUNT(*) |
-- +----------+
-- |       10 |
-- +----------+
-- 1 row in set (0.01 sec)

WITH course_count (cid, student_count) 
    AS (SELECT cid, COUNT(*) FROM takes GROUP BY cid HAVING COUNT(*) > 2) 
    SELECT COUNT(cid) FROM course_count;
-- +------------+
-- | COUNT(cid) |
-- +------------+
-- |          5 |
-- +------------+
-- 1 row in set (0.00 sec)


WITH course_count (cid, student_count) 
    AS (SELECT cid, COUNT(sid) FROM takes GROUP BY cid) 
    SELECT cid, student_count FROM course_count 
    WHERE student_count = (SELECT MAX(student_count) FROM course_count);


SELECT f.fid, f.fname, t.cid FROM faculty AS f, teaches AS t WHERE t.fid = f.fid;

WITH course_count (fid, fname, c_count) 
    AS (SELECT f.fid, f.fname, t.cid FROM faculty AS f, teaches AS t WHERE t.fid = f.fid AND GROUP BY cid HAVING COUNT(*) > 2)
    SELECT fname FROM course_count;