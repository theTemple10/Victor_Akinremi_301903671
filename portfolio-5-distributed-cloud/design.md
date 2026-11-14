# Distributed and cloud database exercise

## Proposed arrangement

For the fictional MivaLearn portal, use PostgreSQL as the authoritative store for registration and grades. Deploy a primary database in the university's selected cloud region and a synchronous standby only where network latency and the provider's supported synchronous replication make commit latency acceptable. Maintain an asynchronous replica in a separate failure domain for disaster recovery. These are proposed design choices, not a deployed or measured service.

Application services connect through a private network and a connection pool. Only the application tier and restricted database administrators can reach database endpoints. Student-facing read traffic may use a read replica for explicitly stale-tolerant views. Registration, seat allocation, assessment recording, and transcript finalization stay on the primary so related writes use one transaction boundary.

## Replication, consistency, and recovery

- Synchronous replication can reduce acknowledged-write loss for a local standby, at the cost of write availability or latency when that standby is unreachable. Select the exact synchronous-commit mode only after measuring the actual topology.
- Asynchronous replication can keep a remote recovery copy available across a wider failure domain, but replica lag means recent committed changes may be absent after failover. Monitor and document observed lag.
- Define RPO and RTO with the university owner; the assessment brief provides no targets. Test restore and failover procedures, verify data integrity, and record measured recovery times rather than claiming untested objectives.
- Use encrypted backups, point-in-time recovery where supported, least-privilege access, secret rotation, audit logging, and periodic restore tests.

## Scaling and partitioning

Start with vertical capacity, query/index review, connection pooling, and read replicas. Partition large append-heavy audit or access-log tables by time only when volume and retention needs justify it. Avoid partitioning small core tables prematurely. If enrolment volume eventually requires horizontal distribution, partition by a stable student identifier or institution/tenant boundary after measuring query patterns; cross-partition registration and reporting add operational and consistency costs.

The MongoDB transcript snapshot is a derived read model, not a second source of truth. Update it after relational commits through a retryable event/outbox process, preserve idempotency, expose its freshness to users, and support rebuilding it from the primary records.

## Evidence to add

This is a design exercise only. To claim implementation, add the cloud/provider configuration, replication status, replica-lag observations, backup/restore logs, failover notes, and a diagram from your own deployment. Do not include credentials or personal data in the repository.
