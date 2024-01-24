-- mysql> SELECT DISTINCT(fname) FROM faculty;
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

-- mysql> SELECT DISTINCT(dname) FROM department;
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

-- mysql> SELECT fname FROM faculty AS f, teaches AS t WHERE f.fid = t.fid AND t.cid = 1;
-- +-------------+
-- | fname       |
-- +-------------+
-- | Dr Sailesh  |
-- | Dr Anoushka |
-- +-------------+
-- 2 rows in set (0.00 sec)

-- mysql> SELECT sname FROM student AS s, takes AS t WHERE s.sid = t.sid GROUP BY sname;
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

-- mysql> SELECT sname FROM student AS s, takes AS t WHERE s.sid = t.sid GROUP BY sname HAVING COUNT(cid) > 1;
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

-- mysql> SELECT sname FROM student AS s, takes AS t WHERE s.sid = t.sid GROUP BY sname HAVING COUNT(cid) = 3;
-- Empty set (0.00 sec)

-- mysql> SELECT sname FROM student AS s WHERE s.sid NOT IN (SELECT takes.sid FROM takes);
-- +-------------------+
-- | sname             |
-- +-------------------+
-- | Cosimo de' Medici |
-- +-------------------+
-- 1 row in set (0.00 sec)

-- mysql> SELECT *
--     -> FROM department
--     -> WHERE budget = (SELECT MAX(budget) FROM department);
-- +-----+-------------+----------+-----------+
-- | did | dname       | building | budget    |
-- +-----+-------------+----------+-----------+
-- |   6 | Mathematics | C        | 190000.00 |
-- +-----+-------------+----------+-----------+
-- 1 row in set (0.00 sec)


WITH faculty_course_count AS (
    SELECT f.fname, COUNT(t.cid) AS subject_count
    FROM faculty AS f, teaches AS t
    WHERE t.fid = f.fid
    GROUP BY f.fname
)

SELECT ALL fname 
FROM faculty_course_count
WHERE subject_count = (SELECT MAX(subject_count) FROM faculty_course_count);
