# ADR-007: Index + Read/Search (No Vector RAG)

- **Date**: 2026-07-20
- **Status**: Accepted
- **Deciders**: Artur Webber
- **Tags**: architecture, ai, retrieval, agent
- **Related**: [ADR-006](./0006-private-knowledge-repository-sync.md), [ADR-008](./0008-rubyllm-streaming-public-chat.md)

## Context and Problem Statement

Visitors ask about Artur; Answers must be grounded in the Knowledge Base. Options ranged from sqlite-vec embeddings to Cursor-like progressive disclosure over markdown files. The Knowledge Base is small and curated; embedding pipelines and vector extensions add ops cost without clear v1 benefit.

## Decision Drivers

- Prefer precise full-document context over fuzzy chunk retrieval
- Avoid embedding API cost and sqlite-vec on NFS SQLite
- Keep discovery understandable (a human-written map)
- Allow keyword fallback when the map is insufficient

## Considered Options

- Vector RAG (chunk + embed + nearest neighbor in SQLite)
- Hybrid (vectors for discovery, file read for full docs)
- Hand-maintained Index + Read only
- Hand-maintained Index + Read + Search

## Decision Outcome

Chosen option: **"Hand-maintained Index + Read + Search"**.

The Knowledge Repository includes a hand-written **Index** (paths + short summaries). The agent uses the Index to choose files, **Read**s allowlisted paths under the synced Knowledge Base root, and may **Search** text when the Index is not enough. No vector store, embeddings, or chunk index in v1. Answers paraphrase from Sources or refuse.

### Positive Consequences

- Simpler deploy and fewer moving parts than RAG
- Full-file Reads reduce fragmentation hallucinations
- Index quality is an authoring concern, not an infra one

### Negative Consequences

- Poor Index summaries cause missed Sources (mitigate with Search + authoring discipline)
- Semantic “same idea, different words” matching is weaker than embeddings
- Large files can inflate token use when Read whole

## Links

- Domain language: `CONTEXT.md` (**Index**, **Read**, **Search**, **Answer**, **Source**)
- Agent orchestration: [ADR-008](./0008-rubyllm-streaming-public-chat.md)
