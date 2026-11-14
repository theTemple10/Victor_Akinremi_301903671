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

## Final-source hosted execution

The local run above preceded the correction that sets offering 403 to 29 remaining seats for its one registered student. A subsequent successful GitHub Actions run executed the final repository source in hosted PostgreSQL 16 and MongoDB 7 service containers. The workflow completed the schema and seed load, SQL queries, transaction script, benchmark with and without the composite index, and MongoDB examples. The logs and uploaded `portfolio-execution-evidence` artifact are available from [workflow run 43575115558](https://github.com/theTemple10/Victor_Akinremi_301903671/actions/runs/43575115558). The local timing table above remains an earlier single-run measurement; it is not presented as the hosted benchmark result.
