# Workflow

> Owner of the request-to-merge lifecycle. `AGENTS.md` links here. Load this
> file before starting any non-trivial task.

## 1. Size the task first

| Size | Signals | Path |
|---|---|---|
| Quick fix | One file, obvious cause, reversible, no interface change | Regression test or equivalent check, change, verify, commit |
| Small change | A few files, one clear approach, low risk | Short design, tests, implement, review, verify |
| Project | New feature, refactor, migration, new subsystem, unclear approach, irreversible step | Full lifecycle below |

If a task grows past its size, stop and step up. Do not quietly turn a fix into
a refactor.

## 2. Phase 0: Understand

Read before asking.

1. Read the nearest `AGENTS.md` and `docs/agent/ARCHITECTURE.md`.
2. Run `git status --short --branch` and `git log --oneline -10`.
3. Discover the default branch (`git symbolic-ref refs/remotes/origin/HEAD` or
   `gh repo view --json defaultBranchRef`), fetch, and if you are on it, create
   the branch before the first edit:
   `git switch -c <prefix>/<slug> origin/<default>`. If the tree is dirty,
   branch in place.
4. If `graphify-out/graph.json` exists, check freshness before querying
   (`docs/agent/GRAPHIFY.md`).
5. Read the tests and the code that the change will touch.
6. Check manifests, CI config, and `README.md` for the real commands.

Restate the request in one paragraph: the outcome, who it serves, why it
matters, and the constraints you found. Ask only questions whose answers would
change what gets built. Ask one at a time.

Output: a short problem statement, the areas to touch, and any constraint that
changes the approach.

## 3. Phase 1: Design

Use the `brainstorming` skill for new features, components, or behavior
changes. It covers the conversation, the approaches, the design document, and
the approval gate.

The design document answers:

- Intent and why.
- Goals, non-goals, and anti-goals.
- Constraints: compatibility, security, performance, deadlines.
- Two or three approaches, what each trades off, and the chosen one.
- What is left to the builder.

Save it where the repository keeps designs, for example
`docs/designs/YYYY-MM-DD-<topic>-design.md`, and create that directory if it
does not exist. Get approval before writing product code.

For a small change with one sensible approach, the short design in the task
message or PR body is enough. For a spike, label it throwaway and keep it out
of the product path. Keeping the spike is a new request.

## 4. Phase 2: Plan

Use the `writing-plans` skill after the design is approved. The plan is written
for someone who has not seen the code or the design.

Each task states:

- Files to create or modify, with exact paths.
- Interfaces the task consumes and produces.
- The failing test, or the equivalent check for a non-behavior task, the
  command that shows it failing, the implementation, and the command that shows
  it passing.
- The commit.

Right-size tasks: the smallest unit that has its own test cycle and is worth a
reviewer's gate. Fold setup and documentation into the task that needs them.

Before execution, self-review the plan:

1. Every requirement maps to a task.
2. Every step produces one unambiguous action.
3. Names and signatures match across tasks.
4. The risky inputs and failure modes have tests.
5. The plan is not longer than the change it describes.

Choose an execution mode:

- `executing-plans`: you implement every task in this session.
- `subagent-driven-development`: a fresh subagent implements each task and a
  fresh reviewer checks it before the next one starts.

Use subagents when tasks are independent and a mistake would touch a public
API, a migration, a security boundary, or a release. Use inline execution when
the tasks share a lot of context.

## 5. Phase 3: Execute

- Work one task at a time. Update the plan after each task.
- For behavior changes, write the failing test first
  (`test-driven-development`). For non-behavior changes, use the equivalent
  check.
- Read a file before editing it. Preserve uncommitted work.
- Keep commits small and single-purpose.
- Run the focused check after each task; run the full gate before push.
- Use a git worktree for isolated feature work (`using-git-worktrees`).

Parallel work:

- Use `dispatching-parallel-agents` only for tasks with no shared state.
- Define file ownership before dispatch. One writer per file or module.
- Assign ports, databases or schemas, build caches, lockfiles, and generated
  files to one worker. Serialize shared files and define the merge order.
- Agree on interfaces before parallel work starts.
- Run integration and the full gate after merging the parallel results.

Stop and ask when:

- Two instructions cannot both be satisfied.
- The change needs a destructive or irreversible action.
- A gate fails for a reason outside the change.
- A dependency, migration, deployment, or cost decision is involved.
- The evidence contradicts the request.

## 6. Phase 4: Review

Use `requesting-code-review` after a major task and before merge. A reviewer
checks:

- Correctness against the request and the design.
- Tests: for behavior changes, do they fail without the change and pass with
  it? For non-behavior changes, is the equivalent check present?
- Boundaries: does the change respect the architecture and dependency rules?
- Security: input validation, authorization, secrets, logging.
- Performance: obvious regressions on hot paths.
- Docs, changelog, and decision-record updates where applicable.
- Scope: unrelated edits, dead code, debug leftovers.

When you receive feedback, use `receiving-code-review`. Verify each comment
against the code and the design before implementing it. Classify it as accept,
reject with evidence, or discuss. Do not agree just to be agreeable.

## 7. Phase 5: Verify

Run the focused check before each commit, the full gate before push, and
`verification-before-completion` before a completion claim or PR. Record:

| Check | Command | Result |
|---|---|---|
| Focused test | `<...>` | `<pass/fail + output>` |
| Full gate | `<...>` | `<pass/fail + output>` |
| Lint / types | `<...>` | `<pass/fail + output>` |
| Manual check | `<...>` | `<what you saw>` |

Also inspect `git diff` for secrets, debug output, generated files, and
unrelated changes. If a command did not run, say so. Never claim a pass you did
not observe.

If the gate has pre-existing failures, run it on a clean base and record the
failure set, run it with the change and record that set, then report both. Do
not hide a failure or blame it on the environment without evidence.

## 8. Phase 6: Integrate

Use `finishing-a-development-branch` when implementation is complete and tests
pass. It proposes merge, pull request, keeping the branch, or discarding the
work. Merge, discard, tag, publish, delete, and force-push need the explicit
authorization in `AGENTS.md` section 9, except deleting the merged branch after
the authorized merge. Never discard uncommitted work.

Follow the repository's PR rules in `docs/agent/COMMITS.md`; if a checklist
exists, use it. After merge:

1. Update the local default branch.
2. Delete the merged branch after the authorized merge.
3. Close or update the linked issue, if one exists.
4. Remove the worktree if one was used.

## 9. Handoff format

End every task with:

- What changed and why.
- Files touched.
- Commands run and their results.
- What is not verified or still open.
- The next concrete step.

## 10. Context hygiene

- Load the topic file you need, not every file in `docs/agent/`.
- Summarize long command output; keep the failure lines and the exit code.
- Keep the plan current instead of repeating it in chat.
- Prefer graph queries and targeted reads over dumping whole directories.
- Start a fresh subagent for independent work instead of carrying a long
  context into it.

## 11. Anti-patterns

- Writing code before the design is approved on project-sized work.
- Guessing a command instead of reading the manifest or CI config.
- Mixing a refactor with a behavior change.
- Retry-looping a flaky test instead of finding the cause.
- Deleting, skipping, weakening, or auto-updating a test or snapshot to get
  green.
- Declaring success without the command output.
- Rewriting or deleting work you did not create.
- Keeping a spike in production without a new design and test pass.
