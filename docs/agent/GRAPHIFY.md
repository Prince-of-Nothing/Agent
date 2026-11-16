# Graph-First Code Navigation

> Owner of the knowledge graph rules. `AGENTS.md` links here. Skill ID:
> `graphify`.

## 1. What the graph is

Graphify turns a repository into a queryable knowledge graph. It extracts code
structure with an AST pass and reads documentation, papers, and images with a
semantic pass. It then clusters the result into communities, finds hub nodes,
and writes an audit report.

Outputs land in `graphify-out/`:

| File | Contents |
|---|---|
| `graph.json` | Nodes, edges, communities, source locations |
| `GRAPH_REPORT.md` | Corpus check, summary, god nodes, surprising connections, suggested questions, freshness |
| `graph.html` | Interactive visualization |
| `manifest.json` | Incremental update state |
| `cache/` | Extraction cache |

## 2. Decision rule

| Situation | Action |
|---|---|
| Graph exists, architecture or relationship question | Query the graph first |
| Graph exists, one known symbol or file | Plain search is fine |
| No graph, small repo, one lookup | Search; mention that a graph can be built |
| No graph, large or unfamiliar repo, or repeated questions | Build a graph |
| Graph is older than `HEAD` | Update before trusting structural claims |
| Structural change just landed | Update the graph |

Build a graph when the corpus is large, unfamiliar, or full of links that text
search cannot see: doc to code, cross-document relationships, import cycles,
communities. Do not build one to answer a single "where is this defined"
question.

## 3. Build and update

Invoke the `graphify` skill, or run the CLI directly:

```bash
# full build of the current directory
graphify .

# full build of another path
graphify <path>

# thorough semantic extraction
graphify <path> --mode deep

# incremental: only new and changed files
graphify <path> --update

# re-cluster an existing graph
graphify <path> --cluster-only

# full rebuild that allows the graph to shrink after deletions
graphify <path> --force
```

Useful exports:

```bash
graphify <path> --svg          # graph.svg for docs
graphify <path> --graphml      # Gephi / yEd
graphify <path> --neo4j        # graphify-out/cypher.txt
graphify <path> --mcp          # MCP server for agent access
graphify <path> --wiki         # crawlable index plus community articles
graphify <path> --obsidian     # Obsidian vault
graphify <path> --watch        # rebuild on changes
```

Notes:

- A code-only corpus uses the AST pass and costs no model tokens. Docs, papers,
  and images use semantic extraction and can cost time and tokens. Narrow the
  path when the corpus is large.
- Above roughly 500 files or 2 million words, the pipeline asks you to narrow
  the path. Pick the relevant subfolder.
- The HTML view aggregates communities above 5,000 nodes. Warn before opening a
  graph that large.

## 4. Query

```bash
graphify query "<question>"                 # broad BFS context
graphify query "<question>" --dfs           # trace a specific path
graphify query "<question>" --budget 1500   # cap the answer
graphify path "AuthModule" "Database"       # shortest path between concepts
graphify explain "SwinTransformer"          # plain-language node explanation
```

Query discipline:

1. Expand the question into the graph's own vocabulary before traversing. A
   wording mismatch can collapse the answer to noise.
2. Cite `source_location` when you state a specific fact.
3. Treat `INFERRED` edges as leads, not proof. `EXTRACTED` edges come from
   structure; `AMBIGUOUS` means the extractor was unsure.
4. Read the underlying code before editing it. The graph is a map, not the
   source of truth.
5. If the CLI is unavailable, traverse `graphify-out/graph.json` directly, or
   fall back to search.

## 5. Freshness

`GRAPH_REPORT.md` records the commit the graph was built from. Check it before
querying, not after:

```bash
grep "Built from commit" graphify-out/GRAPH_REPORT.md
git rev-parse --short=8 HEAD
```

Compare the first characters of both hashes rather than the full strings; report
abbreviations vary by Git configuration. If they differ, or the working tree has
uncommitted structural changes, the graph is stale. Run `graphify update .`
after code changes. Run a full build with `--force` after deleting or moving
large parts of the tree, because the default build refuses to shrink an existing
graph.

A structural change is a file move, rename, or delete; a new module or package;
changed imports or exports; a schema change; or a new dependency edge.

## 6. What to commit

Default: add `graphify-out/` to `.gitignore`. It is generated, can be large,
and changes on every run.

If the team shares the graph, commit only what they agreed to share, usually
`GRAPH_REPORT.md` and possibly `graph.json`. Do not commit caches, temporary
state, or the HTML visualization unless the repository intentionally publishes
it. Never let the graph capture secrets, credentials, private keys, or real
user data. Detection skips known-sensitive paths, but do not force-include
them.

## 7. Honesty rules

- Never invent an edge or a node.
- Keep the extraction confidence visible when you cite a relationship.
- Report token cost when a build used semantic extraction.
- Show cohesion numbers as they are, without symbols in place of the value.
- Surface a graph health warning instead of hiding it.
- Do not describe a stale graph as current.

## 8. When not to use it

- A one-line lookup in a file you already know.
- A tiny repository where search is faster than the build.
- A corpus of vendored or generated code that would drown the signal.
- A question that needs runtime behavior. The graph shows structure, not
  execution.

## 9. Integration

- Keep the graph-first rule in `AGENTS.md` so every session sees it.
- After a structural change, update the graph in the same branch when the team
  shares it.
- Link `GRAPH_REPORT.md` from `docs/agent/ARCHITECTURE.md` when it is current.
- Optional: a post-commit hook or CI job can keep the graph fresh. Keep the
  hook non-blocking so a graph failure never blocks a commit.
