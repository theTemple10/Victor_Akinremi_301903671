// MongoDB examples for the same fictional MivaLearn case study.
// Run with mongosh against a disposable database. Documents contain synthetic data.
use('mivalearn');

db.students.insertOne({
  _id: 'SYN-2024-001',
  name: { first: 'Ada', last: 'Adebayo' },
  email: 'ada.adebayo@example.invalid',
  departmentCode: 'MIT',
  status: 'active',
  preferences: { locale: 'en-NG' }
});

// Read-heavy per-student transcript projection. Embed the small set of course
// snapshots and grade summaries needed for this access pattern; keep the
// relational source of truth for enrollment and grade transactions.
db.transcript_snapshots.insertOne({
  _id: 'SYN-2024-001:2026/2027:First',
  studentId: 'SYN-2024-001',
  academicYear: '2026/2027',
  term: 'First',
  generatedAt: new Date(),
  courses: [{
    courseCode: 'MIT8103',
    titleAtGeneration: 'Advanced Database Systems',
    credits: 3,
    totalPercent: 87,
    gradePoint: 5
  }]
});

db.transcript_snapshots.createIndex({ studentId: 1, academicYear: -1, term: 1 });
db.transcript_snapshots.findOne({ studentId: 'SYN-2024-001' });

// Validation example: constrain required fields and accepted statuses.
db.createCollection('course_catalog', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['courseCode', 'title', 'credits', 'departmentCode'],
      properties: {
        courseCode: { bsonType: 'string' },
        title: { bsonType: 'string' },
        credits: { bsonType: 'int', minimum: 1, maximum: 12 },
        departmentCode: { bsonType: 'string' }
      }
    }
  }
});

db.course_catalog.insertOne({
  courseCode: 'MIT8103',
  title: 'Advanced Database Systems',
  credits: NumberInt(3),
  departmentCode: 'MIT'
});
db.course_catalog.findOne({ courseCode: 'MIT8103' });

// A transcript snapshot is a denormalized read model, not the authoritative
// grade ledger. Rebuild it from committed relational records and version it.
// For real deployments, protect personal data with role-based access, TLS,
// encryption-at-rest controls, retention rules, and audited access.
