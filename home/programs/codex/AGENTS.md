# Commit Messages

After every completed change, suggest a Conventional Commit message to the
user. Do not create the commit unless the user explicitly asks you to.

- Use the format `<type>(<scope>): <description>`.
- Always include a scope. Use the most specific affected project, component,
  or environment name. Use `repo` for root-level or cross-component changes.
- Use one of these types: `feat`, `fix`, `docs`, `refactor`, `test`, `build`,
  `ci`, `chore`, `perf`, or `revert`.
- Write the description in English as a concise imperative phrase, starting
  with a lowercase letter and without a trailing period.
- Mark a breaking change with `<type>(<scope>)!:` and add a
  `BREAKING CHANGE:` footer when an explanation is needed.
