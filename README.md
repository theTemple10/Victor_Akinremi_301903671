# MIT8103 Advanced Database Systems Portfolio

This repository contains a practical database portfolio for the MIT8103 September 2026 continuous assessment. The work uses **MivaLearn**, a fictional university registration and results portal. All student and course records are synthetic; the database is not an institutional system.

**Author:** Victor Akinremi

**Student ID:** 301903671

**Public repository:** https://github.com/theTemple10/Victor_Akinremi_301903671

**Hosted execution:** [GitHub Actions run](https://github.com/theTemple10/Victor_Akinremi_301903671/actions/runs/43575115558)

## Scope and implementation

The portfolio covers relational design, SQL querying and index analysis, transaction/concurrency behavior, a MongoDB document projection, and a proposed distributed/cloud architecture. PostgreSQL is the transactional source of truth. The MongoDB transcript snapshot is a derived read model. The distributed/cloud activity is a design proposal; no production cloud service, replication topology, or failover was deployed.

| Directory/file | Contents |
| --- | --- |
| `portfolio-1-design/` | Entity relationship model, PostgreSQL schema, constraints, trigger, indexes, results view, and synthetic seed data |
| `portfolio-2-query-optimisation/` | Representative SQL queries and a separate 5,000-row synthetic benchmark fixture |
| `portfolio-3-transactions-concurrency/` | Atomic registration function, duplicate handling, rollback, and two-session isolation exercises |
| `portfolio-4-nosql/` | MongoDB student/transcript documents, index, and validation example |
| `portfolio-5-distributed-cloud/` | Proposed replication, recovery, scaling, and partitioning design with implementation limits stated |
| `evidence/` | Local PostgreSQL execution record, caveats, and final-source hosted execution link |
| `.github/workflows/portfolio-validation.yml` | Reproducible hosted PostgreSQL/MongoDB execution workflow |
| `Akinremi_Victor_301903671_REPORT.md` | Final LMS summary in Markdown |
| `Akinremi_Victor_301903671_REPORT.txt` | Plain-text LMS summary |

## Requirements

- PostgreSQL 16 or later and `psql` for the relational activities.
- MongoDB 7 or later and `mongosh` for the document-model activity.
- GitHub Actions uses hosted Linux runners with PostgreSQL and MongoDB service containers; it does not require local database installation. See the workflow file for service versions and commands.

These versions are tested compatibility targets used by this portfolio, not claims about a course-mandated version. The cloud workflow is evidence that the repository scripts execute in the configured environment, not evidence of a deployed production system.

## Run locally

Use a new, disposable PostgreSQL database. From the repository root, run:

```sh
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f portfolio-1-design/schema.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f portfolio-1-design/seed.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f portfolio-2-query-optimisation/queries.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f portfolio-3-transactions-concurrency/transactions.sql
```

The benchmark fixture belongs in a separate disposable database because it adds thousands of synthetic rows and performs the index comparison. Follow the comments in `portfolio-2-query-optimisation/queries.sql` to capture `EXPLAIN (ANALYZE, BUFFERS)` before and after the index. Run `portfolio-4-nosql/mongodb.js` in a disposable MongoDB database with `mongosh`. Do not point these teaching scripts at real student data or a production database.

The transaction script includes an isolation exercise that requires two sessions; follow the Session A/Session B comments in the file. `portfolio-5-distributed-cloud/design.md` is explanatory design material and has no deployment command.

## Data and design notes

- The schema uses primary/foreign keys, uniqueness and check constraints, a trigger for a cross-table score limit, and indexes for documented access paths.
- `seats_remaining` is a maintained counter used to demonstrate atomic capacity allocation. In a real service it must be changed only through controlled transactions and reconciled against active registrations.
- Grade thresholds and the 5-point grade mapping are illustrative only. They must not be treated as MIVA's grading policy.
- The index timings in `evidence/postgresql-execution-record.md` are from one synthetic local run. They are machine/cache dependent and are not a general performance claim.
- GitHub Actions completed the final-source PostgreSQL and MongoDB activities successfully. The Actions run page provides logs and the uploaded `portfolio-execution-evidence` artifact. A hosted validation run demonstrates execution in that configured CI environment only.


## AI-use and reproducibility

AI assistance was used to draft and revise parts of the database design, SQL/scripts, documentation, and execution workflow. The scripts were run in the local PostgreSQL environment and in the hosted GitHub Actions environment documented above.
