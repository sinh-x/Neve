# Development workflow

Neve uses the same `develop-flow` strategy as `personal-nixos`: short-lived topic
branches integrate into `develop`, then `develop` is promoted to `main` by PR.
The machine-readable configuration is [`.claude/branch-strategy.yaml`](.claude/branch-strategy.yaml).

## Branches and PR targets

| Branch | Purpose | Created from | PR target |
| --- | --- | --- | --- |
| `main` | Stable releases; remains the GitHub default branch | — | — |
| `develop` | Integration and validation of upcoming changes | `main` initially | `main` for releases |
| `feat/<topic>` | Features and plugin additions | `develop` | `develop` |
| `fix/<topic>` | Non-urgent fixes | `develop` | `develop` |
| `refactor/`, `docs/`, `test/`, `chore/` + topic | Other scoped changes | `develop` | `develop` |
| `hotfix/<topic>` | Urgent production fixes | `main` | `main`, then `develop` |

Use a descriptive kebab-case topic (an optional ticket ID is fine), for example
`feat/add-plugin` or `fix/NXN-123-completion`. Never commit directly to `main` or
`develop`, force-push either branch, or send an ordinary feature PR to `main`.
Keep unrelated changes out of a PR; use conventional commit messages such as
`feat(nixvim): add plugin` and `docs: clarify branch workflow`.

## Feature work

Start with a clean working tree; preserve or separately commit any existing work.

```bash
git fetch origin
git switch develop
git pull --ff-only origin develop
git switch -c feat/my-topic
# Make changes, then validate (see below).
git add <changed-files>
git commit -m "feat(nixvim): describe the change"
git push -u origin HEAD
gh pr create --base develop
```

GitHub defaults new PRs to `main`, so explicitly select `develop`. If the topic
branch needs updating, merge `origin/develop` into it, resolve conflicts, and
rerun validation. Do not rewrite shared branch history. Review the diff and CI
results before merging. Squash-merging ordinary topic PRs is preferred; delete
the topic branch after integration.

## Validation

From the repository root:

```bash
# Pass tracked files: the formatter is bare nixfmt, not a tree wrapper.
# Bash (also supported by the CI runner):
mapfile -d '' nix_files < <(git ls-files -z -- '*.nix')
nix fmt --no-update-lock-file -- "${nix_files[@]}"
nix flake check --no-update-lock-file
nix build .#nvim --no-update-lock-file
# Optionally smoke-test interactive changes:
nix run .#nvim
```

Commit formatting changes before pushing. CI checks formatting without fixing
it, runs the configured flake checks, and builds Neovim for PRs targeting either
long-lived branch and pushes to those branches. Dependency updates belong on a
`chore/` branch from `develop`: run `nix flake update` intentionally, inspect
`flake.lock`, validate, and open a PR to `develop`. CI never updates dependencies
or writes commits back to a PR.

## Releases: develop → main

1. Ensure `develop` is green and smoke-test the integrated configuration.
2. Open `gh pr create --base main --head develop`; summarize changes and validation.
3. After review and successful checks, use a **merge commit** (not squash or
   rebase) to preserve the shared integration history. For example,
   `gh pr merge <release-pr-number> --merge`.
4. Do not delete `develop`. Fetch the merged state before starting new work.

There is no automatic tagging, version bump, or GitHub Release in this repo.
Do not add those merely to promote the configuration. The branch-policy check
accepts `develop` → `main` only when both branches belong to this repository.

## Urgent hotfixes

1. Fetch `origin` and create `hotfix/<topic>` from `origin/main`.
2. Make the smallest fix, validate it, and open a PR to `main`.
3. Merge with a **merge commit** and retain the hotfix branch.
4. Open a second PR from the same hotfix branch to `develop`, validate and merge
   with a **merge commit**. Delete the hotfix branch only after both merges.

If the backport conflicts, make a separate `hotfix/<topic>-backport` branch from
`origin/develop`, cherry-pick the fix commits, resolve and validate, then PR it
to `develop`. Link both PRs so the production fix cannot be lost in a release.

## GitHub protection setup (repository administrator)

The YAML config and CI check do **not** themselves protect branches. Configure
GitHub Settings → Rules → Rulesets (or Branches → Branch protection) for both
`main` and `develop`:

- Require PRs and review before merging; restrict bypass permissions deliberately.
- Require status checks **Check PR target** (workflow: Branch Policy) and
  **Validate Nix** (workflow: Nix Flake Check) after their first successful runs.
- Require status checks to pass on the latest PR revision. These workflows do
  not support a merge queue (`merge_group`); leave it disabled.
- Block force pushes and branch deletion, including deletion of `develop`.
- Keep merge commits enabled for releases and hotfixes.

Apply these requirements after the setup workflows have run successfully so
GitHub can offer their status-check names in the protection settings.
The policy check validates branch names/PR targets, not Git ancestry or the
completion of a hotfix backport; reviewers must verify those process steps.
