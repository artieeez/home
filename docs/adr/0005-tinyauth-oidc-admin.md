# ADR-005: TinyAuth/OIDC for Admin (Ops-Only)

- **Date**: 2026-07-20
- **Status**: Accepted
- **Deciders**: Artur Webber
- **Tags**: architecture, security, auth, oke
- **Related**: [ADR-002](./0002-self-contained-auth-admin.md) (superseded), [ADR-004](./0004-hotwire-tailwind-public-chat.md)
- **Supersedes**: [ADR-002](./0002-self-contained-auth-admin.md)

## Context and Problem Statement

ADR-002 chose in-app Rails email/password for Admin so the deploy would not depend on edge IdP. The cluster already runs **TinyAuth** with OIDC, Admin is ops-only (Conversation oversight / abuse — not a Knowledge Base CMS), and password bootstrap in Rails adds cost for a single owner.

## Decision Drivers

- Reuse platform auth already deployed on OKE
- Keep public Conversation endpoints unauthenticated
- Avoid owning password storage/reset for one Admin
- Keep Admin scope narrow (ops, not content CMS)

## Considered Options

- Keep ADR-002 in-app email/password
- TinyAuth/OIDC at the edge for Admin routes only
- TinyAuth plus in-app sessions (belt and suspenders)

## Decision Outcome

Chosen option: **"TinyAuth/OIDC at the edge for Admin routes only"**.

Protect Admin (e.g. `/admin`) with the cluster TinyAuth/OIDC forwardAuth path. Public portfolio pages, CV, Conversation endpoints, and `/up` remain reachable without that gate ([ADR-004](./0004-hotwire-tailwind-public-chat.md)). Rails does not implement Admin email/password. Admin does not edit the Knowledge Base (see [ADR-006](./0006-private-knowledge-repository-sync.md)).

### Positive Consequences

- No Admin password lifecycle inside the app
- Aligns with existing cluster auth
- Clear public vs Admin split at the edge

### Negative Consequences

- Local/dev Admin access needs a TinyAuth-compatible path or bypass convention
- App auth is no longer fully self-contained (depends on platform IdP)

## Links

- Domain language: `CONTEXT.md` (**Admin**, **Visitor**)
- Knowledge Base ownership: [ADR-006](./0006-private-knowledge-repository-sync.md)
