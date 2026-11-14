-- Run each exercise in a disposable database. IDs refer to seed.sql.

-- A. The advisory transaction lock serializes duplicate attempts for one
-- student/offering pair. The conditional UPDATE serializes the last-seat case
-- on the offering row. The function call is atomic as a SQL statement.
CREATE OR REPLACE FUNCTION register_student(p_student_id BIGINT, p_offering_id BIGINT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_status TEXT;
BEGIN
    PERFORM pg_advisory_xact_lock(
        hashtextextended(p_student_id::TEXT || ':' || p_offering_id::TEXT, 0)
    );

    SELECT status INTO v_status
    FROM enrollment
    WHERE student_id = p_student_id AND offering_id = p_offering_id
    FOR UPDATE;

    IF v_status = 'registered' THEN
        RETURN 'already registered';
    ELSIF v_status = 'completed' THEN
        RETURN 'already completed';
    END IF;

    UPDATE course_offering
    SET seats_remaining = seats_remaining - 1
    WHERE offering_id = p_offering_id AND seats_remaining > 0;

    IF NOT FOUND THEN
        RETURN 'section full or offering not found';
    END IF;

    IF v_status = 'dropped' THEN
        UPDATE enrollment
        SET status = 'registered', registered_at = CURRENT_TIMESTAMP
        WHERE student_id = p_student_id AND offering_id = p_offering_id;
    ELSE
        INSERT INTO enrollment (student_id, offering_id)
        VALUES (p_student_id, p_offering_id);
    END IF;

    RETURN 'registered';
END;
$$;

-- In a disposable database, capture the return value and seat count.
SELECT register_student(1001, 402);
SELECT register_student(1001, 402); -- duplicate should not consume a second seat

-- B. Rollback demonstration: change then undo a disposable row.
BEGIN;
UPDATE course_offering SET seats_remaining = seats_remaining - 1 WHERE offering_id = 403;
ROLLBACK;

-- C. Isolation exercise (two psql sessions).
-- Session A:
-- BEGIN ISOLATION LEVEL READ COMMITTED;
-- SELECT seats_remaining FROM course_offering WHERE offering_id = 401;
-- SELECT pg_sleep(10);
-- SELECT seats_remaining FROM course_offering WHERE offering_id = 401;
-- COMMIT;
-- Session B during the sleep:
-- BEGIN;
-- UPDATE course_offering SET seats_remaining = seats_remaining - 1
-- WHERE offering_id = 401 AND seats_remaining > 0;
-- COMMIT;
-- Record what each statement sees; READ COMMITTED can return a newer
-- committed value on the later statement.

-- D. Row-lock contention (two sessions; capture waits/output).
-- Session A: BEGIN; SELECT * FROM course_offering WHERE offering_id=401 FOR UPDATE;
-- Session B: BEGIN; UPDATE course_offering SET seats_remaining=seats_remaining-1
--            WHERE offering_id=401 AND seats_remaining>0;
-- Observe Session B waiting until A commits or rolls back. Do not leave a
-- lock open beyond the demonstration.
