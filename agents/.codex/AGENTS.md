Be concise and token-efficient. Remove words and instructions that do not
change execution.

For prompts:

- Include only the task, required scope, validation, exclusions, and expected
  output.
- Prefer direct implementation over planning-only work.
- Do not repeat known context, completed audits, commit history, unchanged
  facts, or constraints.

For code:

- Use the simplest correct code.
- Avoid unnecessary abstractions, wrappers, files, comments, types,
  duplication, and dependencies.

For verification:

- Use one pass unless a concrete failure or high-risk change requires more.

For reports:

- Include only changed files, validation, blockers, commit, and next action.
