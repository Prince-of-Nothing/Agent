# Branches, Commits, and Pull Requests

> Owner of branch, commit, review, and release rules. `AGENTS.md` links here.

## 1. Branch model

The protected default branch (usually `main`) stays release-ready.

- Never commit or push directly to it.
- Discover the default branch (`git symbolic-ref refs/remotes/origin/HEAD` or
  `gh repo view --json defaultBranchRef`) and fetch before branching.
- Before the first edit, create or switch to the branch. If the tree is dirty
  on the default branch, branch in place and keep the changes; do not commit
  them there.
- Branch from an up-to-date default branch:
  `feat/<slug>`, `fix/<slug>`, `docs/<slug>`, `infra/<slug>`,
  `refactor/<slug>`, `test/<slug>`, `perf/<slug>`, `revert/<slug>`, or
  `release/vX.Y.Z`.
- Use lowercase kebab-case slugs: `feat/cursor-pagination`, not
  `feat/CursorPagination`.
- One concern per branch and pull request.
- Keep branches short-lived. Rebase on the default branch; do not stack a
  branch on another unmerged branch.
- For independent parallel work, create one git worktree per task
  (`using-git-worktrees`). Merge the base change first if branches would
  overlap.
### Authorization

| Action | Rule |
|---|---|
| Read, search, edit, run local checks | Allowed on your branch |
| Commit on your feature branch | Allowed |
| Push a branch, open or update a PR | Only when the user asks |
| Merge a PR | Only with green CI, required approvals, and explicit authorization. Do not self-merge unless the repository policy allows it |
| Force push | Explicit approval; own branch only; `--force-with-lease` |
| Discard work, delete a branch, tag, publish, deploy | Explicit approval, except deleting the merged branch after the authorized merge |

## 2. Commit format

```text
[TYPE] area: imperative summary

Why the change is needed. What changes at a high level, not a restatement
of the diff. Include migration, compatibility, or rollback notes when they
matter.

Refs #N
```

Rules:

- Subject at or under 72 characters, no trailing period, imperative mood.
- `area` names the module, package, service, or platform.
- One logical change per commit. A commit should build and pass its focused
  checks on its own.
- Put the reason in the body. Reviewers can read the diff for the what.
- Reference the issue with `Refs #N` or `Closes #N`, if one exists.
- Do not add `Co-authored-by:` trailers unless the repository policy requires
  them. If a DCO sign-off is required, add `Signed-off-by:`.
- Never commit secrets, tokens, credentials, real user data, or debug output.

### Type flags

| Flag | Use for | Example |
|---|---|---|
| `[FEATURE]` | New user-visible capability or meaningful extension | `[FEATURE] billing: add invoice export` |
| `[FIX]` | Bug or regression fix | `[FIX] auth: reject expired refresh tokens` |
| `[SECURITY]` | Hardening that is not a public vulnerability report | `[SECURITY] uploads: allowlist file types` |
| `[DOCS]` | Documentation only | `[DOCS] workflow: document release steps` |
| `[INFRA]` | Build, CI, deployment, dependencies | `[INFRA] ci: cache dependencies` |
| `[REFACTOR]` | Behavior-preserving restructuring | `[REFACTOR] search: split the query parser` |
| `[TEST]` | Test-only change | `[TEST] billing: cover prorated refunds` |
| `[PERF]` | Measured performance improvement | `[PERF] feed: remove the N+1 query` |
| `[REVERT]` | Revert of a previous change | `[REVERT] auth: revert token rotation` |
| `[RELEASE]` | Version bump, notes, packaging | `[RELEASE] v2.4.0` |

Use the smallest flag that describes the change. Do not mix flags in one
commit. `[RELEASE]` is the exception to the `area:` format: it is
`[RELEASE] vX.Y.Z`.

### Conventional Commits mode

When a repository uses Conventional Commits, use that form for commits and PR
titles, and do not use the bracketed flags in the same history:

