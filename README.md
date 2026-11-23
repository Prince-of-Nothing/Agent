# Agent Starter Kit

Reusable instructions for coding agents. Copy this kit into a repository and
get a short entrypoint, on-demand depth, verification gates, a skills router,
and a graph-first way to navigate the codebase.

Defaults assume a GitHub-hosted repository and an agent that reads `AGENTS.md`:
OpenCode, Codex, Cursor, GitHub Copilot, or a CLI harness. The core rules stay
tool-neutral; map the `.github/` templates and `gh` commands when the host is
GitLab, Bitbucket, or something else. The skills router targets OpenCode and
compatible harnesses.

## What is here

| File | Purpose |
|---|---|
| `AGENTS.md` | The entrypoint. Profile, hard rules, workflow, gates, branching, commits, PRs, definition of done. |
| `docs/agent/WORKFLOW.md` | How work moves from request to merged change, including parallel and subagent work. |
| `docs/agent/TESTING.md` | Test strategy, TDD loop, how to discover and run the real gates. |
| `docs/agent/COMMITS.md` | Branch, commit, PR checklist, release, and changelog rules. |
| `docs/agent/SKILLS.md` | Router for all installed skills, plus how to add repo-local ones. |
| `docs/agent/CREATION.md` | Scaffolding skills, plugins, MCP servers, and CLI-Anything harnesses. |
| `scripts/agent-kit` | Scaffolding CLI for skills, plugins, MCP config, and CLI-Anything commands. |
| `.opencode/skills/skill-scout/` | Finds, vets, and installs a web skill when none is installed. |
| `docs/agent/GRAPHIFY.md` | When and how to build, query, and refresh the code knowledge graph. |
| `docs/agent/ARCHITECTURE.md` | Fill-in module map, dependency rules, and invariants. |
| `docs/agent/ISSUES.md` | Issue types, IDs, severity, priority, labels, triage. |
| `docs/adr/` | Architecture decision record index and template. |
| `.github/` | Pull request and issue templates. |

## Read order

1. `AGENTS.md`, the entrypoint. If the host does not read `AGENTS.md`, bridge
   it through `CLAUDE.md` or the host's instruction file.
2. `docs/agent/WORKFLOW.md`, before starting a non-trivial task.
3. The topic file for the work: testing, commits, architecture, issues, or
   graphify.
4. `docs/agent/SKILLS.md`, when choosing a skill or adding one.
5. `docs/agent/CREATION.md`, when adding a skill, plugin, or MCP server, or
   when turning a tool into an agent-native CLI.

## Adopt it in five steps

1. **Copy the kit** into the target repository. Keep the `docs/agent/` path,
   and keep `docs/adr/` only if you use ADRs. Merge the `.github/` templates
   with any existing ones.
2. **Fill `AGENTS.md`.** Replace every angle-bracket placeholder and `TODO:` in
   the project profile and the commands block. Delete sections that do not
   apply. Delete any line that repeats a topic owner; move detail into
   `docs/agent/`.
3. **Fill the maps.** Complete `docs/agent/ARCHITECTURE.md`; complete
   `docs/agent/ISSUES.md` if you use the issue taxonomy. Use the optional-module
   table below when removing a module.
4. **Match the enforcement.** Set branch protection, required CI checks, and
   the commands in the gates block to the same rules. An instruction that CI
   does not enforce will drift.
5. **Verify discovery.** Start a fresh agent session at the repository root.
   Ask it to summarize the project profile, list the gate commands, and name
   the skill it would use for a bug. If it guesses or misses a file, fix the
   entrypoint.

Run one small real task before trusting the kit on a large one.

## Create skills, plugins, and MCP servers

`scripts/agent-kit` writes the boilerplate so the agent edits content instead of
reinventing paths:

```bash
scripts/agent-kit new skill release-notes --description "Use when cutting a release"
scripts/agent-kit new plugin guard-branch
scripts/agent-kit new mcp github -- npx -y @modelcontextprotocol/server-github
scripts/agent-kit cli-anything        # CLI-Anything slash commands for OpenCode
```

