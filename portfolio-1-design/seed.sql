-- Synthetic teaching data only; no real student information.
INSERT INTO department (department_id, department_code, department_name) VALUES
  (1, 'MIT', 'Information Technology'),
  (2, 'BUS', 'Business Administration');

INSERT INTO student (student_id, matric_number, first_name, last_name, email, department_id, admission_year) VALUES
  (1001, 'SYN-2024-001', 'Ada', 'Adebayo', 'ada.adebayo@example.invalid', 1, 2024),
  (1002, 'SYN-2024-002', 'Tunde', 'Okafor', 'tunde.okafor@example.invalid', 1, 2024),
  (1003, 'SYN-2023-003', 'Mariam', 'Bello', 'mariam.bello@example.invalid', 2, 2023);

INSERT INTO course (course_id, course_code, title, credits, department_id) VALUES
  (201, 'MIT8103', 'Advanced Database Systems', 3, 1),
  (202, 'MIT8105', 'Network Architecture and Protocols', 3, 1),
  (203, 'BUS8101', 'Management Information Systems', 2, 2);

INSERT INTO academic_term (term_id, academic_year, term_name, starts_on, ends_on) VALUES
  (301, '2025/2026', 'First', DATE '2025-09-01', DATE '2026-01-31');

INSERT INTO course_offering (offering_id, course_id, term_id, section_code, lecturer_name, capacity, seats_remaining) VALUES
  (401, 201, 301, 'A', 'Lecturer Example A', 40, 38),
  (402, 202, 301, 'A', 'Lecturer Example B', 40, 39),
  (403, 203, 301, 'A', 'Lecturer Example C', 30, 29);

INSERT INTO enrollment (enrollment_id, student_id, offering_id, status) VALUES
  (501, 1001, 401, 'completed'),
  (502, 1002, 401, 'completed'),
  (503, 1003, 403, 'registered');

INSERT INTO assessment (assessment_id, offering_id, assessment_name, max_score, weight_percent) VALUES
  (601, 401, 'Continuous Assessment', 30, 30),
  (602, 401, 'Final Examination', 70, 70),
  (603, 403, 'Continuous Assessment', 40, 40),
  (604, 403, 'Final Examination', 60, 60);

INSERT INTO assessment_result (assessment_id, enrollment_id, score, recorded_by) VALUES
  (601, 501, 25, 'Lecturer Example A'),
  (602, 501, 62, 'Lecturer Example A'),
  (601, 502, 20, 'Lecturer Example A'),
  (602, 502, 55, 'Lecturer Example A');

-- Keep generated IDs predictable when this seed is loaded into an empty DB.
SELECT setval(pg_get_serial_sequence('department','department_id'), 2, true);
SELECT setval(pg_get_serial_sequence('student','student_id'), 1003, true);
SELECT setval(pg_get_serial_sequence('course','course_id'), 203, true);
SELECT setval(pg_get_serial_sequence('academic_term','term_id'), 301, true);
SELECT setval(pg_get_serial_sequence('course_offering','offering_id'), 403, true);
SELECT setval(pg_get_serial_sequence('enrollment','enrollment_id'), 503, true);
SELECT setval(pg_get_serial_sequence('assessment','assessment_id'), 604, true);
