# PostgreSQL execution record

This record summarizes commands actually run against a disposable PostgreSQL 16 Alpine container on 2026-11-14. All people and course records in the fixture are synthetic. These measurements describe one small local run only; they are not production or EcoPower-style workload claims.

## Schema, seed, and query activity

- `schema.sql` completed: eight tables, the assessment-score trigger, four indexes, and the student-term view were created.
- `seed.sql` completed: the synthetic departments, students, courses, term, offerings, enrollments, assessments, and results were inserted.
- The student-history query returned the synthetic MIT8103 result with a weighted percentage of `87.00` and illustrative grade point `5`.
- The registration lookup used `enrollment_offering_status_idx` and returned one row. The observed execution time was `0.223 ms` in that run.

## Index comparison

The optional benchmark fixture generated 5,000 synthetic students, offerings, and registrations in a separate disposable database. Including the three baseline enrollments, the tested table contained 5,003 rows.

| Run | Observed plan | Rows examined/returned | Buffers | Execution time |
|---|---|---:|---:|---:|
| Composite index absent | Sequential scan, then sort | 5,003 scanned; 1 returned | 50 shared hits | 0.348 ms |
| Composite index present | Index-only scan | 1 returned; 0 heap fetches | 4 shared hits, 2 reads | 0.147 ms |

These single-run timings are sensitive to cache and machine load. The useful observation is the plan change and reduced rows visited in this synthetic selective lookup; do not generalize the millisecond values to a real deployment.

## Transaction and concurrency activity

- `register_student(1001, 402)` returned `registered`; a second call returned `already registered`.
- The explicit update followed by `ROLLBACK` completed and did not retain the update.
- In a two-session READ COMMITTED exercise, Session A first read `seats_remaining = 38`. Session B registered synthetic student 1003 for offering 401 and committed. Session A’s later statement read `37`, then committed. This illustrates that a later statement under READ COMMITTED can observe a concurrent transaction committed between statements.

## Re-run required after final seed edit

After this local run, the seed was corrected so offering 403 starts with 29 seats remaining for its one registered student (it was 30 in the executed copy). Docker’s local storage then became read-only, preventing a clean rerun. The final source therefore still needs a fresh run before these outputs are treated as final submission evidence. The MongoDB script has not run locally; the current Docker engine could not download/create its temporary image.
