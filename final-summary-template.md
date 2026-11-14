# MIT 8103 Advanced Database Systems Portfolio — LMS summary

> Draft template for a 2–3 page document. Replace bracketed prompts with your own implementation details and evidence. Do not claim an activity was executed unless you performed it and can show the output.

## Case study and implementation

This portfolio models **MivaLearn**, a fictional university registration and results portal used by students, lecturers, departments, and registry staff. Its data includes student profiles, departments, courses, terms, course offerings, enrolments, assessments, and results. I used [database/version/environment]. All sample records in the repository are synthetic.

## Portfolio activities

**1. Design and modelling.** The relational schema separates students, courses, terms, offerings, enrolments, assessments, and results. Primary keys identify rows; foreign keys preserve relationships; unique constraints prevent duplicate course codes and repeated student-offering registrations; checks constrain statuses, capacities, credits, scores, and dates. [Insert your ER diagram and a short explanation of normalization and any deliberate denormalization.]

**2. Query processing and optimisation.** I ran queries for [use cases]. I captured `EXPLAIN (ANALYZE, BUFFERS)` for [query] before and after [index/change]. The measured plan showed [paste actual plan observations and figures]. Indexes support the observed filter and join paths, while adding storage and write overhead. Do not fill this section with estimated or invented performance claims.

**3. Transactions and concurrency.** The registration workflow claims a seat with a conditional update and inserts the enrolment in the same transaction. I demonstrated [commit/rollback/isolation/row-lock case] using [two sessions or equivalent]. The observed result was [your actual output]. Duplicate registration, full sections, and transaction failure are handled by [explain your implementation].

**4. NoSQL and advanced models.** I modelled a transcript snapshot as a MongoDB document because the read path retrieves a student's term summary as a unit. Relational records remain authoritative for grade and enrolment writes. The document is a derived projection, so [describe how you handled freshness, consistency, and rebuilds, if implemented].

**5. Distributed/cloud exercise.** I proposed [your actual architecture or deployment]. I considered replication consistency, replica lag, backups, recovery, partitioning, and the trade-off between read scaling and operational complexity. [State what you deployed and measured; distinguish it clearly from design-only work.]

## Reflection and references

My main design choice was [choice and reason]. A challenge was [real challenge] and I addressed it by [what you actually did]. I learned [specific lesson]. The limitation of this portfolio is [specific limitation].

**Repository:** https://github.com/theTemple10/Victor_Akinremi_301903671 (verify assessor access)

**References:** [List course materials, official product documentation, datasets, libraries, and other sources used, with access dates where appropriate.]

**AI-use declaration:** I used [tool] to [accurate description of assistance]. I reviewed, corrected, and [describe the actual verification performed]. I am responsible for and can explain the submitted design, code, results, and sources.
