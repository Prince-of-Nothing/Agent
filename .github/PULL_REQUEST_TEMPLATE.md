## Summary

<!-- One paragraph: what changed and why. -->

## Type of change

- [ ] `[FEATURE]` new capability
- [ ] `[FIX]` bug fix
- [ ] `[SECURITY]` hardening
- [ ] `[DOCS]` documentation
- [ ] `[INFRA]` build, CI, or deployment
- [ ] `[REFACTOR]` behavior-preserving restructuring
- [ ] `[TEST]` test-only change
- [ ] `[PERF]` measured performance improvement
- [ ] `[REVERT]` revert of a previous change
- [ ] `[RELEASE]` version bump or packaging

In Conventional Commits mode, use the matching `feat`, `fix`, `docs`, `ci`,
`build`, `chore(deps)`, `refactor`, `test`, `perf`, `revert`, or
`chore(release)` form instead.

## Scope

- [ ] One concern; the summary explains every changed file
- [ ] No unrelated formatting, renames, refactors, or dependency changes
- [ ] No secrets, real user data, debug output, or commented-out code
- [ ] The linked issue is correct, if one exists

## Changed aspects

Check every aspect this PR touches. Leave a row unchecked and explain why
under Evidence when it does not apply.

- [ ] Application logic: unit or integration tests, lint, and type check
- [ ] Public API, schema, or wire format: contract tests, versioning, client
      compatibility, docs
- [ ] Database or migration: up and down tested; backfill, locks, rollback
      noted
- [ ] Config or environment: example file and docs updated; no secrets
- [ ] Dependency: lockfile, license and audit check, runtime support
- [ ] Auth, authorization, or consent: role matrix, deny cases, session
      lifecycle, audit log
- [ ] UI or interaction: loading, empty, error states; responsive; keyboard and
      screen reader; screenshots
- [ ] Performance-sensitive path: benchmark or profile attached
- [ ] Logging, metrics, or traces: no secrets or PII; actionable fields
- [ ] Build, CI, or deploy: pipeline green; rollback plan noted
- [ ] Generated or vendored files: regenerated from source, no manual edits
- [ ] Docs, changelog, ADR: updated or N/A
- [ ] Release or packaging: version, notes, artifacts, tag plan

## Verification evidence

- [ ] Focused tests: `<command>` -> `<result>`
- [ ] Full gate: `<command>` -> `<result>`
- [ ] Lint and type check: `<command>` -> `<result>`
- [ ] Manual or browser check: `<what>` -> `<result>`
- [ ] For behavior changes, the test fails without the change (noted in
      Evidence). For non-behavior changes, the equivalent check is present
- [ ] CI is green; any pre-existing failure is named
- [ ] Screenshots or recordings attached for UI changes

## Risk and rollback

<!-- What can break? How do we roll it back? Note migrations, compatibility,
or feature flags. -->

## Evidence

<!-- Commands and results, screenshots, recordings, or logs. -->

## Review and merge

- [ ] Review comments resolved or answered with evidence
- [ ] Required approvals are present
- [ ] The user authorized the merge; no self-merge unless repository policy
      allows it
- [ ] Branch rebased on the default branch
- [ ] PR title carries the type flag or the Conventional equivalent
- [ ] Squash-and-merge unless the repository says otherwise, then delete the
      branch

## Related

Closes #<!-- use Closes #N or Refs #N when an issue exists -->
