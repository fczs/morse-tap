# create-task-prompt

---

## description: Create a task-prompt document from meta-prompt

Read @.cursor/rules/task-prompt.mdc and @AGENTS.md for context.

## User Input

$ARGUMENTS

## Instructions

1. Read the meta-prompt file specified in user input (e.g., `docs/meta-prompt/some-task.md`)
2. Read all relevant AGENTS.md files from affected modules mentioned in meta-prompt
3. Create file `docs/task-prompt/<same-slug>.md` following the strict structure from `create-task-prompt.mdc`
