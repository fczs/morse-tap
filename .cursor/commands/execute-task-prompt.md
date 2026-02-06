# execute-task-prompt

---

## description: Execute a task-prompt and implement all changes

Read @AGENTS.md for context.

## User Input

$ARGUMENTS

## Instructions

1. Read the task-prompt file specified in user input
2. Read all AGENTS.md files from affected modules mentioned in "Affected modules" section
3. Execute the "Execution plan" section strictly in order — it already contains all steps (implementation → type checks → verification → quality → docs → finalization)
4. Verify build: `npm run build`
5. Run tests if affected: `npm run test`
6. Report completion status with a summary of all changes made
