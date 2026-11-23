# Creating skills, plugins, and MCP servers

> `scripts/agent-kit` scaffolds the files; you fill in the content. Prefer a
> skill for instructions, a plugin for hooks into OpenCode itself, and an MCP
> server for tools that live in another process.

## 1. Commands

| Command | Creates |
|---|---|
| `scripts/agent-kit new skill <id> --description "<when to use it>"` | `.opencode/skills/<id>/SKILL.md` |
| `scripts/agent-kit new plugin <id>` | `.opencode/plugin/<id>.js` |
| `scripts/agent-kit new mcp <name> -- <command...>` | MCP server in the project OpenCode config (local, stdio) |
| `scripts/agent-kit new mcp <name> --url <url>` | MCP server in the project OpenCode config (remote) |
| `scripts/agent-kit cli-anything` | CLI-Anything slash commands in `.opencode/commands/` |

Add `--global` to write under `~/.config/opencode/` instead of the repository.
The script refuses to overwrite an existing skill or plugin file. It needs the
`opencode` CLI for MCP entries and `git` for `cli-anything`.

## 2. Skills

```bash
scripts/agent-kit new skill release-notes --description "Use when cutting or drafting a release"
```

Edit the generated `SKILL.md`: the `description` is what discovery matches, so
put the words a future request would use in it. Replace every `TODO`. Put
scripts and references beside `SKILL.md`; paths inside the skill are relative to
that directory. Test the skill on a real task before relying on it.

Full rules: `docs/agent/SKILLS.md` section 5. For designing or evaluating the
skill itself, load the `skill-creator` and `writing-skills` skills when they are
installed.

## 3. Plugins

```bash
scripts/agent-kit new plugin guard-branch
```

The generated file exports one async function. OpenCode calls it at startup;
return an object of hooks such as `tool.execute.before` or `event`. See
<https://opencode.ai/docs/plugins> for the hook list and context fields. To load
a published plugin package instead, run `opencode plugin add <package>`, which
adds it to the global `plugins` array. Load the `opencode` skill for questions
about the plugin API.

## 4. MCP servers

```bash
# Local server over stdio; everything after -- is the command array.
scripts/agent-kit new mcp github -- npx -y @modelcontextprotocol/server-github

# Remote server over HTTP.
scripts/agent-kit new mcp docs --url https://example.com/mcp
```

Both call `opencode mcp add`, so OpenCode owns the write: it picks the current
config format and preserves comments in an existing `opencode.jsonc`. Re-adding
the same name replaces that entry. Restart or reload OpenCode after the change
and ask the agent to call one tool from the server before trusting it.

## 5. CLI-Anything

[CLI-Anything](https://github.com/HKUDS/CLI-Anything) generates an agent-native
CLI for software that only ships a GUI or an internal API. Install its OpenCode
commands, then generate a harness from a path or repository:

```bash
scripts/agent-kit cli-anything --global   # once, for every project
# then, in OpenCode:
# /cli-anything ./path/to/software
# /cli-anything https://github.com/owner/repo
```

Without `--global`, the commands go into the current repository's
`.opencode/commands/`; with it, into `~/.config/opencode/commands/`.

The script copies the upstream commands and `HARNESS.md` into
`.opencode/commands/`, or into `command/` on older OpenCode builds that still
use the singular name. The upstream files are Apache-2.0 and come from
HKUDS/CLI-Anything; keep that attribution if you commit them.

A generated harness is a CLI plus a `SKILL.md`, not an MCP server. Register an
MCP server with `new mcp` when the process only speaks MCP; generate or wrap a
CLI and describe it in a skill when the software only has a CLI.

## 6. Verify

1. Run `scripts/agent-kit.test.sh` after changing the script.
2. Restart OpenCode, then confirm the skill or plugin is listed and the agent
   can name it; confirm the MCP server answers one real tool call.
3. Remove or update the skill, plugin, or MCP entry when the underlying
   procedure or service changes.
