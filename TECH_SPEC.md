# Technical Specification

## Morse Tap — iOS Application for Learning Morse Code

---

## 1. Application Goal

The application is designed for learning and practicing Morse code.
The core feature is Morse input via a single large circular button, emphasizing rhythm, visualization, and gradual skill progression.

The application:

- works fully offline;
- stores user progress locally;
- is focused on regular practice and long-term skill acquisition.

---

## 2. Platform and Technology Stack

### 2.1 Platform

- iOS
- Minimum iOS version: to be defined (preferably iOS 17+)

### 2.2 Language and UI

- Language: Swift
- UI Framework: SwiftUI

### 2.3 Architecture

- Architectural pattern: MVVM
- Morse logic and exercise generation must be implemented in a separate Domain / Service layer
- UI must not contain business logic

### 2.4 Concurrency and State

- Swift Concurrency (`async/await`)
- SwiftUI state management (`@State`, `@Observable`, `@Environment`)

### 2.5 Data Storage

- **UserDefaults** — user settings
- **SwiftData** — learning progress and statistics

---

## 3. Navigation and Screen Structure

### 3.1 Main Navigation

The application uses a TabBar with the following tabs:

1. Learn
2. Practice
3. Progress
4. Settings

---

## 4. Functional Modules and Screens

---

### 4.1 Module: Learning the Alphabet ("Learn")

#### 4.1.1 Symbol List Screen

**MUST**

- Display a list of available symbols:
  - Latin letters A–Z
  - digits 0–9
  - (punctuation is optional and may be added later)
- Each symbol must display:
  - the character itself
  - visual Morse representation (dots and dashes)
  - a learning progress indicator (based on statistics)

**SHOULD**

- Allow playback of the symbol's Morse code (sound / vibration)

---

#### 4.1.2 Symbol Card Screen

**MUST**

- Display:
  - a large symbol
  - its Morse code
- Include an interactive "repeat the code" block:
  - input is performed via the universal Morse input button

**SHOULD**

- Show correctness of input
- Provide immediate visual and haptic feedback

---

### 4.2 Universal Component: Morse Input

#### 4.2.1 Morse Input Button

**MUST**

- Be implemented as a large circular button
- Handle gestures:
  - short press → dot
  - long press (longer than a configurable threshold) → dash
- Symbol completion is determined by a pause between presses

**MUST**

- Visually display:
  - entered dots and dashes
  - the current unfinished symbol

**SHOULD**

- Support:
  - deleting the last entered signal
  - repeating a hint
- Have configurable timing thresholds

---

### 4.3 Module: Practice

#### 4.3.1 Exercise Selection Screen

**MUST**

Provide the following modes:

1. Code → word
2. Code → sentence
3. Word → code
4. Sentence → code

---

#### 4.3.2 Generic Exercise Screen

**MUST**

- Display:
  - current exercise progress
  - the current task
  - the input area
- Support answer validation
- Record the result of each attempt

---

#### 4.3.3 "Code → Text" Modes

**MUST**

- Input is performed via the Morse button
- Recognized symbols are assembled into a text string
- Space input must be supported

**SHOULD**

- Highlight errors
- Support multiple hint levels

---

#### 4.3.4 "Text → Code" Modes

**MUST**

- Display the target text
- The user inputs Morse code
- The system validates correctness

**MAY**

- Use native or custom keyboard (for text selection if needed)

---

### 4.4 Module: Progress

#### 4.4.1 Progress Screen

**MUST**

- Display aggregated statistics:
  - total training sessions
  - accuracy
  - streak (consecutive active days)
- Show weak symbols

**SHOULD**

- Display statistics by exercise mode
- Show learning dynamics over time

---

### 4.5 Module: Settings

**MUST**

- Configure input timings (dot / dash / pause)
- Enable/disable:
  - sound
  - vibration
- Select difficulty level

**SHOULD**

- Allow resetting learning progress

---

## 5. Data and Storage

### 5.1 User Settings (UserDefaults)

- input timings
- sound / vibration
- difficulty
- hint level

---

### 5.2 Learning Progress (SwiftData)

#### 5.2.1 User Profile

- first launch date
- current streak
- last activity date

#### 5.2.2 Per-Symbol Statistics

For each symbol:

- number of attempts
- number of correct inputs
- average input time
- last trained date

#### 5.2.3 Exercise Statistics (Aggregated)

- exercise mode
- average accuracy
- average time
- total number of attempts

---

## 6. Non-Functional Requirements

- The application must work offline
- Progress must be saved automatically
- The interface must be:
  - minimalist
  - visually stable
  - suitable for long training sessions

---

## 7. Extensibility Requirements

The architecture must allow:

- adding new exercise modes
- adding audio-based modes
- adding synchronization (e.g. iCloud) without redesigning the core

---

## 8. Notes for LLM-Driven Development

- Each logical part must be implemented as an isolated module
- UI, Morse logic, and storage must be strictly separated
- Code must be readable and designed for future extension
