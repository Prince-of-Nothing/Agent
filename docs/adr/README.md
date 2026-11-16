# Architecture Decision Records

An ADR records a decision that is expensive to reverse: a boundary, a
technology choice, a data contract, or a constraint that future work must
respect. It explains why, not how.

## When an ADR is required

Write one when a change:

- Moves code across a module or layer boundary.
- Changes a public API, wire format, schema, or compatibility contract.
- Adds or replaces a framework, database, or external service.
- Changes how authentication, authorization, privacy, or secrets are handled.
- Introduces a constraint future contributors must follow.

A bug fix, a local refactor, or a new screen inside an existing pattern does
not need one.

## Rules

- Name files `NNNN-kebab-title.md`, with the next free number.
- Before choosing a number, check open pull requests that add an ADR. If two
  PRs choose the same number, renumber the later merge. Never reuse a number.
- Write the ADR in the same pull request as the change.
- An accepted ADR is immutable. Supersede it with a new ADR instead of editing
  the decision.
- Keep the index current, including status and date.
- Record who accepted it in the ADR's `Deciders` field.
- Status moves Proposed -> Accepted -> Superseded or Deprecated. A superseding
  ADR links the one it replaces.
- Use the template in `template.md`.

## Index

| ID | Title | Status | Date |
|---|---|---|---|
| [0001](0001-record-architecture-decisions.md) | Record architecture decisions | Accepted | `2026-11-16` |

The kit ships with 0001 as a worked example. Keep it; it records the ADR
process itself.

## Add an ADR

1. Check open ADR pull requests, then copy `template.md` to
   `NNNN-kebab-title.md`.
2. Fill in context, decision, alternatives, and consequences.
3. Add a row to the index.
4. Link the index from `docs/agent/ARCHITECTURE.md` and link the ADR from the
   pull request.
