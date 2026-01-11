# Application Skeleton

## Goals

- Establish a compilable iOS SwiftUI application with TabView navigation
- Create a modular folder structure supporting Clean Architecture with MVVM
- Define empty service protocols for future feature development

## Functional requirements

### App/

- Create app entry point using `@main` attribute with SwiftUI App lifecycle
- Configure WindowGroup with root ContentView

### Presentation/

- Implement TabView with four tabs: Learn, Practice, Progress, Settings
- Each tab screen wrapped in NavigationStack

#### Learn/

- Placeholder LearnView with associated LearnViewModel
- ViewModel exposed via @Observable pattern

#### Practice/

- Placeholder PracticeView with associated PracticeViewModel
- ViewModel exposed via @Observable pattern

#### Progress/

- Placeholder ProgressView with associated ProgressViewModel
- ViewModel exposed via @Observable pattern

#### Settings/

- Placeholder SettingsView with associated SettingsViewModel
- ViewModel exposed via @Observable pattern

### Domain/

- Define MorseInputProcessing protocol for input handling
- Define ExerciseGenerating protocol for exercise creation
- Define ProgressTracking protocol for statistics management

#### Services/

- Create empty service protocol files with public interface definitions

#### Models/

- Prepare folder for domain entities (no implementation yet)

### Data/

- Prepare Repositories folder for data access layer
- Prepare Storage folder for SwiftData and UserDefaults wrappers

### Shared/

- Prepare Components folder for reusable UI components
- Prepare Utilities folder for helper functions
- Prepare Extensions folder for Swift/SwiftUI extensions

## Out-of-scope

- Morse code encoding/decoding logic
- Exercise generation algorithms
- SwiftData model implementation
- UserDefaults persistence
- Any UI styling or visual design
- Haptic and sound feedback
- Input timing configuration

## Affected layers and modules (Yes/No/Unknown)

- App/: Yes
- Presentation/Learn: Yes
- Presentation/Practice: Yes
- Presentation/Progress: Yes
- Presentation/Settings: Yes
- Domain/Services: Yes
- Domain/UseCases: No
- Domain/Models: Yes (folder only)
- Data/Repositories: Yes (folder only)
- Data/Storage: No
- Shared/Components: Yes (folder only)
- Shared/Utilities: Yes (folder only)
- Shared/Extensions: Yes (folder only)

## Dependencies and artifacts

- TECH_SPEC.md: Sections 2 (Platform and Technology Stack), 3 (Navigation and Screen Structure), 4.1–4.5 (Functional Modules)
- AGENTS.md: Layer Structure, Key Modules, Architecture & Layers
