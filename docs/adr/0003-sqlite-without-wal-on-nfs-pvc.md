# ADR-003: Colocated SQLite3 without WAL on NFS PVC

- **Date**: 2026-07-20
- **Status**: Accepted
- **Deciders**: Artur Webber
- **Tags**: architecture, database, sqlite, ops, rails, oke
- **Related**: [ADR-001](./0001-use-ruby-on-rails-for-home.md)
- **Source**: Adapted from sitio-rails ADR-003 (same ops constraints)

## Context and Problem Statement

`home` aims to be self-contained: one app Deployment without a separate database service. On OKE today, durable storage for personal apps follows an **NFS-backed PVC** pattern (`storageClassName: nfs-client`, `ReadWriteMany`). Network filesystems are a poor fit for SQLite **WAL** mode; default rollback-journal mode is the safer choice on this infrastructure.

## Decision Drivers

- Colocate persistence with the app to minimize moving parts
- Reuse current OKE NFS PVC pattern
- Avoid SQLite WAL on NFS
- Keep a clear upgrade path to local disk + WAL later if needed

## Considered Options

- Managed/cluster PostgreSQL
- Colocated SQLite3 **with WAL** on a local/non-NFS volume
- Colocated SQLite3 **without WAL** on an NFS PVC
- SQLite on ephemeral disk only (no PVC)

## Decision Outcome

Chosen option: **"Colocated SQLite3 without WAL on NFS PVC"**.

Rails will use **SQLite3** in **default journal mode (no WAL)**, with the DB file on an **NFS PVC** when deployed to OKE. Paths are env-driven (`SQLITE_DATABASE`, etc.) so local and cluster mounts share the same config shape.

**Still single writer:** NFS RWX does *not* mean multiple Rails replicas may share one SQLite file. Keep **one writer**.

**Deferred:** local (non-NFS) volume + WAL in a superseding ADR if concurrency limits become a problem.

### Positive Consequences

- No separate Postgres service
- Fits current OKE/GitOps storage without new volume types
- Avoids known SQLite+WAL-on-NFS failure modes

### Negative Consequences

- Weaker concurrency than WAL under load
- NFS + SQLite needs care (latency, locking, backups)
- Horizontal scale-out of writers remains out of scope

## Links

- Related: one Rails Deployment ([ADR-001](./0001-use-ruby-on-rails-for-home.md))
- Explicitly out of scope: enabling WAL before non-NFS storage exists
