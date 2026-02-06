# add-agents

---

## description: Create a module-level AGENTS.md (MorseTap)

Read @.cursor/rules/agents.mdc and @AGENTS.md for context.

## User Input

$ARGUMENTS

## Instructions

1. Parse the module path from user input.

   Example: `MorseTap/Presentation/Learn` (use any existing module directory under `MorseTap/`).

2. Verify the module exists and doesn't already have AGENTS.md

3. Analyze the module responsibilities and public entry points (keep it minimal; avoid exhaustive file listings):

   - Identify primary Views and ViewModels (Presentation modules)
   - Identify key Domain services/protocols and models (Domain)
   - Identify repositories/storage models and their roles (Data)
   - Identify reusable components/utilities/extensions (Shared)
   - Identify cross-layer dependencies (who calls whom) at a high level

4. Create `AGENTS.md` in the module folder following the structure from the rule:

   - Module purpose (1-2 sentences, infer from name and code)
   - Key types by name (Views, ViewModels, services/protocols, repositories, models) — keep short
   - Public entry points/responsibilities (e.g., main View, primary service protocol)
   - Dependencies on other layers/modules (e.g., Presentation → Domain protocols; Data implements repositories)
   - Module-specific constraints/patterns (e.g., SwiftUI previews required, `@MainActor` expectations, SwiftData boundaries)

5. Keep it minimal — only document what the agent cannot easily infer from code

6. If purpose is unclear, write: "TODO: describe purpose"

7. Show the created file content for review
