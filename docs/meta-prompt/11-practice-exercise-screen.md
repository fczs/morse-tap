# Practice: Generic Exercise Screen

## Goals

- Implement reusable exercise execution screen for all practice modes
- Enable end-to-end exercise flow: load → display → input → validate → feedback → record
- Provide foundation for mode-specific input components in future tasks

## Functional requirements

### Presentation/Practice

- Add Generic Exercise Screen as navigation destination from Exercise Selection
- Display exercise progress indicator (current / total)
- Display exercise prompt based on mode
- Display input area (text field placeholder for initial implementation)
- Show validation result feedback after answer submission
- Support navigation back to selection or to next exercise

### Presentation/Practice (ViewModel)

- Load exercise from ExerciseGenerator on screen appear
- Manage exercise session state: current exercise, progress, completion
- Handle answer submission and validation via ExerciseValidator
- Trigger statistics recording on exercise attempt completion

### Data/Repositories

- Record exercise attempt via StatisticsRepository after validation
- Update per-symbol statistics for symbols involved in exercise

## Out-of-scope

- Mode-specific input components (Morse input button integration)
- Exercise session configuration (exercise count, difficulty selection)
- Spaced repetition or adaptive exercise selection
- Animations and complex transitions
- Audio feedback
- Exercise pause/resume functionality

## Affected layers and modules (Yes/No/Unknown)

- App/: No
- Presentation/Learn: No
- Presentation/Practice: Yes
- Presentation/Progress: No
- Presentation/Settings: No
- Domain/Services: No
- Domain/UseCases: No
- Domain/Models: No
- Data/Repositories: Yes
- Data/Storage: No
- Shared/Components: No
- Shared/Utilities: No

## Dependencies and artifacts

- Task T5: SwiftData Storage (completed) — provides StatisticsRepository
- Task T9: Practice Core (completed) — provides ExerciseGenerator, ExerciseValidator, Exercise model
- Task T10: Exercise Selection Screen (completed) — provides navigation source
- TECH_SPEC.md: Section 4.3.2 (Generic Exercise Screen)
- AGENTS.md: Presentation/Practice section