| Flag | Conventional form |
|---|---|
| `[FEATURE]` | `feat(area): ...` |
| `[FIX]` | `fix(area): ...` |
| `[SECURITY]` | `fix(area): ...` or `refactor(area): ...` |
| `[DOCS]` | `docs(area): ...` |
| `[INFRA]` | `ci(area): ...`, `build(area): ...`, or `chore(deps): ...` |
| `[REFACTOR]` | `refactor(area): ...` |
| `[TEST]` | `test(area): ...` |
| `[PERF]` | `perf(area): ...` |
| `[REVERT]` | `revert: ...` |
| `[RELEASE]` | `chore(release): vX.Y.Z` |

### Examples

Good:

```text
[FIX] sessions: revoke the family when a refresh token is reused
```

Bad:

```text
fixed stuff
```

```text
[FIX] Updated the session code and also refactored the user model and bumped deps
```

### Secret exposure

If a secret is committed or pushed:

1. Stop. Do not push again or share the value.
2. Rotate or revoke the credential immediately.
3. Notify the private security channel. Never paste the secret into an issue,
   chat, or pull request.
4. Remove it from history only with explicit approval. Assume anything pushed
   is already public.
5. Add a secret scan so the same path fails before the next commit.

## 3. Pull requests

The PR title carries the same type flag as the commit, or the Conventional
form when the repository uses that mode:

```text
[FEATURE] billing: add invoice export
feat(billing): add invoice export
```

The body answers:

- What changed and why.
- How it was tested, with commands and results.
- Risk, compatibility, and rollback.
- Screenshots or recordings for UI changes.
- The linked issue, if one exists: `Closes #N` or `Refs #N`.

Rules:

- Keep the PR small enough to review in one sitting. Split by concern when it
  grows.
- Open a draft while work is in progress; mark it ready only when the gate is
  green.
- Rebase on the default branch before merge. Do not merge the default branch
  into a feature branch repeatedly.
- Merge only after CI passes, required approvals are present, and the user
  authorizes it. Do not self-merge unless the repository policy allows it. Use
  squash-and-merge unless the repository says otherwise, so the default branch
  keeps one type-flagged commit per change.
- Delete the merged branch after the authorized merge.
- After merge, update the local default branch and create the next branch from
  it.

Force pushing:

- Requires explicit approval.
- Allowed only on your own feature branch, with `--force-with-lease`.
- Never force push a shared branch or the default branch.
- Never rewrite history that someone else is reviewing without telling them.

### PR checklist

Walk this before requesting review and again before merging. Mark an item N/A
with a reason only when it genuinely does not apply. The pull request template
is the executable subset; this list is authoritative.

#### Scope and intent

- [ ] One concern, matching the PR title and type flag.
- [ ] Every changed file is explained by the description.
- [ ] No unrelated formatting, renames, refactors, or dependency changes.
- [ ] The linked issue is correct, if one exists (`Closes #N` or `Refs #N`).
- [ ] No secrets, real user data, debug output, commented-out code, or TODOs
      without an issue.

#### Correctness

- [ ] The behavior matches the request and the approved design.
- [ ] For behavior changes, the tests fail without the change and pass with it.
- [ ] For non-behavior changes, the equivalent check is present: link check,
      config validation, dry run, or manual evidence.
- [ ] The test level matches the risk: unit, integration, contract, or E2E.
- [ ] Edge cases are covered: empty, null, boundary, duplicate, concurrent,
      timeout, retry.
- [ ] Error paths return the documented status and fail closed.
- [ ] Backward compatibility is preserved or the break is documented.

#### Changed aspects

Check every row this PR touches. If none of the extra rows apply, say so.

| If the PR changes | Verify |
|---|---|
| Application logic | Unit or integration tests, lint, and type check |
| Public API, schema, or wire format | Contract tests, versioning, client compatibility, docs |
| Database or migration | Up and down migration, backfill, locks, rollback, backup |
| Config or environment | Example file, documented variable names, defaults, validation, no secrets |
| Dependency | Lockfile, license and audit check, runtime support, bundle or image size |
| Auth, authorization, or consent | Role matrix, deny cases, token or session lifecycle, audit log |
| UI or interaction | Loading, empty, and error states; responsive layout; keyboard and screen reader; screenshots |
| Performance-sensitive path | Benchmark or profile, complexity, N+1 queries, cache behavior |
| Logging, metrics, or traces | No secrets or PII, actionable level, useful fields, no noise |
| Build, CI, or deploy | Pipeline green, reproducible build, cache correctness, rollback |
| Generated or vendored code | Regenerated from source, no manual edits |
| Docs | Links resolve, examples run, changelog and decision record updated if used |
| Release or packaging | Version bump, notes, artifacts, tag plan, upgrade path |

