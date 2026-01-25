# ADR Guidelines and Reference Implementation

## Purpose of this repository

This repository provides **guidelines, templates, and reference
examples** for working with **Architecture Decision Records (ADR)** in a
consistent, auditable, and repeatable way.

It is intentionally **not a real ADR repository**.

No real architectural decisions should be recorded here.

Instead, this repository exists to:
- define **good corporate practices** for ADR usage,
- provide **copy-ready templates** for real projects,
- demonstrate **correct structure and workflow** using examples,
- serve as a **reference standard** across an organization.

## How this repository should be used

Teams should use this repository to:

- bootstrap a new ADR repository by copying content from `templates/`,
- align on a shared ADR workflow and conventions,
- learn by example using the sample content in `examples/`,
- reference a single, authoritative ADR standard in internal
  documentation.

Real architectural decisions must live in **project- or system-specific
ADR repositories** created from these templates.

## Repository structure and intent

The repository is structured to clearly separate **guidance**,
**reusable assets**, and **examples**.

```
adr-guidelines/
├── README.md           # This file - explains the guideline repository
├── scripts/
│   └── sync_templates_to_examples.sh
│
├── templates/          # Copy-ready assets for real ADR repositories
│   ├── README.md       # Canonical README for a real ADR repo
│   ├── adr-template.md
│   ├── pull_request_template.md
│   ├── CODEOWNERS
│   └── scripts/
│       └── generate_adr_index.sh
│
└── examples/           # Illustrative, non-authoritative examples
    ├── README.md
    ├── adr/
    │   ├── 0001-current-system-architecture.md
    │   ├── 0002-ingress-strategy.md
    │   └── 0003-storage-backend-selection.md
    ├── ADR-INDEX.md
    └── pull_request_template.md
```

## Authoritative rules

- **Guidelines and rules** live in `templates/README.md`
- **Templates** are copied into real ADR repositories
- **Examples** are illustrative only and must not be treated as real
  decisions

This repository itself contains **no authoritative architectural
decisions**.

## What this repository is NOT

This repository is not:
- a place to store project-specific ADRs,
- a live architectural decision log,
- a wiki or documentation portal,
- an implementation or configuration repository.

## Intended audience

This repository is intended for:
- architects and platform engineers,
- technical leaders defining organizational standards,
- teams adopting ADRs at scale,
- governance or audit stakeholders reviewing decision processes.

## Guiding statement

> **This repository defines how Architecture Decision Records should be
> written and managed.
> Real decisions belong in repositories created from the provided
> templates.**
