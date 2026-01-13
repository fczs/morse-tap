# Practice: Exercise Selection Screen

## Goals

- Provide user interface for selecting practice exercise mode
- Enable navigation to exercise execution screen with selected mode

## Functional requirements

### Presentation/Practice

- Replace placeholder Practice screen with Exercise Selection screen
- Display all four exercise modes as selectable items
- Each mode displays title and brief description
- On mode selection, navigate to Generic Exercise Screen passing the chosen mode

### Presentation/Practice (ViewModel)

- Manage list of available exercise modes
- Handle mode selection and navigation trigger

## Out-of-scope

- Generic Exercise Screen implementation (separate task)
- Exercise generation and validation logic
- Statistics recording
- Mode-specific exercise UI
- Complex animations or transitions

## Affected layers and modules (Yes/No/Unknown)

- App/: No
- Presentation/Learn: No
- Presentation/Practice: Yes
- Presentation/Progress: No
- Presentation/Settings: No
- Domain/Services: No
- Domain/UseCases: No
- Domain/Models: No
- Data/Repositories: No
- Data/Storage: No
- Shared/Components: No
- Shared/Utilities: No

## Dependencies and artifacts

- Task T9: Practice Core (completed) — provides `ExerciseMode` with all four modes
- TECH_SPEC.md: Section 4.3.1 (Exercise Selection Screen)
- AGENTS.md: Presentation/Practice section
