# Architecture Decision Records (ADR)

## Purpose

This repository contains **Architecture Decision Records (ADR)** documenting
significant architectural decisions for this system.

ADR are used to:
- capture *why* architectural decisions were made,
- preserve historical context and rationale,
- enable consistent and reviewable decision-making,
- prevent undocumented architectural drift,
- support long-term maintainability, onboarding, and audits.

This repository is intended to be the **single source of truth** for architectural decisions within its scope.

## What is an Architecture Decision Record (ADR)

An **Architecture Decision Record (ADR)** is a short document that records:
- a significant architectural decision,
- the context and constraints at the time,
- the alternatives that were considered,
- the consequences of the decision.

An ADR answers the question:

> *“Why is the system designed this way?”*

ADR is **not**:
- a design specification,
- an implementation guide,
- a task or backlog item,
- a replacement for code or configuration documentation.

## What belongs in this repository

This repository contains:
- decisions with **long-term architectural impact**,
- changes affecting system structure, patterns, or dependencies,
- platform or cross-team architectural standards,
- decisions that must remain understandable months or years later.

This repository does **not** contain:
- implementation code,
- routine upgrades or version bumps,
- patch-level maintenance activities,
- purely local or trivial technical changes.

## Repository structure

```
.
├── adr/
│   ├── 0001-...
│   ├── 0002-...
│   └── ...
├── scripts/
│   └── generate_adr_index.sh
├── ADR-INDEX.md
├── adr-template.md
├── README.md
├── CODEOWNERS
└── pull_request_template.md

```

### Structural principles

- One long-lived branch: `main`
- ADRs are never deleted
- No folders or file names based on status
- File names are stable identifiers
- History must remain intact

## ADR Index

This repository may include a script for generating an index of all
Architecture Decision Records.

### Purpose

The ADR index provides:
- a quick overview of all architectural decisions,
- visibility into accepted, rejected, and superseded decisions,
- an audit-friendly summary of decision history.

The index is a **derived artifact** and does not replace individual ADR
files.

### Index generation script

If present, the script is located at:

```
scripts/generate_adr_index.sh
```

The script:
- scans all ADR files in `adr/`,
- extracts ADR number, title, and status,
- generates or updates `ADR-INDEX.md`.

### Usage

```bash
./scripts/generate_adr_index.sh
```

### Governance rules

* `ADR-INDEX.md` must not be edited manually.
* ADR files remain the **single source of truth**.
* The index may be regenerated locally or in CI.

Use of the index is **optional** and may be enabled when the number of ADRs
justifies it.

## ADR lifecycle and statuses

### Allowed statuses

| Status       | Description                                   |
| ------------ | --------------------------------------------- |
| `Proposed`   | Decision under discussion (Pull Request only) |
| `Accepted`   | Decision approved and valid                   |
| `Rejected`   | Decision considered and explicitly rejected   |
| `Superseded` | Decision replaced by a newer ADR              |

> Recommendation: the `main` branch should not contain ADRs with status `Proposed`.

## How to create an ADR (workflow)

### 1. Create a short-lived ADR branch

```bash
git checkout -b adr/0012-storage-backend-strategy
```

Branch naming convention:

```
adr/<ADR-number>-<short-topic>
```

ADR branches are **temporary** and must be deleted after merge.

### 2. Create the ADR (Proposed)

1. Copy the template:

```bash
cp adr-template.md adr/0012-storage-backend-strategy.md
```

2. Set the status:

```markdown
## Status
Proposed
```

3. Commit:

```bash
git commit -am "adr: add ADR-0012 storage backend strategy (Proposed)"
```

### 3. Open a Pull Request

The Pull Request is the **decision forum**:

* discussion and review happen here,
* assumptions are challenged,
* implications are refined.

No implementation is performed at this stage.

### 4. Close the decision

When consensus is reached, add a **final commit**:

#### Accepting a decision

```bash
git commit -am "adr: mark ADR-0012 as Accepted"
```

#### Rejecting a decision

```bash
git commit -am "adr: mark ADR-0012 as Rejected"
```

This commit represents the **formal architectural decision**.

### 5. Merge and delete the branch

* Merge the Pull Request into `main`
* Delete the ADR branch

After merge:

* `main` contains only finalized decisions,
* all discussion remains available in the Pull Request.

## Changing an accepted decision

Accepted ADRs should be treated as **immutable**.

If the approach changes:

1. Create a new ADR describing the new decision
2. Reference the previous ADR in the context
3. Accept the new ADR
4. Update the old ADR status to:

```markdown
## Status
Superseded by ADR-00XX
```

History is preserved. No rewriting of past decisions.

## Documenting existing (legacy) decisions

ADR can be used to document **pre-existing architecture**.

Recommended statuses:

* `Accepted (existing decision)`
* `Accepted (post-facto)`

This establishes a clear baseline for future architectural changes.

## ADR template

All ADRs must follow the structure defined in `adr-template.md`.

Required sections include:

* Context
* Problem
* Considered options
* Decision
* Consequences (technical, operational, organizational)
* Risks and mitigations
* References

## Commit message conventions

### General rules

* English only
* Clear and declarative
* No implementation details

### Allowed prefixes

| Prefix  | Usage                               |
| ------- | ----------------------------------- |
| `adr:`  | ADR content and status changes      |
| `docs:` | README, templates, guidelines       |
| `meta:` | Formatting, numbering, housekeeping |

### Examples

```
adr: add ADR-0005 ingress strategy (Proposed)
adr: update ADR-0005 after review
adr: mark ADR-0005 as Accepted
adr: mark ADR-0003 as Superseded by ADR-0009
docs: update ADR template
```

## Pull Request rules

* One ADR per Pull Request
* ADR must end with `Accepted` or `Rejected`
* Discussion happens in Pull Request comments
* Merge represents the recorded decision

### Pull Request template location

To be recognized by the Git forge, the Pull Request template must be
placed in a forge-specific directory in the real ADR repository, for
example:

- GitHub: `.github/pull_request_template.md`
- GitLab: `.gitlab/merge_request_templates/`
- Forgejo: `.forgejo/pull_request_template.md`
- Gitea: `.gitea/pull_request_template.md`

This repository provides the template in `templates/` for reuse.
Teams must copy it to the appropriate location for their Git forge.

## CODEOWNERS

ADR approval must be restricted to an architecture group.

Example:

```
/adr/ @architecture-team
/adr-template.md @architecture-team
```

Only designated owners can approve architectural decisions.

## Anti-patterns (what to avoid)

* Merging ADRs with status `Proposed`
* Editing accepted ADRs to reflect new reality
* Encoding status in file names or folder structure
* Multiple decisions in a single ADR
* Writing ADRs for routine version upgrades
* Keeping long-lived ADR branches

## Relationship to implementation

Implementation repositories:

* must reference the accepted ADR,
* must not bypass the ADR decision process.

Example implementation PR title:

```
Implement storage backend change (ADR-0012)
```

## Guiding principle

> **Pull Requests are for discussion.
> `main` is for decisions.
> History should not be rewritten.**
