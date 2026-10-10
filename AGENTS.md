# Agent instructions

- Follow [CONTRIBUTING.md](CONTRIBUTING.md) for branch naming, PR targets,
  validation, releases, and hotfixes. Normal work starts from `develop` on a
  `feat/`, `fix/`, `refactor/`, `docs/`, `test/`, or `chore/` topic branch.
- Never work directly on `main` or `develop`; normal PRs target `develop`.
  Only release PRs from this repository's `develop` and urgent `hotfix/` PRs
  target `main`. Backport hotfixes to `develop`.
- Preserve unrelated changes and never force-push shared branches. Do not merge
  PRs, promote releases, or change repository protection without authorization.
- See [CLAUDE.md](CLAUDE.md) for configuration architecture, plugin conventions,
  and development commands. Branch process details live in CONTRIBUTING.md;
  machine-readable policy lives in `.claude/branch-strategy.yaml`.
- Run the documented checks appropriate to the change and report failures or
  checks you could not run. Do not silently update flake inputs while validating.
