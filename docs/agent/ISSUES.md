# Issues

> Owner of the issue tracker rules. `AGENTS.md` links here. Delete this file if
> the repository does not use typed issues.

## 1. Type

Every issue has exactly one type:

| Type | Use for |
|---|---|
| **Bug** | Behavior that differs from the documented contract |
| **Feature** | A new user-visible capability or a meaningful extension |
| **Task** | Docs, build, CI, deployment, release chores, security hardening, maintenance |

The type is authoritative. Labels are secondary filters.

## 2. Title ID

Titles use `PREFIX-n: short imperative summary`. IDs are optional: if the
repository does not use them, keep the type and labels and use a plain
imperative title.

```text
FEAT-6: Add invoice export
```

| Prefix | Type | Use for |
|---|---|---|
| `BUG` | Bug | Defects and regressions |
| `FEAT` | Feature | User-visible features and epics |
| `INFRA` | Task | Build, CI, deployment, dependencies |
| `DOCS` | Task | Documentation and process |
| `SEC` | Task | Hardening that is not a private vulnerability report |
| `TASK` | Task | Maintenance that fits no other prefix |

Rules:

- IDs are per prefix, increase monotonically, and are never reused.
- GitHub's `#N` remains the canonical reference for commits, pull requests, and
  `Closes #N`. The typed ID is for humans and filters.
- Do not renumber closed issues.

To find the next ID, compute the numeric maximum across all matching issues,
not just the first page:

```bash
gh issue list --repo <owner>/<repo> --state all --limit 1000 \
  --search 'in:title "FEAT-"' --json title \
  --jq '[.[].title | try (capture("FEAT-(?<n>[0-9]+)").n | tonumber)] | max'
```

If the result is `null`, start at 1. GitHub returns at most 1,000 results per
search; for larger repositories, drop manual IDs and use `#N`. If you drop IDs,
remove the prefix from the issue templates as well.

## 3. Severity

Severity answers "how bad is the impact if this stays unfixed?"

| Label | Meaning | Typical action |
|---|---|---|
| `severity:critical` | Safety, privacy, or security breach; data loss; no usable public service; release blocker | Stop and fix before the next release |
| `severity:important` | A major feature is broken or has only an unsafe or painful workaround | Fix in the current or next release |
| `severity:medium` | Limited impact, or a reasonable workaround exists | Schedule normally |
| `severity:minor` | Cosmetic, documentation, or low-impact process issue | Backlog or opportunistic |

## 4. Priority

Priority answers "when do we act?"

| Label | Meaning |
|---|---|
| `priority:asap` | Drop planned work; act now. Use sparingly |
| `priority:high` | Current milestone, or next after in-flight work |
| `priority:normal` | Scheduled; the default for triaged work |
| `priority:low` | Backlog, opportunistic, or blocked by an external decision |

Severity and priority are independent. A blocked issue still gets a priority,
usually `priority:low` until it is unblocked.

## 5. Labels

Each open issue should have exactly one `severity:*` and one `priority:*`
label. Add domain and workflow labels as needed.

| Group | Labels |
|---|---|
| Severity | `severity:critical`, `severity:important`, `severity:medium`, `severity:minor` |
| Priority | `priority:asap`, `priority:high`, `priority:normal`, `priority:low` |
| Kind | `bug`, `enhancement`, `documentation`, `accessibility`, `security`, `dependencies` |
| Domain | `<area>`, for example `api`, `web`, `mobile`, `infra` |
| Workflow | `epic`, `blocked`, `needs:compliance`, `good first issue`, `help wanted`, `skip-issue-link` (maintainer exception for release or tooling PRs only) |
| State | `duplicate`, `invalid`, `question`, `wontfix` |

Keep the label set small. Remove labels that duplicate the issue type or the PR
title flag.

## 6. Triage checklist

For every new issue:

1. Set the type. If GitHub Issue Types are not enabled, use the `bug`,
   `enhancement`, or `documentation` label and keep the type in the title
   prefix.
2. Rename the title to the next `PREFIX-n`, if the repository uses IDs.
3. Add one `severity:*` label.
4. Add one `priority:*` label.
5. Add domain labels, and `needs:compliance` when privacy, consent, security,
   or personal data is involved.
6. Add `blocked` when only the owner can unblock it, and state exactly what is
   needed in the body.
7. Link the fixing PR with `Closes #N`, or `Refs #N` for partial work, if an
   issue exists.

Example:

```bash
gh issue edit <number> --repo <owner>/<repo> \
  --type Bug \
  --title "BUG-1: Update check fails on startup" \
  --add-label severity:important,priority:high
```

If issue types or IDs are disabled, drop `--type` and the title prefix:

```bash
gh issue edit <number> --repo <owner>/<repo> \
  --title "Update check fails on startup" \
  --add-label bug,severity:important,priority:high
```

## 7. Create an issue

Use the templates in `.github/ISSUE_TEMPLATE/`. A bug needs reproduction
steps, expected vs actual, environment, and evidence. A feature needs the
problem, the proposal, alternatives, and acceptance criteria. A task needs
scope, done criteria, and risks.

```bash
gh issue create --repo <owner>/<repo> \
  --title "FEAT-7: <summary>" \
  --body "<problem, proposal, acceptance criteria>"
```

If the repository does not use issue types, add the matching kind label after
creation instead of `--type`. If it does not use IDs, use a plain title without
the prefix.

Set the type and labels immediately after creation with the GitHub UI or
`gh issue edit --type`. If issue types are unavailable, add the matching kind
label instead. An untriaged issue is not ready to work.

## 8. Linking and closing

- `Closes #N` closes the issue when the PR merges.
- `Refs #N` links partial work without closing.
- Close only when the change is merged and, for a release issue, shipped.
- Re-scope by editing the title and labels and adding a comment that explains
  what changed. Do not open a duplicate.

## 9. Security reports

Never open a public issue for a vulnerability. Follow the repository's private
security policy, for example `SECURITY.md`, and use the private reporting
channel. If no policy exists, ask the owner before posting details. Public
hardening tasks use the `SEC` prefix and `severity:*` labels, without
disclosing an unpatched exploit.

## 10. Tracker hygiene

- Search before creating. Duplicates cost more than they save.
- One issue per outcome. Split unrelated work.
- Keep the acceptance criteria in the body, not in a comment thread.
- Update or close stale issues instead of leaving them open indefinitely.
