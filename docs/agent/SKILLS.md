# Skills

> Router for the installed skills. `AGENTS.md` links here. Load a skill before
> acting when it matches the task.

## 1. How skills work

- A skill is a Markdown instruction set with a `description` that tells the
  agent when to use it. The agent loads the body on demand with the `skill`
  tool, using the exact skill ID.
- Load the skill before the first action, including before clarifying
  questions or reading code. Announce it: "Using `<id>` to `<purpose>`."
- Follow the skill's workflow. It may point to supporting files beside
  `SKILL.md`; read them when it says to.
- Skills are instructions, not tools. They do not add permissions, and they
  never override the user's explicit instruction or the repository's security
  rules.
- If a skill is already present in the conversation, do not load it again.

Project-local skills live in:

```text
.opencode/skills/<skill-id>/SKILL.md
.opencode/skills/<skill-id>.md
```

Global skills live in `~/.config/opencode/skills/`. OpenCode also reads the
`.claude/skills/` and `.agents/skills/` compatibility paths. A project skill
with the same ID overrides a global one.

## 2. Selection rules

1. Process skills come first: `brainstorming` before building,
   `systematic-debugging` before fixing, `verification-before-completion`
   before claiming done.
2. If there is even a 1% chance a skill applies, load it.
3. Prefer the narrowest matching skill. Do not load two skills that cover the
   same ground.
4. If no skill applies, proceed with the repository instructions and say so.
5. Repository gates always win. A skill may add detail, never relax a rule,
   gate, or safety boundary. If a skill conflicts with a gate, follow the gate
   and report the conflict.
6. If a listed skill is not installed, follow the corresponding process file
   manually and say which skill was unavailable. If no local process file
   exists, use the repository rules, state the limitation, and do not invent the
   skill's workflow.
7. `ponytail` is standing: apply it on every coding task at the level the user
   set (`lite`, `full` by default, `ultra`), alongside the task's process skill.

## 3. Installed skills

> TODO for adopters: this table mirrors the kit author's OpenCode environment.
> Keep the rows for skills the team installs and delete the rest, along with
> any workflow reference that depends on them. Add repo-local skills under
> `.opencode/skills/<id>/SKILL.md`. Follow the matching process file by hand
> when a skill is not installed.

| Skill ID | Load when | What it gives you |
|---|---|---|
| `using-superpowers` | When skill discovery is not already established | The rule that relevant skills must be invoked before acting |
| `ponytail` | Every coding task: writing, fixing, refactoring, reviewing, or choosing dependencies | The smallest complete change, and the extras worth skipping |
| `brainstorming` | Before any new feature, component, behavior change, or plan | Questions, approaches, a design document, and an approval gate |
| `writing-plans` | After a design is approved and the work is multi-step | Bite-sized tasks with exact files, interfaces, tests, and commits |
| `executing-plans` | You are implementing a plan yourself, task by task | A disciplined inline execution loop |
| `subagent-driven-development` | A plan has independent tasks and you want fresh context per task | One subagent per task plus a reviewer before the next task |
| `dispatching-parallel-agents` | Two or more tasks have no shared state or sequential dependency | Parallel subagent dispatch with explicit ownership |
| `using-git-worktrees` | Feature work needs isolation or several tasks run in parallel | A separate working tree per task, with cleanup rules |
| `test-driven-development` | Before writing implementation code for any behavior | Red, green, refactor, with the failing test first |
| `systematic-debugging` | Any bug, failing test, or unexpected behavior | Evidence gathering, reproduction, root cause, then a fix |
| `verification-before-completion` | Before saying work is done, fixed, or passing | Required commands and observed output before any success claim |
| `requesting-code-review` | After a feature or major task, before merge | A review request with the right context and checklist |
| `receiving-code-review` | When review feedback arrives | Technical verification of each comment before implementing it |
| `finishing-a-development-branch` | Implementation is complete and tests pass | A recommendation to merge, open a PR, keep, or discard, then cleanup after authorization |
| `frontend-design` | Building or reshaping a user interface | Aesthetic direction, typography, layout, and non-default visual choices |
| `webapp-testing` | Verifying a local web app in a real browser | Playwright flows, screenshots, console and network evidence |
| `browser` | Interacting with the in-app browser for a page or app | Open, read, click, fill, screenshot, console, network, performance |
| `graphify` | A question about codebase structure, relationships, or architecture | Build, query, path, explain, and report on a knowledge graph |
| `mcp-builder` | Building an MCP server in Python or TypeScript | Protocol guidance, tool design, schemas, and testing |
| `skill-creator` | Creating, editing, or evaluating a skill | Skill structure, description optimization, and evals |
| `writing-skills` | Authoring or verifying a skill before deployment | Portable skill format and verification workflow |
| `stop-slop` | Drafting or editing prose for humans | Removal of filler, passive voice, and formulaic AI patterns |
| `reverse-engineer-anything` | A shipped binary, Electron app, firmware, or browser target needs analysis | REA workflow and evidence-backed reconstruction |
| `opencode` | Any question about OpenCode itself | Config, agents, skills, tools, providers, CLI, SDK, plugins |
| `report` | An OpenCode issue or bug needs a public report | Diagnostics collection and a GitHub issue |
| `diagnosing-superpowers` | A superpowers session went wrong and needs a postmortem | Session analysis and a bug report for maintainers |

