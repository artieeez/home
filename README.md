# home

Personal portfolio / CV — conversational interface for visitors to ask about experience.

See ADRs in `docs/adr/` for the accepted architecture decisions (adapted from sitio-rails).

## Stack

- Ruby 4.0 / Rails 8.1
- SQLite3 (rollback journal, no WAL — ADR-003)
- Hotwire (Turbo + Stimulus) + Tailwind CSS
- RSpec
- Solid Cache / Queue / Cable

## Local setup

```bash
bundle install
bin/rails db:prepare
bin/dev          # or: bin/rails server
```

- App: http://localhost:3000/
- Health: http://localhost:3000/up

```bash
bundle exec rspec
```

Optional DB path override (used later for an OKE PVC mount):

```bash
SQLITE_DATABASE=/path/to/storage/development.sqlite3 bin/rails server
```

## Docker

```bash
docker build -t home .
docker run --rm -p 80:80 \
  -e RAILS_MASTER_KEY="$(cat config/master.key)" \
  -e SQLITE_DATABASE=/rails/storage/production.sqlite3 \
  home
```

OKE images are **linux/arm64** and live in OCIR:

`vcp.ocir.io/axtvnrdemzo7/home:<tag>`

| Env | URL |
|-----|-----|
| Staging | https://home-staging.artr.com.br |
| Production | https://artr.com.br |

## CI → OCIR → GitOps

1. `.github/workflows/build-push-ocir.yaml` (this repo) — push to `main` builds/pushes and bumps **staging** in `artr-gitops`.
2. `Promote home to production` (in `artr-gitops`) — manual `workflow_dispatch` copies the staging image tag to production.

**GitHub Actions secrets** (repo settings):

| Secret | Value |
|--------|--------|
| `OCIR_USERNAME` | `<tenancy-namespace>/<oci-username>` e.g. `axtvnrdemzo7/you@example.com` |
| `OCIR_AUTH_TOKEN` | OCI user auth token (push to `home` repo) |
| `GITOPS_TOKEN` | (optional) PAT with `contents:write` on `artieeez/artr-gitops` to bump staging image |

Create the OCIR repository via Terraform in `oracle-cluster` (`home` resource). Cluster SealedSecrets live in `artr-gitops` under `apps/{staging,production}/home/`.

## Docs

- `docs/adr/` — architecture decisions
