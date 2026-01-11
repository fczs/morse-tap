# verify-agents

You are an AI coding agent in the repository.

Goal: eliminate inconsistencies between the contents of `AGENTS.md` files and the actual project structure (Clean Architecture layers).

Files you are allowed to edit (only these):

- AGENTS.md
- MorseCode/Presentation/AGENTS.md
- MorseCode/Domain/AGENTS.md
- MorseCode/Data/AGENTS.md
- MorseCode/Shared/AGENTS.md

Hard rules:

- Do NOT create new markdown files. Only edit the existing `AGENTS.md` files above.
- Do NOT change application code, configs, tests, or scripts — documentation sync only.
- Before any edits, describe:
  - which of the allowed files you will touch,
  - what you will change,
  - why it's needed,
  - possible side effects.
    Then ask exactly: "Можно ли выполнить эти действия?" and wait for confirmation. Only then apply changes.
- Keep edits minimal and factual. Do not invent purposes.

What counts as an "inconsistency" and how to fix it:

1. Root `AGENTS.md`

- Verify that links to `MorseCode/*/AGENTS.md` are valid and the target files exist.
- If the text references directories/tech that no longer exist in the repo, update the wording minimally.

2. `MorseCode/Presentation/AGENTS.md`

- Find the module catalog section (markdown table: "Module | Purpose").
- Build the actual module list from directories inside the Presentation folder:
  - `MorseCode/Presentation/Learn/`
  - `MorseCode/Presentation/Practice/`
  - `MorseCode/Presentation/Progress/`
  - `MorseCode/Presentation/Settings/`
    Exclude: `AGENTS.md` itself and any non-directory entries.
- Compare table rows vs actual directories:
  - If the table contains a module that doesn't exist on disk — remove that row.
  - If a directory exists on disk but is missing from the table — add a row.
- Preserve existing Purpose text as-is.
- For newly added rows' Purpose:
  - Infer purpose from folder name + Views + ViewModels.
  - If still unclear, write: "TODO: describe purpose" (no guessing).

3. `MorseCode/Domain/AGENTS.md`

- Compare listed services with actual Swift files inside `MorseCode/Domain/Services/`.
- Remove rows for missing services; add rows for existing ones that are missing in the table.
- Preserve existing descriptions.

4. `MorseCode/Data/AGENTS.md`

- Compare listed repositories with actual Swift files inside `MorseCode/Data/Repositories/`.
- Compare listed storage models with actual Swift files inside `MorseCode/Data/Storage/`.
- Remove rows for missing items; add rows for existing ones that are missing in the table.

5. `MorseCode/Shared/AGENTS.md`

- In the folder catalog, compare listed folders with actual directories inside `MorseCode/Shared/*`.
- Remove rows for missing directories; add rows for existing ones that are missing in the table.
- Preserve existing descriptions.
- For new folders:
  - Write a minimal description; if unclear, "TODO: describe folder purpose".

Output after changes:

- Short report:
  - rows added/removed per `AGENTS.md`,
  - total mismatches before vs after (must be 0 for directory/file lists).
