-- What is the enrollment across courses?

-- SELECT course_id, COUNT(student_id) AS student_count
-- FROM enrollments
-- GROUP BY course_id;

-- 1000 learners took a combination of 10 courses. Course 6 has the lowest enrollment (106 learners) and Course 0 has the highest enrollment (898 learners). 



-- Join datasets to be able to see the name of each course next to the course number. Use this table as reference.

-- WITH count_course AS (
-- SELECT course_id, count(course_id) AS counts FROM enrollments
-- GROUP BY 1
-- ORDER BY 1
-- )
-- 
-- SELECT a.course_id, a.counts, b.title, b.difficulty, b.role FROM count_course AS a
-- JOIN courses AS b
-- ON a.course_id=b.id
-- ORDER BY counts DESC

-- Each of these courses can be categorized in different ways. Student enrollment based on course title is shown using this code. 
-- Enrollment records could also be categorized based on difficulty (beginner, intermediate, and advanced) or based on course persona/role (developer, manager, or DevOps engineer).



-- To compare course enrollment using course titles, let's compare percentages.
-- 
-- SELECT 
--     course_id, 
--     COUNT(student_id) AS student_count,
--     (COUNT(student_id) * 100.0 / total_enrollments) AS student_percentage
-- FROM enrollments,
--      (SELECT COUNT(student_id) AS total_enrollments FROM enrollments) AS total
-- GROUP BY course_id;

-- Courses 0 (898 learners), 1 (774 learners), 5 (547 learners), and 2 (525 learners) are the most popular courses. 




-- How long did learners stay in each of the four popular courses? I divided the duration lengths into ranges of 5 days to compare.

-- WITH date_diffs AS (
--     SELECT 
--         julianday(end_date) - julianday(start_date) AS date_difference_in_days
--     FROM 
--         enrollments
--     WHERE 
--         course_id = 0
-- )


-- What is the average, range, median, and first quarter percentile? 
-- The code shown here is only for course 0. The response has been calculated for each of the four popular courses.

-- WITH date_diffs AS (
--     SELECT 
--         julianday(end_date) - julianday(start_date) AS date_difference_in_days
--     FROM 
--         enrollments
--     WHERE 
--         course_id = 0
-- ),
-- 
-- 
-- ordered_diffs AS (
--     SELECT 
--         date_difference_in_days,
--         ROW_NUMBER() OVER (ORDER BY date_difference_in_days) AS row_num,
--         COUNT(*) OVER () AS total_count
--     FROM 
--         date_diffs
-- )
-- 
-- 
-- SELECT 
--     AVG(date_difference_in_days) AS mean,
--     MIN(date_difference_in_days) AS min,
--     MAX(date_difference_in_days) AS max,
--     (
--         SELECT date_difference_in_days
--         FROM ordered_diffs
--         WHERE row_num = CAST(0.25 * total_count AS INTEGER) + 1
--     ) AS percentile_25,
--     (
--         SELECT date_difference_in_days
--         FROM ordered_diffs
--         WHERE row_num = (total_count + 1) / 2
--     ) AS median
-- FROM 
--   date_diffs;
  
 -- Calcualted mean, min, max, 25th percentile, median:
 -- Course 0: 19.3, 1, 90, 9, 16
 -- Course 1: 19, 1, 71, 9, 17
 -- Course 5: 18.7, 1, 73, 9, 16
 -- Course 2: 19.3, 1, 90, 9, 16
 
 -- Courses 0, 1, and 2 have learners in those classes for the duration of 1-30 days. Course 5 1- 34 days. 
 -- This is important for understanding associated costs related to the training such as provisioning labs. Also, having an estimate can learners know how long it takes others to complete each course.
 
 
 
 
 
 
-- One possible factor impacting how long it takes to complete a course is how many courses learners are taking or have taken.
-- How many learners are taking one course? How many are taking or have taken more than one course?
 
--  SELECT count_courses, COUNT(count_courses) AS number_of_students FROM 
-- 	(
-- 	SELECT student_id, COUNT(student_id) AS count_courses FROM enrollments
-- 	GROUP BY 1
-- 	ORDER BY 2 DESC
-- 	)
-- GROUP BY 1
-- ORDER BY 1
 
-- Only 65 learners took one course, the rest took more than one course, with three to six courses being the most common 
-- 



-- Enrollment records could also be categorized based on difficulty (beginner, intermediate, and advanced) or based on course persona/role (developer, manager, or DevOps engineer).

-- SELECT 
--     c.difficulty,
--     COUNT(e.id) AS enrollment_count
-- FROM 
--     enrollments e
-- JOIN 
--     courses c ON e.course_id = c.id
-- GROUP BY 
--     c.difficulty
-- ORDER BY 
--     c.difficulty;

-- Learners took intermediate level courses the most (2001 learners), then advanced courses (1551 learners), then beginner courses (960). 
-- This is relatively aligned with course offerings. Intermediate and advanced levels have four courses each, while beginner has two. Such alignment between what is needed by learners and what is developed and offered is necessary. 

-- SELECT 
--     c.role,
--     COUNT(e.id) AS enrollment_count
-- FROM 
--     enrollments e
-- JOIN 
--     courses c ON e.course_id = c.id
-- GROUP BY 
--     c.role
-- ORDER BY 
--     c.role;
	
-- 2131 learners took the four developer courses, 1301 learners took the four manager courses, and 1080 took the two DevOps courses. 
-- That is an average of 532 learners per deveeloper course, 325 learners per manager course, and 540 learners per DevOps course. 
-- Based on this insight, I would ask more questions about developing intermediate DevOps courses as a possible area of learner interest.


--Additional questions about the context: 
-- Are any of the courses mandatory or prerequisites? 
-- What are some goals related to enrollment (reduce the time students are in a course, increase the variety of offerings they take, ...)?
-- Could recategorizing or renaming the personas impact what learners choose to take?
