-- Optional synthetic benchmark fixture. Run only in a disposable database
-- after schema.sql and seed.sql. Creates 5,000 students, sections, and
-- registrations so the planner has enough rows for a meaningful index demo.
WITH new_students AS (
    INSERT INTO student
        (matric_number, first_name, last_name, email, department_id, admission_year)
    SELECT 'BENCH-' || LPAD(g::TEXT, 5, '0'),
           'Synthetic', 'Student ' || g,
           'bench' || LPAD(g::TEXT, 5, '0') || '@example.invalid',
           1, 2025
    FROM generate_series(1, 5000) AS g
    RETURNING student_id, matric_number
),
new_offerings AS (
    INSERT INTO course_offering
        (course_id, term_id, section_code, lecturer_name, capacity, seats_remaining)
    SELECT 201, 301, 'B' || LPAD(g::TEXT, 5, '0'),
           'Synthetic Benchmark', 1, 0
    FROM generate_series(1, 5000) AS g
    RETURNING offering_id, section_code
)
INSERT INTO enrollment (student_id, offering_id, status)
SELECT s.student_id, o.offering_id, 'registered'
FROM new_students s
JOIN new_offerings o
  ON s.matric_number = 'BENCH-' || SUBSTRING(o.section_code FROM 2);

ANALYZE enrollment;
