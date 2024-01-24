-- Question 1
SELECT DISTINCT(fname) FROM faculty;
-- +--------------+
-- | fname        |
-- +--------------+
-- | Dr Sailesh   |
-- | Dr Mukesh    |
-- | Dr Mohan     |
-- | Dr Anupam    |
-- | Dr Sanjay    |
-- | Dr Dhananjay |
-- | Dr Sunidhi   |
-- | Dr Priyanka  |
-- | Dr Anoushka  |
-- +--------------+
-- 9 rows in set (0.00 sec)

-- Question 2
SELECT DISTINCT(dname) FROM department;
-- +------------------+
-- | dname            |
-- +------------------+
-- | Computer Science |
-- | Mathematics      |
-- | History          |
-- | Physics          |
-- | Business         |
-- | Electronics      |
-- | Arts             |
-- | Commerce         |
-- +------------------+
-- 8 rows in set (0.00 sec)

-- Question 3
SELECT fname FROM faculty AS f, teaches AS t WHERE f.fid = t.fid AND t.cid = 1;
-- +-------------+
-- | fname       |
-- +-------------+
-- | Dr Sailesh  |
-- | Dr Anoushka |
-- +-------------+
-- 2 rows in set (0.00 sec)

-- Question 4
SELECT sname FROM student AS s, takes AS t WHERE s.sid = t.sid GROUP BY sname;
-- +----------------+
-- | sname          |
-- +----------------+
-- | John Doe       |
-- | Jane Smith     |
-- | Mike Johnson   |
-- | Emily White    |
-- | Alex Brown     |
-- | Rachel Green   |
-- | Chris Evans    |
-- | Anna Taylor    |
-- | David Lee      |
-- | Sophia Kim     |
-- | Matthew Davis  |
-- | Olivia Miller  |
-- | Daniel Wilson  |
-- | Emma Carter    |
-- | Ethan Clark    |
-- | Isabella Lewis |
-- | Michael Hall   |
-- | Ava Allen      |
-- | Andrew Adams   |
-- | Grace Moore    |
-- +----------------+
-- 20 rows in set (0.00 sec)

-- Question 5
SELECT sname FROM student AS s, takes AS t WHERE s.sid = t.sid GROUP BY sname HAVING COUNT(cid) > 1;
-- +--------------+
-- | sname        |
-- +--------------+
-- | John Doe     |
-- | Jane Smith   |
-- | Mike Johnson |
-- | Emily White  |
-- | Alex Brown   |
-- +--------------+
-- 5 rows in set (0.00 sec)

-- Question 6
SELECT sname FROM student AS s, takes AS t WHERE s.sid = t.sid GROUP BY sname HAVING COUNT(cid) = 3;
-- Empty set (0.00 sec)

-- Question 7
SELECT sname FROM student AS s WHERE s.sid NOT IN (SELECT takes.sid FROM takes);
-- +-------------------+
-- | sname             |
-- +-------------------+
-- | Cosimo de' Medici |
-- +-------------------+
-- 1 row in set (0.00 sec)

-- Question 8
SELECT * FROM department WHERE budget = (SELECT MAX(budget) FROM department);
-- +-----+-------------+----------+-----------+
-- | did | dname       | building | budget    |
-- +-----+-------------+----------+-----------+
-- |   6 | Mathematics | C        | 190000.00 |
-- +-----+-------------+----------+-----------+
-- 1 row in set (0.00 sec)

-- Question 9
WITH fac_count (fid, fname, course_count) 
    AS (SELECT t.fid, f.fname, count(cid) 
    FROM teaches AS t, faculty AS f WHERE f.fid = t.fid 
    GROUP BY fid ORDER BY count(cid) ASC) 
SELECT fname FROM fac_count WHERE course_count = (SELECT MAX(course_count) FROM fac_count);
-- +-------------+
-- | fname       |
-- +-------------+
-- | Dr Sailesh  |
-- | Dr Mohan    |
-- | Dr Priyanka |
-- +-------------+
-- 3 rows in set (0.00 sec)

-- Question 10
WITH tab (building, dept_count) 
    AS (SELECT building, count(dname) 
    FROM department 
    GROUP BY building 
    ORDER BY COUNT(dname) ASC)
SELECT building FROM tab WHERE dept_count = (SELECT MAX(dept_count) FROM tab);
-- +----------+
-- | building |
-- +----------+
-- | A        |
-- +----------+
-- 1 row in set (0.00 sec)