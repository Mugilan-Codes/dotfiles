# ADR Format

Use this when an architecture review uncovers a decision that future reviews should not re-litigate.

ADRs live in `docs/adr/` and use sequential numbering: `0001-slug.md`, `0002-slug.md`, and so on. Create the directory lazily only when the first ADR is needed.

## Template

```md
# {Short title of the decision}

{1-3 sentences: what context led to the decision, what was decided, and why.}
```

## When to offer an ADR

Offer an ADR only when all three are true:

- The decision is hard to reverse.
- The choice would surprise a future maintainer without context.
- There was a real trade-off with credible alternatives.

Skip ADRs for temporary preferences, obvious choices, easy reversals, or implementation notes that belong in code.

## Numbering

Scan `docs/adr/` for the highest existing number and increment by one.

