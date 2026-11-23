#!/usr/bin/env bash
# Self-check for scripts/agent-kit. Run: scripts/agent-kit.test.sh
set -euo pipefail

kit="$(cd "$(dirname "$0")" && pwd)/agent-kit"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"

"$kit" new skill demo --description 'Use when testing "quotes"' >/dev/null
grep -qx 'name: Demo' .opencode/skills/demo/SKILL.md
grep -qx 'description: "Use when testing \\"quotes\\""' .opencode/skills/demo/SKILL.md

"$kit" new plugin demo-tool >/dev/null
grep -q 'export const DemoTool' .opencode/plugin/demo-tool.js

if command -v opencode >/dev/null 2>&1; then
  # Also proves JSONC comments survive: OpenCode owns the file now.
  printf '{\n  // keep me\n  "theme": "x"\n}\n' > opencode.jsonc
  "$kit" new mcp local -- npx -y demo >/dev/null
  "$kit" new mcp remote --url https://example.com/mcp >/dev/null
  grep -q '// keep me' opencode.jsonc
  grep -q '"npx"' opencode.jsonc
  grep -q 'https://example.com/mcp' opencode.jsonc
else
  echo "skip: opencode not installed, MCP checks skipped"
fi

if "$kit" new skill demo >/dev/null 2>&1; then
  echo "FAIL: overwrite was not refused" >&2
  exit 1
fi

if "$kit" new skill Bad_Id >/dev/null 2>&1; then
  echo "FAIL: invalid id was accepted" >&2
  exit 1
fi

echo "ok: agent-kit self-check passed"
