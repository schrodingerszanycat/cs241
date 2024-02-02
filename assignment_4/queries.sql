SELECT COUNT(*) FROM course;


WITH course_count (cid, student_count) 
    AS (SELECT cid, COUNT(*) FROM takes GROUP BY cid HAVING COUNT(*) > 2) 
    SELECT COUNT(cid) FROM course_count;


WITH course_count (cid, student_count) 
    AS (SELECT cid, COUNT(sid) FROM takes GROUP BY cid) 
    SELECT cid, student_count FROM course_count 
    WHERE student_count = (SELECT MAX(student_count) FROM course_count);


WITH course_count (fid, fname, c_count) 
    AS (SELECT f.fid, f.fname, COUNT(*) 
    FROM faculty AS f, teaches AS t
    WHERE t.fid = f.fid 
    GROUP BY f.fid, f.fname HAVING COUNT(*) > 2)
SELECT fid, fname FROM course_count;


WITH student_count (fid, fname, s_count)
    AS (SELECT f.fid, f.fname, COUNT(*)
    FROM advisor AS a, faculty AS f
    WHERE f.fid = a.fid
    GROUP BY fid, fname 
    HAVING COUNT(*) > 4)
SELECT fname FROM student_count;





WITH fac_info (fid, fname, cid, credit_count) 
    AS (SELECT t.fid, f.fname, c.cid, c.credit
    FROM teaches AS t, faculty AS f, course AS C
    WHERE c.cid = t.cid AND t.fid = f.fid
    )
SELECT * FROM fac_info;