#### Security and data

- [ ] Input is validated at the trust boundary.
- [ ] Authorization is enforced server-side, not only in the client.
- [ ] Errors and logs do not leak internal details, secrets, or personal data.
- [ ] New dependencies and external calls are reviewed for trust and license.
- [ ] Destructive actions have a guard, a confirmation, and a rollback.
- [ ] The change does not widen an allowlist or bypass an approval without an
      explicit decision.

#### Verification evidence

- [ ] Focused checks: `<command>` -> `<result>`.
- [ ] Full gate: `<command>` -> `<result>`.
- [ ] Manual or browser check: `<what>` -> `<result>`.
- [ ] CI is green; any pre-existing failure is named and no new failure was
      introduced.
- [ ] Screenshots or recordings attached for UI changes.

#### Docs and release

- [ ] README and topic docs updated where behavior changed.
- [ ] `CHANGELOG.md` `[Unreleased]` updated, if the repository keeps one.
- [ ] ADR or decision record added if the change is architecture-significant.
- [ ] Migration, compatibility, and rollback notes are in the PR.
- [ ] Version, tag, and upgrade notes are ready for a release PR.

#### Reviewer

- [ ] The title and description match the diff.
- [ ] The tests or equivalent evidence actually exercise the change.
- [ ] The riskiest changed aspect has a test or concrete evidence.
- [ ] Security, privacy, and data boundaries are respected.
- [ ] No unrelated edits, missing docs, or unexplained generated files.
- [ ] Required approvals are present and the user authorized the merge.
- [ ] CI is green and the merge method is correct.

## 4. Releases

- Create `release/vX.Y.Z` from the default branch.
- Freeze scope to the release: version bump, changelog, packaging, notes.
- Run the full gate and the repository's release checklist if it has one.
  Otherwise use the PR checklist plus version, changelog, artifacts, tag,
  upgrade, and rollback steps.
- Open the release PR, get review and explicit authorization, merge, then tag
  the merge commit on the default branch with an annotated `vX.Y.Z` tag. Tag
  and publish only with explicit approval.
- Only the release commit carries `[RELEASE] vX.Y.Z`.
- Publish notes from the changelog, not from a separate draft that can drift.

Hotfixes:

1. Branch `fix/<slug>` from the released tag or the default branch, depending
   on what needs the fix.
2. Apply the smallest fix plus a regression test.
3. Merge through the same PR flow.
4. Tag a patch release with explicit approval. Backport by cherry-picking into
   each affected release branch through its own pull request; never push the
   release branch directly.

## 5. Changelog

When the repository keeps `CHANGELOG.md`, update `[Unreleased]` in the same
change:

```markdown
## [Unreleased]

### Added
- Cursor pagination for list endpoints.

### Fixed
- Refresh token reuse now revokes the whole session family.
```

Use Keep a Changelog categories: Added, Changed, Deprecated, Removed, Fixed,
Security. Write one line per user-visible change. Skip internal churn.

## 6. What "push" means

When the user says "push", "commit and push", or "ship it", and does not say
"merge":

1. Run the full gate.
2. Update the changelog if present.
3. Commit on the current feature branch.
4. Push that branch.
5. Open or update its pull request.

Never push the protected branch. Never push a red tree. If the gate fails, fix
it or report the failure instead of pushing. If the user has not asked, stop
after the commit and do not push or open a PR.

## 7. Authorship

- Commit under the repository's configured git identity. Never change git
  config.
- Do not impersonate another person or a bot.
- Do not add bot or co-author trailers unless the repository policy requires
  them.
- If the repository uses DCO, sign off every commit.
- Preserve the original author when cherry-picking or rebasing someone else's
  work.

## 8. Reverts

Prefer `git revert` over rewriting shared history. Rewrite the generated
subject to `[REVERT] area: ...` or `revert: ...` in Conventional mode. Link
the incident or issue, add a regression test when the cause is known, and
re-land with a fix rather than a silent reapply.
