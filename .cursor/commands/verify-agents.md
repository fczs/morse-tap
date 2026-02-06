# verify-agents

---

## description: Verify and sync AGENTS.md files (MorseTap)

Read @.cursor/rules/agents.mdc and @AGENTS.md for context.

## Instructions

1. **Discovery**: Find all existing `AGENTS.md` files dynamically:
   - Root `AGENTS.md`
   - Module-level `AGENTS.md` under `MorseTap/**/AGENTS.md`
   - Do not create new markdown files during verification; only review/edit files that already exist.

2. **Find contradictions**: Identify conflicting instructions across `AGENTS.md` files.
   - Prefer the more specific module-level constraint over the root file.
   - Prefer `.cursor/rules/*.mdc` for process/format rules.
   - If the conflict cannot be resolved objectively, ask the user which version to keep.

3. **Verify root `AGENTS.md`**: Check it follows the essentials-only structure from `.cursor/rules/agents.mdc`. Flag violations and propose minimal edits.

4. **Verify module `AGENTS.md` files** (if any exist):
   - Check the module purpose matches the actual code in that directory.
   - Remove references to non-existent directories/types.
   - Ensure “Key types” mention real Swift types by name (Views, ViewModels, services/protocols, repositories, models), without exhaustive file lists.
   - Ensure dependencies reflect the intended layering (Presentation → Domain protocols → Data repositories).
   - If purpose is unclear, write: "TODO: describe purpose".

5. **Cross-check against the MorseTap structure** (when relevant sections exist in the docs):
   - **Presentation**: validate module coverage under `MorseTap/Presentation/` (e.g., `Learn/`, `Practice/`, `Progress/`, `Settings/`) and the existence of the referenced Views/ViewModels.
   - **Domain**: validate any listed services against `MorseTap/Domain/Services/` and models against `MorseTap/Domain/Models/`.
   - **Data**: validate repositories against `MorseTap/Data/Repositories/` and storage models/wrappers against `MorseTap/Data/Storage/`.
   - **Shared**: validate referenced segments against `MorseTap/Shared/` (e.g., `Components/`, `Extensions/`, `Utilities/`, `Resources/`).

6. **Flag for deletion**: Identify redundant, vague, obvious, or stale content per `.cursor/rules/agents.mdc`.

7. **Before any edits**, describe:
   - which files you will touch
   - what you will change
   - why it's needed
   - possible side effects
     Then ask exactly: "May I proceed with these actions?" and wait for confirmation.

8. **Report**: Output a short summary of files found, contradictions, and items added/removed/flagged.
