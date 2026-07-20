# ADR-001: Use Ruby on Rails for Home

- **Date**: 2026-07-20
- **Status**: Accepted
- **Deciders**: Artur Webber
- **Tags**: architecture, stack, rails
- **Source**: Adapted from sitio-rails ADR-001

## Context and Problem Statement

`home` is a personal portfolio / CV site whose main interaction is a ChatGPT-like interface where visitors ask about experience. We need a stack whose operational cost matches a single personal project, while giving AI-assisted development a mature, convention-heavy framework.

## Decision Drivers

- Minimize organizational complexity of owning separate frontend and backend stacks
- Prefer ecosystem maturity and strong conventions over assembling many JS libraries
- Reduce harness / scaffolding needed for effective AI-assisted development
- Fit a small, personal project stage

## Considered Options

- Next.js (full-stack JavaScript)
- Static site + separate chat API
- Ruby on Rails (unified application)

## Decision Outcome

Chosen option: **"Ruby on Rails (unified application)"**, because it collapses the frontend/backend boundary into one app, and Rails’ conventions reduce glue and harness for productive AI-assisted development. Aligns with the same stack choices already accepted for sitio-rails.

### Positive Consequences

- One application boundary for routing, views, domain logic, and persistence
- Shared operational patterns with sitio-rails (SQLite, Hotwire, deploy shape)
- Mature ecosystem suits AI coding with less custom agent scaffolding

### Negative Consequences

- Chat UX must be built in Hotwire / Stimulus (or carefully scoped islands), not a React SPA by default
- Ruby/Rails knowledge required for day-to-day work

## Links

- Follow-up: [ADR-002](./0002-self-contained-auth-admin.md), [ADR-003](./0003-sqlite-without-wal-on-nfs-pvc.md), [ADR-004](./0004-hotwire-tailwind-public-chat.md)
