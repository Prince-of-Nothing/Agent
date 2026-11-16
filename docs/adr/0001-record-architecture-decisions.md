# 0001: Record architecture decisions

- Status: Accepted
- Date: `2026-11-16`
- Deciders: project owner

## Context

Architecture decisions get lost in chat, pull request threads, and commit
messages. New contributors and agents cannot tell which constraints are
deliberate, which are accidental, and which are safe to change.

## Decision

Record decisions in `docs/adr/` using the template. Number files sequentially,
index them in `README.md`, and treat accepted ADRs as immutable. Supersede a
decision with a new ADR instead of editing history.

## Alternatives considered

| Alternative | Why not |
|---|---|
| Keep decisions in chat | Not discoverable, and it disappears when the session ends |
| Keep decisions in commit messages | Hard to find, with no context or alternatives |
| Keep one architecture document | Rewrites erase the history of why the design changed |

## Consequences

- Positive: contributors and agents can see why a boundary exists.
- Negative: each significant change needs a short writing step.
- Follow-up: link the ADR from `docs/agent/ARCHITECTURE.md` and the pull
  request.

## Links

- Issue: none
- Pull request: none
- Related ADRs: none
