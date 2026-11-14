# MIT 8103 Advanced Database Systems Portfolio

**Case study:** MivaLearn, a fictional university course registration and results portal. It serves students, academic departments, lecturers, and registry staff. It stores student and course records, semester offerings, registrations, assessments, and grades. Core operations are course registration, class-capacity management, grade entry, GPA calculation, transcript retrieval, and audit review.

**Implementation assumption:** PostgreSQL 16 or later for the relational activities; MongoDB 7 or later for the document-model activity. Versions are suggested compatibility targets, not requirements stated in the CA brief. Replace them if the course environment specifies another version.

## Portfolio contents

1. `portfolio-1-design/` — normalized relational schema, sample data, keys and constraints.
2. `portfolio-2-query-optimisation/` — representative queries, index choices, and commands for capturing real execution plans.
3. `portfolio-3-transactions-concurrency/` — atomic seat allocation and transaction/isolation exercises.
4. `portfolio-4-nosql/` — MongoDB document model and sample operations for the same case study.
5. `portfolio-5-distributed-cloud/` — replication, partitioning, recovery, and deployment discussion.
6. `final-summary-template.md` — draft structure for the required 2–3 page LMS summary.
7. `evidence/` — execution notes from the local PostgreSQL run, including its limitations.
8. `.github/workflows/portfolio-validation.yml` — cloud workflow to run PostgreSQL and MongoDB activities on pushes to `main`.

## Run order

Create an empty PostgreSQL database, then run `portfolio-1-design/schema.sql` followed by `portfolio-1-design/seed.sql`. Run the query and transaction scripts from that database. For a larger index comparison, use a separate disposable database, load `portfolio-2-query-optimisation/benchmark_fixture.sql`, and compare the plans before and after the index. The MongoDB examples are separate and use a database named `mivalearn`. The distributed/cloud file is a design exercise; it does not claim a live cloud deployment.

The evidence folder records one local PostgreSQL execution. Its query-plan timings are a single synthetic benchmark run, and its note flags a seed-data edit that still needs a clean rerun. The MongoDB code has not yet executed locally. The GitHub Actions workflow is intended to run both databases in a temporary hosted environment after it is committed; do not claim that workflow ran until a completed Actions run is available.

## Before submission

- Replace the fictional case study or implementation choices if you used a different approved setup, and keep the choice consistent across all activities.
- Add the public GitHub repository URL to the final summary and verify that the assessor can access it.
- Keep a truthful commit history from the date work actually occurs; do not backdate commits or present new work as semester-long progress.
- Complete the reflection in your own words and cite external sources, datasets, and tools.
- Since AI assistance was used, include an accurate AI-use declaration. Verify and be ready to explain every script and design decision.
- The brief requires a 2–3 page LMS document; this repository is supporting practical evidence, not a substitute for that submission.
