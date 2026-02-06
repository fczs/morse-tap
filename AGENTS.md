# AGENTS.md — MorseTap (root)

MorseTap is an iOS app for learning and practicing Morse code using single-button rhythmic input.

## Platform / runtime

- iOS 17+
- Swift 5.9+

## Tech stack (summary)

- SwiftUI
- Swift Concurrency (`async/await`)
- Architecture: MVVM + Clean Architecture layering
- Storage: SwiftData (progress/statistics), UserDefaults (`SettingsStore`)

## Key directories (high-level)

- `MorseTap/`: application code (App, Presentation, Domain, Data, Shared)
- `MorseTapTests/`: unit tests
- `docs/`: meta-prompts and task-prompts
- `.cursor/`: editor commands and rules

## References (detailed process rules)

- `.cursor/rules/agents.mdc`: how to keep `AGENTS.md` minimal and stable
- `.cursor/rules/code-review.mdc`: code review checklist (Swift/SwiftUI)
- `.cursor/rules/meta-prompt.mdc`: rules for `docs/meta-prompt/`
- `.cursor/rules/task-prompt.mdc`: rules for `docs/task-prompt/`

## Module AGENTS.md

- `MorseTap/Presentation/Learn/AGENTS.md`
- `MorseTap/Presentation/Practice/AGENTS.md`
- `MorseTap/Presentation/Progress/AGENTS.md`
- `MorseTap/Presentation/Settings/AGENTS.md`

## Important for AI

- Communicate in English; generate code and documentation in English.
- Follow MVVM boundaries: Views (UI) → ViewModels (presentation logic) → Domain services (business logic) → Data repositories (persistence).
- Use Swift Concurrency (`async/await`) for asynchronous work; avoid callback-style APIs unless necessary.
- New SwiftUI Views must include `#Preview` implementations.
- Do not create new markdown files (including new `AGENTS.md`) unless explicitly requested.
