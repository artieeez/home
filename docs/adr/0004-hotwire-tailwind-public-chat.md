# ADR-004: Hotwire and Tailwind UI; Public Conversational Portfolio

- **Date**: 2026-07-20
- **Status**: Accepted
- **Deciders**: Artur Webber
- **Tags**: architecture, ui, hotwire, tailwind, chat, api
- **Related**: [ADR-001](./0001-use-ruby-on-rails-for-home.md), [ADR-002](./0002-self-contained-auth-admin.md)
- **Source**: Adapted from sitio-rails ADR-004 (Wix webhooks replaced by public chat)

## Context and Problem Statement

ADR-001 chooses Rails to avoid a separately managed frontend and backend. The product is a portfolio / CV with a ChatGPT-like interface for visitors. We need a default UI approach, styling approach, and a clear rule for what may be reached without a session.

## Decision Drivers

- Prefer one Rails Deployment and same-origin HTML over a SPA + API split
- Keep the public attack surface intentional and small
- Use a mature, convention-friendly UI stack for AI-assisted development
- Visitors must reach the chat without logging in

## Considered Options

- Rails as API-only + separate JS SPA chat client
- Hotwire/Turbo (+ Stimulus as needed) with Tailwind; HTML UI for the app
- Inertia.js (or React islands) on Rails as the default UI

## Decision Outcome

Chosen option: **"Hotwire/Turbo with Tailwind; public conversational portfolio as the intentional public HTTP surface"**.

The product UI will be built with **Hotwire/Turbo** (Stimulus where needed) and **Tailwind CSS**, served by the single Rails app. There will be **no public third-party JSON API**.

**Public without session:** visitor-facing portfolio pages and the conversational chat endpoints (and `/up` health). **Authenticated:** admin routes for maintaining content / knowledge base ([ADR-002](./0002-self-contained-auth-admin.md)).

Internal Turbo/fetch used by authenticated admin pages is allowed; it is not a product API for third parties.

### Positive Consequences

- One UI + server codebase
- Clear public vs admin boundary
- Tailwind + Hotwire fits Rails conventions

### Negative Consequences

- Rich chat streaming UX may need careful Stimulus / Action Cable design
- CSRF and rate-limiting for public chat must be scoped carefully

## Links

- Auth for admin routes: [ADR-002](./0002-self-contained-auth-admin.md)
- Sitio counterpart used Wix webhooks as the only public surface; home uses public chat instead
