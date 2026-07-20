# ADR-006: Private Knowledge Repository + Out-of-Band Sync

- **Date**: 2026-07-20
- **Status**: Accepted
- **Deciders**: Artur Webber
- **Tags**: architecture, knowledge-base, gitops, oke, privacy
- **Related**: [ADR-003](./0003-sqlite-without-wal-on-nfs-pvc.md), [ADR-005](./0005-tinyauth-oidc-admin.md), [ADR-007](./0007-index-read-search-no-vectors.md)

## Context and Problem Statement

The Portfolio answers from a curated Knowledge Base, but the application repository is public. Shipping private markdown in the same git repo (even gitignored) or baking it into a public image risks exposure. Admin is ops-only ([ADR-005](./0005-tinyauth-oidc-admin.md)), so the app is not a markdown CMS.

## Decision Drivers

- Keep private career/detail notes out of the public app repo and public image
- Prefer real files on disk for Index / Read / Search ([ADR-007](./0007-index-read-search-no-vectors.md))
- Fit OKE NFS PVC patterns already chosen for durable storage ([ADR-003](./0003-sqlite-without-wal-on-nfs-pvc.md))
- Avoid giving the Rails process git credentials

## Considered Options

- Markdown in the public app repo (git-only, baked into image)
- Gitignored folder in the app repo as source of truth
- Private Knowledge Repository + out-of-band sync onto PVC
- Rails clones/pulls the private repo at boot
- Build-time copy from private repo into the image

## Decision Outcome

Chosen option: **"Private Knowledge Repository + Knowledge Sync onto PVC"**.

Source of truth is a separate (typically private) **Knowledge Repository**. An out-of-band **Knowledge Sync** (manual script first; CronJob/init later) copies it onto storage the pod mounts. Rails only reads a configured path — it does not `git clone`/`git pull`. The static **CV** remains hand-maintained in the public app repo as a fallback unrelated to Sync.

### Positive Consequences

- Public git history and image layers stay free of private notes
- Sync failures do not require app releases to fix content
- Matches file-based agent tools

### Negative Consequences

- Content updates need a Sync step after git push to the Knowledge Repository
- Running chat depends on PVC contents being present and current
- Some duplication between public CV and private Knowledge Base is accepted

## Links

- Domain language: `CONTEXT.md` (**Knowledge Base**, **Knowledge Repository**, **Knowledge Sync**, **CV**)
