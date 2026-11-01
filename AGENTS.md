# AGENTS.md

> Agent entrypoint. Keep it short, factual, and current.
> Kit repository note: this repo is the starter kit itself. When editing it,
> keep the instructions generic and do not fill the placeholders. When adopting
> the kit, replace every angle-bracket placeholder and `TODO:`, delete this
> note and any sections that do not apply. Depth lives in `docs/agent/` and
> loads only when needed.

## 1. Project profile

TODO: what this repository is, who it serves, and the stack.

- Toolchain: `<...>`
- Languages: `<...>`
- Entrypoints: `<...>`
- Canonical docs: `README.md`, `docs/agent/ARCHITECTURE.md`, `<...>`
- Owner / reviewer: `<...>`

## 2. Instruction precedence

1. The user's explicit instruction for this task.
2. This file and the nearest `AGENTS.md`.
3. `docs/agent/*.md`, `README.md`, `CONTRIBUTING.md`, and any decision records.
4. Skill defaults.

Section 3 and branch protection are absolute. A user request that conflicts
with them stops the task: explain the conflict and propose a safe alternative.
Skills may add detail but never relax a repository gate.

## 3. Non-negotiables

- Never commit or push to the protected default branch. Branch before the first
  edit; if the tree is dirty, branch in place and keep the changes.
- Never print, commit, or invent secrets. If one is exposed, stop, rotate it,
  notify the private security channel, and remove it from history only with
  explicit approval.
- Never claim completion without the gate and its output. Never delete, skip,
  weaken, or auto-update a test or snapshot to get green.
- Keep changes small and single-purpose; read before overwriting; never discard
  uncommitted work.
- Do not add dependencies, run shared or production migrations, deploy, publish,
  delete data, tag, or spend money without explicit approval. Local test
  migrations and lockfile updates through the package manager are allowed.
- Treat generated and vendored files as read-only unless the generator produced
  the change. Never change git config or commit under another identity.
- If a change crosses a boundary above, stop and propose the smallest safe step.

## 4. Before you start

1. Read this file, the nearest `AGENTS.md`, and `git status --short --branch`.
2. Discover the default branch (`git symbolic-ref refs/remotes/origin/HEAD` or
   `gh repo view --json defaultBranchRef`), fetch, and if you are on it, create
   the branch before the first edit:
   `git switch -c <prefix>/<slug> origin/<default>`. If the tree is dirty,
   branch in place.
3. Discover commands from manifests, `Makefile`, CI, `README.md`, and
   `CONTRIBUTING.md`. Do not guess.
4. If `graphify-out/graph.json` exists, check freshness before querying.
5. If the repository has a skills router, load the matching skill from
   `docs/agent/SKILLS.md`. If there is even a 1% chance a skill applies, load
   it. If it is missing, follow the local process file or the repository rules
   and say the skill was unavailable.
6. Run the brainstorming process before writing code for a new feature or
   behavior change; load the `brainstorming` skill if installed.

## 5. Workflow

| Task size | Path |
|---|---|
| Quick fix | Regression test or equivalent check, change, verify, commit |
| Small change | Short design, tests, implementation, review, verify |
| Feature or project | `brainstorming` -> design -> `writing-plans` -> execute -> review -> verify -> integrate |

- Behavior changes start with a failing test; non-behavior changes use the
  equivalent check: link check, config validation, dry run, or manual evidence.
- Apply `ponytail` on every coding task: the smallest complete change, with no
  unasked feature, abstraction, or dependency.
- Debug from evidence (`systematic-debugging`). Review before merge
  (`requesting-code-review`) and verify feedback before implementing it
  (`receiving-code-review`).
- Focused check before each commit, full gate before push,
  `verification-before-completion` before a completion claim or PR.
- Stop and ask on conflicting requirements, a destructive action, or a gate
  failure outside the change.

Details: `docs/agent/WORKFLOW.md`.

## 6. Commands and gates

Replace this block with the repository's real commands. Derive them from the
sources in section 4 and state which source you used.

```bash
<install>
<fast loop>
<full gate before push>
```

- Narrowest check while iterating; full gate before push.
- Fix or report a failing gate. Never bypass with `--no-verify`, skipped tests,
  disabled lint, or lowered thresholds.

Details: `docs/agent/TESTING.md`.

## 7. Code navigation and the knowledge graph

- Architecture question: if `graphify-out/graph.json` exists, check freshness
  first. Compare "Built from commit" with `git rev-parse --short=8 HEAD`; update
  on a mismatch or an uncommitted structural change, then query. Fall back to
  search when the graph is stale.
- A one-off lookup in a known area: plain search. `graphify-out/` is generated;
  commit it only if the team shares it, and never let it capture secrets.

Commands, structural-change examples, and limits: `docs/agent/GRAPHIFY.md`.
Skill: `graphify`.

## 8. Architecture boundaries

- Module map, dependencies, and invariants: `docs/agent/ARCHITECTURE.md`.
- Prefer additive seams over rewrites: add a module, handler, migration, or
  adapter beside the existing one.
- Cross a layer boundary only with a decision record: an ADR if the repository
  uses them, otherwise a note in `ARCHITECTURE.md`.
- Docs follow code in the same PR. Diagrams are Mermaid text; link canonical
  docs instead of copying them.

## 9. Branching and authorization

The protected default branch stays release-ready. Never commit or push to it.

- Branch from an up-to-date default using the prefixes in
  `docs/agent/COMMITS.md#1-branch-model`.
- One concern per branch and PR. Rebase; no long-lived or stacked branches.
- Parallel work: one worktree per task (`using-git-worktrees`), one writer per
  file or module.
- Push only when the user asks. Merge only with green CI, required approvals,
  and explicit authorization. Force-push, discard, tag, publish, delete, and
  deploy need explicit approval, except deleting the merged branch after the
  authorized merge. Use the configured git identity; never change git config.

Authorization matrix and branch rules: `docs/agent/COMMITS.md#authorization`.

## 10. Commits

Start every subject with a type flag and `area:`; `[RELEASE]` is the exception:
`[RELEASE] vX.Y.Z`. The full set and the Conventional mapping are in
`docs/agent/COMMITS.md`.

- Imperative, at or under 72 characters; reason in the body; one logical change
  per commit.
- No `Co-authored-by:` trailers unless the repository policy requires them.
  Update `CHANGELOG.md` under `[Unreleased]` when the repository keeps one.

## 11. Pull requests

If the repository has a PR checklist (normally
`docs/agent/COMMITS.md#pr-checklist`), walk it before review and again before
merge. Otherwise these three items are the definition of done:

- [ ] One concern and the correct title flag; issue linked if one exists.
- [ ] Evidence for every changed aspect and a green full gate.
- [ ] No secrets, real data, debug code, or unrelated edits.

The title carries the type flag or the Conventional equivalent. Merge only
after CI, required approvals, and user authorization, then squash-and-merge and
delete the branch. After merge, update the default branch and branch again from
it.

Template: `.github/PULL_REQUEST_TEMPLATE.md`. Issue rules, if used:
`docs/agent/ISSUES.md`.
