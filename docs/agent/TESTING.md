# Testing and Verification

> Owner of test strategy, gate discovery, and evidence. `AGENTS.md` links here.

## 1. Principles

- Test behavior, not implementation details.
- Every behavior bug fix starts with a regression test. A non-behavior fix uses
  the equivalent check: link check, config validation, dry run, or manual
  evidence.
- Run the narrowest useful check while iterating. Run the focused check before
  each commit, and the full gate before push.
- Tests are evidence. A claim without a command and its output is not evidence.
- Keep fixtures deterministic: no sleeps, no live network by default, no shared
  mutable state, no real user data.
- Never put secrets, tokens, or production data in tests or logs.

## 2. The TDD loop

1. Write a failing test for the smallest behavior.
2. Run it and confirm it fails for the expected reason, not a typo or missing
   import.
3. Implement the minimum that makes it pass.
4. Run it and confirm it passes.
5. Refactor with the test green.
6. Commit the test and the implementation together.

Rules:

- One behavior per cycle.
- Do not write the implementation first and backfill tests.
- If a behavior cannot be tested at the current level, move it to a seam where
  it can be, or explain why in the PR.
- A test that passes before the change proves nothing about the change.

### Test integrity

- Never delete, skip, weaken, or auto-update a failing test or snapshot to get
  green. Fix the cause or report the conflict.
- Inspect every snapshot diff before accepting it.
- A quarantined test needs a tracked note (a linked issue if the repository
  uses issues) and an owner.
- Do not lower a coverage or lint threshold to make a gate pass.

## 3. Test levels

| Level | Covers | Speed | Use for |
|---|---|---|---|
| Unit | Pure logic, validation, formatting, state transitions | Fast | Most behavior |
| Integration | Database, filesystem, HTTP boundary, queue | Medium | Wiring and persistence |
| Contract | API schema, serialization, wire compatibility | Medium | Public interfaces |
| End-to-end | User journeys through the real app | Slow | Critical paths only |
| Smoke | Startup, health, one read and one write | Fast | After deploy |

Prefer the lowest level that can catch the failure. Push a test down when it
only needs internal state; push it up when it needs the real boundary.

## 4. Discover the real gates

Do not guess commands. Read the repository:

- Manifest scripts and task definitions: `package.json`, `pyproject.toml`,
  `Cargo.toml`, `go.mod`, `Makefile`, `justfile`, `Taskfile`, workspace files.
- CI workflows: every `run:` step that executes on pull requests.
- `README.md` and `CONTRIBUTING.md` setup sections.
- `scripts/` and `tools/` directories.
- Lockfiles, because they tell you the package manager.

If sources conflict, CI wins. State which source you used when you report the
run.

Fill this block in the repository copy of `AGENTS.md`:

```bash
# install
<...>

# fast loop
<...>

# full gate
<...>
```

Rules:

- Match CI where possible: same command and tool version. Record environment
  differences; CI is the final gate.
- In a monorepo, run the package-scoped checks while iterating, and the full
  gate when shared code, build config, or dependencies change.
- Do not add a new tool just to run a check. Use what the repository already
  standardizes on.

## 5. Select checks by change

| Change | Minimum evidence |
|---|---|
| Pure logic | Unit tests plus lint and type check |
| Public API or schema | Contract test plus integration test |
| Database or migration | Up and down migration, data test, rollback note |
| UI or interaction | Component test, one end-to-end path, screenshot or recording |
| Dependency | Full gate plus audit or license check if available |
| Infrastructure | Config validation, dry run, and a rollback step |
| Documentation | Link check if available, plus a render preview |

## 6. Security tests

For any change touching authentication, authorization, consent, or personal
data:

- Test each role and the deny case. Default deny wins.
- Test boundary values and malformed input at the trust boundary.
- Test expired, rotated, and revoked credentials.
- Test that errors do not leak internal details or secrets.
- Prove the failure mode is closed, not merely unlikely.
- Use synthetic data only.

## 7. Browser and UI evidence

Reading UI code does not prove the UI works.

- Use the `webapp-testing` skill to drive a local app with Playwright.
- Use the `browser` skill for the in-app browser, and load it before the first
  browser tool call.
- Capture the URL, the steps, expected vs actual, a screenshot, console errors,
  and failed network requests.
- Cover the load path, the primary action, one error state, and one empty
  state. Add a mobile viewport when the product supports it.
- For visual changes, compare before and after screenshots.
- If neither skill is installed, use the repository's browser test setup or
  record manual browser evidence. Do not claim UI behavior from code reading
  alone.

## 8. Flaky tests

- Reproduce with the same seed, order, and environment before changing code.
- Quarantine the test with a tracked note (a linked issue if the repository
  uses issues). Do not delete it silently.
- Fix the cause: time, ordering, shared state, network, or an unstable
  selector.
- Do not retry until green and call it fixed.

## 9. Coverage and test quality

- Coverage is a signal, not a target. Cover risk, not lines.
- Prioritize authentication, authorization, money, data loss, migrations,
  parsing, and concurrency.
- Assert on outcomes, not private methods or call counts.
- Prefer one clear behavior per test.
- Avoid snapshot-only tests for behavior. A snapshot can be regenerated
  without anyone checking whether the new output is correct.

## 10. What not to test

- Framework internals, generated code, and third-party libraries.
- Trivial getters with no logic.
- Exact log wording unless the log is a contract.
- Implementation details that a refactor should be free to change.

## 11. Report results

Include the command, the exit status, and the relevant output:

```text
<command>
Result: PASS | FAIL
<failure excerpt, if any>
```

If a check did not run, say so. If a pre-existing failure exists:

1. Run the gate on a clean base and record the failure set.
2. Run it with the change and record that set.
3. Report both, and name any failure the change adds.

Run `verification-before-completion` before any completion claim.
