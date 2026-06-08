# CONTEXT.md Format

Use this when the architecture review needs to create or update project vocabulary.

## Structure

```md
# {Context Name}

{One or two sentence description of what this context is and why it exists.}

## Language

**Order**:
{A one or two sentence description of the term}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request
```

## Rules

- Be opinionated. When multiple words exist for the same concept, pick one and list the others under `_Avoid_`.
- Keep definitions tight. Define what the term is, not how it is implemented.
- Include only project-domain terms. General programming concepts do not belong in `CONTEXT.md`.
- Create `CONTEXT.md` lazily, only when there is a real term to record.
- If `CONTEXT-MAP.md` exists, use it to find the right context before editing.

