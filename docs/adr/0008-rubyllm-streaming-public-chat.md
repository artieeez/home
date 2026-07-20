# ADR-008: RubyLLM Agent, Streaming Chat, Usage Budget

- **Date**: 2026-07-20
- **Status**: Accepted
- **Deciders**: Artur Webber
- **Tags**: architecture, ai, rails, hotwire, cost
- **Related**: [ADR-004](./0004-hotwire-tailwind-public-chat.md), [ADR-007](./0007-index-read-search-no-vectors.md)

## Context and Problem Statement

Public chat needs an agent loop (tools + model calls), ChatGPT-like streaming, and protection against unbounded LLM spend. The UI stack is Hotwire ([ADR-004](./0004-hotwire-tailwind-public-chat.md)); retrieval is Index/Read/Search ([ADR-007](./0007-index-read-search-no-vectors.md)), not LangChain-style RAG.

## Decision Drivers

- Tool calling for Read/Search without a heavy orchestration framework
- Streamed Answers as the v1 UX
- Disposable server-side Conversations for rate limits and debugging
- Hard ceiling on spend for unauthenticated Visitors

## Considered Options

- RubyLLM vs langchainrb vs ActiveAgent vs bare provider SDKs
- Stream tokens in v1 vs full-Answer then render
- Ephemeral-only chat vs long-lived history vs disposable persisted Conversations
- Light per-IP limits vs global Usage Budget vs CAPTCHA-first

## Decision Outcome

Chosen option: **"RubyLLM + streamed Answers + disposable Conversations + Usage Budget"**.

Use **RubyLLM** for chat, tool schemas, and the agent loop against an external LLM API. Stream Answer tokens to the Visitor (tool-call pauses are expected). Persist **Conversations**/**Turns** briefly for ops and limits, then purge — not a ChatGPT history product. Enforce per-Visitor limits plus a global **Usage Budget**; when exhausted, refuse new Answers and rely on the static CV. Fixed **Prompt Suggestions** cold-start chat; they are not Index-generated.

### Positive Consequences

- Fits Index/tool architecture without RAG framework weight
- Streaming matches visitor expectations for a chat Portfolio
- Budget protects the wallet without CAPTCHA on day one

### Negative Consequences

- Hotwire/Stimulus (or Cable) streaming needs careful design
- RubyLLM is a dependency; provider SDK fallback if streaming integration fights the stack
- Budget exhaustion makes chat unavailable until the window resets

## Links

- Domain language: `CONTEXT.md` (**Conversation**, **Turn**, **Answer**, **Prompt Suggestion**, **Usage Budget**, **CV**)
- Public surface: [ADR-004](./0004-hotwire-tailwind-public-chat.md)
