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

## Docs

- `docs/adr/` — architecture decisions
