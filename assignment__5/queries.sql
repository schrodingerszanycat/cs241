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