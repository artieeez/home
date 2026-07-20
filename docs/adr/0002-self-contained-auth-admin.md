# ADR-002: Self-Contained Auth for Admin

- **Date**: 2026-07-20
- **Status**: Accepted
- **Deciders**: Artur Webber
- **Tags**: architecture, security, auth, rails
- **Related**: [ADR-001](./0001-use-ruby-on-rails-for-home.md), [ADR-004](./0004-hotwire-tailwind-public-chat.md)
- **Source**: Adapted from sitio-rails ADR-002 (roles simplified for a personal site)

## Context and Problem Statement

Visitors use the public conversational portfolio without an account. Content and knowledge-base maintenance still need a protected admin surface. Edge IdP (TinyAuth / forwardAuth) adds external coupling that a self-contained personal deploy does not need.

## Decision Drivers

- Prefer a self-contained deployment path
- Keep authorization simple for a single-owner portfolio
- Support email/password for the site owner
- Leave the public chat unauthenticated

## Considered Options

- Keep TinyAuth / edge OIDC in front of Rails
- In-app Rails authentication (email/password) for admin only
- No auth (edit everything via git / deploy only)

## Decision Outcome

Chosen option: **"In-app Rails authentication (email/password) for admin only"**.

The site owner authenticates with **email/password** sessions owned by the Rails app. Authorization v1 is a single **admin** role (no member role — unlike Sitio). Visitor-facing chat and CV pages remain public ([ADR-004](./0004-hotwire-tailwind-public-chat.md)).

**Deferred:** invite flows, multi-admin, and richer RBAC until needed.

### Positive Consequences

- One fewer external dependency for local and cluster deploys
- Auth behavior is reviewable and testable inside the app
- Clear split: public visitors vs authenticated admin

### Negative Consequences

- Rails owns password storage, reset flow, session cookies, and CSRF
- Admin bootstrap must be defined when auth is implemented

## Links

- Public surface rules: [ADR-004](./0004-hotwire-tailwind-public-chat.md)
- Sitio counterpart used admin + member; home intentionally omits member
