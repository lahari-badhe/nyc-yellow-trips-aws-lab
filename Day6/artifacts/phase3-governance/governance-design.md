## Phase 3 – Data Lake Governance & Access Control Design

### Current Setup
- lab-admin: Full administrative access to S3 data lake
- nyc-data-user: Read-only access (cannot write to any zone)

### Intended Governance Model (Production Design)

| Zone      | Access Level        | Intended Roles            |
|----------|---------------------|---------------------------|
| Raw      | No access / Read-only | Platform, Audit only      |
| Validated| Read + Write         | Data Engineers            |
| Curated  | Read + Write         | Analytics / BI / ML       |
| Master   | Restricted Write     | MDM / Platform            |
| Archive  | Immutable            | Platform / Compliance     |

### Notes
- Raw zone remains immutable to preserve legal and audit integrity
- Curated zone supports business analytics and reporting
- Object tagging enables future Lake Formation or tag-based access policies
- IAM permissions are managed centrally by platform/security teams

