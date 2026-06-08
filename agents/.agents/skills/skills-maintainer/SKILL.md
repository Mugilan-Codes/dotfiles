---
name: skills-maintainer
description: Maintain the local Codex skills setup under $HOME/.agents/skills. Use when the user says "Use skills-maintainer", "audit my local skills", "update my skills guide", "check my Codex skills setup", "a new skill was added", or "a skill was updated".
---

# Skills Maintainer

Use this skill to audit and maintain the local Codex skills setup under `$HOME/.agents/skills`.

## Scope

- Work only inside `$HOME/.agents/skills`.
- Do not modify any project repository.
- Do not delete, move, or rename skills automatically.
- Keep changes small and reviewable.
- Preserve the existing `SKILLS_GUIDE.md` and `SKILLS_REGISTRY.md` structure unless an improvement is clearly useful.

## Workflow

1. Inspect `$HOME/.agents/skills`.
2. Find every skill folder. Ignore plain files such as `.DS_Store`, `SKILLS_GUIDE.md`, and `SKILLS_REGISTRY.md`.
3. Verify every skill folder contains `SKILL.md`.
4. Check each `SKILL.md` frontmatter has non-empty `name` and `description` fields.
5. Check relative Markdown references inside skill docs:
   - Treat `http:`, `https:`, `mailto:`, anchors, and absolute paths as external or non-relative.
   - Resolve relative links from the document that contains the link.
   - Report missing relative targets.
6. Detect new, removed, renamed, or changed skills by comparing the on-disk folders and `SKILL.md` frontmatter against `SKILLS_GUIDE.md` and `SKILLS_REGISTRY.md`.
7. Update `SKILLS_GUIDE.md` with installed skills, trigger phrases, example prompts, and usage notes.
8. Update `SKILLS_REGISTRY.md` with path, purpose, status, last reviewed date, important files, and known issues.
9. Mark broken or stale skills as `fix` in the registry instead of deleting them.

## Status Rules

- `keep`: useful and valid enough to use.
- `fix`: missing `SKILL.md`, invalid frontmatter, broken local references, stale metadata, or other repair needed.
- `optional`: useful only for a narrow workflow.
- `remove`: not recommended, but never remove automatically.

## Final Summary

Always finish with:

- Skills found.
- Files created.
- Files modified.
- Broken references.
- Skills to keep, fix, optional, or remove.
- Whether a fresh Codex session is recommended.

Recommend a fresh Codex session when skills were added, removed, renamed, or their `SKILL.md` frontmatter changed.

