-- Run after portfolio-1 schema and seed. Save actual output as evidence.

-- 1. Student course history and assessed performance.
SELECT s.matric_number, c.course_code, c.title, t.academic_year, t.term_name,
       str.total_percent, str.illustrative_grade_point
FROM student s
JOIN enrollment e ON e.student_id = s.student_id
JOIN course_offering o ON o.offering_id = e.offering_id
JOIN course c ON c.course_id = o.course_id
JOIN academic_term t ON t.term_id = o.term_id
LEFT JOIN student_term_results str
  ON str.student_id = s.student_id
 AND str.term_id = o.term_id
 AND str.course_code = c.course_code
WHERE s.matric_number = 'SYN-2024-001'
ORDER BY t.starts_on DESC, c.course_code;

-- 2. Current registration count and remaining capacity by section.
SELECT o.offering_id, c.course_code, o.section_code, o.capacity,
       COUNT(e.enrollment_id) FILTER (WHERE e.status = 'registered') AS registered_count,
       o.seats_remaining
FROM course_offering o
JOIN course c ON c.course_id = o.course_id
LEFT JOIN enrollment e ON e.offering_id = o.offering_id
GROUP BY o.offering_id, c.course_code, o.section_code, o.capacity, o.seats_remaining
ORDER BY c.course_code;

-- 3. Query-plan evidence. Run separately and retain the real output.
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT e.student_id, e.offering_id, e.registered_at
FROM enrollment e
WHERE e.offering_id = 403
  AND e.status = 'registered'
ORDER BY e.student_id;

-- 4. For a meaningful index comparison, use a fresh disposable database,
-- run benchmark_fixture.sql, then execute this same plan query twice:
-- once after dropping the index, then after recreating it. Compare the actual
-- rows, buffers, and execution time from your environment.
-- DROP INDEX enrollment_offering_status_idx;
-- ANALYZE enrollment;
-- EXPLAIN (ANALYZE, BUFFERS)
-- SELECT student_id FROM enrollment
-- WHERE offering_id = (SELECT MAX(offering_id) FROM course_offering)
--   AND status = 'registered'
-- ORDER BY student_id;
-- CREATE INDEX enrollment_offering_status_idx
--     ON enrollment (offering_id, status, student_id);
-- ANALYZE enrollment;
-- EXPLAIN (ANALYZE, BUFFERS)
-- SELECT student_id FROM enrollment
-- WHERE offering_id = (SELECT MAX(offering_id) FROM course_offering)
--   AND status = 'registered'
-- ORDER BY student_id;

-- Explain in the portfolio that an index may improve selective reads while
-- increasing write cost and storage. Base any conclusion on captured plans.