## 4. Recipes

### New feature

1. `brainstorming`
2. `writing-plans`
3. `using-git-worktrees` (if isolation helps)
4. `executing-plans` or `subagent-driven-development`
5. `test-driven-development`
6. `requesting-code-review`, then `receiving-code-review`
7. `verification-before-completion`
8. `finishing-a-development-branch`

### Bug fix

1. `systematic-debugging`
2. `test-driven-development` (write the regression test)
3. `verification-before-completion`

Use `requesting-code-review` when the fix touches a public interface or
security boundary.

### Parallel work

1. `dispatching-parallel-agents` to split independent tasks.
2. `using-git-worktrees` so each worker has its own tree.
3. `subagent-driven-development` when each task also needs an independent
   reviewer.
4. Integrate, then run the full gate.

### UI work

1. `frontend-design` for the visual direction.
2. `webapp-testing` for a local app.
3. `browser` for the in-app browser.
4. Capture screenshots and console evidence before claiming it works.

### Architecture question

1. `graphify` if `graphify-out/graph.json` exists.
2. Fall back to targeted search and reading.
3. Build a graph when questions repeat or the corpus is large and unfamiliar.

### Skill or MCP work

- New or revised skill: `skill-creator` to design, edit, and evaluate it, then
  `writing-skills` to verify portability and deployment readiness.
- New MCP server: `mcp-builder`, then test it with a real client.

### OpenCode work

- Behavior, configuration, or API question: `opencode`.
- Reproducible bug to publish: `report`.
- Superpowers session postmortem: `diagnosing-superpowers`.

### Prose work

- `stop-slop` before delivering documentation, release notes, or copy.

## 5. Add a project skill

Use a project skill when a procedure is specific to this repository and recurs:
release steps, migration steps, deployment, or a domain checklist.

```markdown
---
name: <Human Readable Name>
description: "<When to use it, with the trigger words a future task would contain>"
---

# <Human Readable Name>

## When to use

- <Trigger>

## Workflow

1. <Step>
2. <Step>

## References

- `<path>` - <what it contains>
```

Rules:

- Put scripts and references beside `SKILL.md`; paths inside the skill are
  relative to that directory.
- Write the description for discovery. Include the words a future request
  would use.
- Do not duplicate a global skill. Override it deliberately with the same ID
  only when the project differs.
- Test the skill on a real task before relying on it.
- Remove or update a skill when the procedure changes.

## 6. Troubleshooting

If a skill is missing:

1. Confirm the file is a root-level `<id>.md` or a nested `SKILL.md`.
2. Check the path-derived, case-sensitive ID, not the frontmatter name.
3. Add a `description`; skills without one are not advertised.
4. Check `metadata` with `opencode/autoinvoke: false` (or
   `disable-model-invocation: true`) and the skill permission rules.
5. Check whether a later source defines the same ID and overrides it.