Add `--global` to write under `~/.config/opencode/`. `cli-anything` installs the
[CLI-Anything](https://github.com/HKUDS/CLI-Anything) commands, so
`/cli-anything <path-or-repo>` can generate an agent-native CLI for software
that only has a GUI. Details and verification: `docs/agent/CREATION.md`.

## Optional modules

Graphify, the skills router, the skill scout, and the PR checklist are
integrated by default. If the repository will not use one, remove it and its
references together. After any removal, run a link check and:

```bash
rg -n '\b(GRAPHIFY|SKILLS|ISSUES|ADR|pr-checklist)\b' .
```

Resolve every hit that points at the removed module.

| Module | Remove or edit | Fallback |
|---|---|---|
| Issue taxonomy | `docs/agent/ISSUES.md`; `.github/ISSUE_TEMPLATE/`; issue link in `AGENTS.md` section 11; issue references in `TESTING.md` sections 2 and 8; issue close step in `WORKFLOW.md` section 8; `Closes #` in the PR template | Use plain titles and omit issue links; use tracked notes for quarantined tests |
| ADRs | `docs/adr/`; ADR rule in `AGENTS.md` section 8; decision links in `ARCHITECTURE.md` sections 10 and 11; README layout | Record decisions in `docs/agent/ARCHITECTURE.md` |
| Knowledge graph | `docs/agent/GRAPHIFY.md`; graph section in `AGENTS.md` section 7; graph step in `WORKFLOW.md` section 2; graphify row and recipe in `SKILLS.md`; graphify mentions in `README.md` | Use search and targeted reads |
| Skills router | `docs/agent/SKILLS.md`; skill step in `AGENTS.md` section 4; skill links in `WORKFLOW.md`, `TESTING.md`, and `COMMITS.md` | Follow the process docs manually; if no process file exists, use the repository rules and say the skill was unavailable |
| Skill scout | `.opencode/skills/skill-scout/`; its row and recipe in `SKILLS.md`; map row in this README | Find and vet a skill by hand, or write one locally |
| PR checklist | PR checklist in `docs/agent/COMMITS.md`; checklist in `.github/PULL_REQUEST_TEMPLATE.md`; checklist link in `AGENTS.md` section 11; reference in `WORKFLOW.md` section 8 | Use the three-item definition of done in `AGENTS.md` section 11 |

Also remove the module from the file map and layout in this README.

## Customize without forking the rules

- **Monorepo:** keep the root `AGENTS.md` for repository-wide rules and add a
  nested `AGENTS.md` beside a package that needs different commands or
  boundaries. The nearest file wins for its subtree.
- **Conventional Commits:** use the mapping in `docs/agent/COMMITS.md` and drop
  the bracketed flags. Do not maintain two conventions.
- **Issue IDs:** if `PREFIX-n` titles are too heavy, keep the issue types and
  labels and delete the ID section.
- **Knowledge graph:** if the team does not share a graph, keep
  `graphify-out/` ignored and use search. The graph rules are optional, not a
  dependency.
- **Skills:** the router names the skills installed in the author's
  environment. Delete rows for skills the team does not have, add repo-local
  skills under `.opencode/skills/<id>/SKILL.md`, and follow the matching process
  file manually when a skill is not installed.
- **Tools that only read `CLAUDE.md`:** add a one-line `CLAUDE.md` that says
  "Read `AGENTS.md`." Do not duplicate the rules.

## What belongs in `AGENTS.md`

Add a rule when all three are true:

1. It applies to most work in that scope.
2. An agent cannot discover it cheaply from the repository.
3. Following it changes an observable action or check.

Leave out generic advice ("write clean code"), facts visible in the manifest,
and style that a formatter or linter already enforces. Those consume context
and teach nothing.

## Maintenance loop

1. Notice a correction you had to repeat.
2. Decide whether it is durable project knowledge.
3. Put it at the narrowest useful scope.
4. Remove the older rule it replaces.
5. Test it on the next relevant task.

Re-read the kit when commands, architecture, or the release process change. A
stale instruction is worse than a missing one because it sounds authoritative.

## Layout

```text
.
├── AGENTS.md
├── README.md
├── .github/
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.md
│       ├── feature_request.md
│       └── task.md
├── .opencode/
│   └── skills/
│       └── skill-scout/
│           └── SKILL.md
├── scripts/
│   ├── agent-kit
│   └── agent-kit.test.sh
└── docs/
    ├── agent/
    │   ├── WORKFLOW.md
    │   ├── TESTING.md
    │   ├── COMMITS.md
    │   ├── SKILLS.md
    │   ├── CREATION.md
    │   ├── GRAPHIFY.md
    │   ├── ARCHITECTURE.md
    │   └── ISSUES.md
    ├── designs/          # optional; design docs per WORKFLOW.md
    └── adr/
        ├── README.md
        ├── template.md
        └── 0001-record-architecture-decisions.md
```
