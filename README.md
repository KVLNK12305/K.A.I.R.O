# K.A.I.R.O

Knowledge • Ascension • Introspection • Resilience • Overcoming

K.A.I.R.O is a comprehensive Flutter-based "Life OS" and productivity application. It goes beyond simple task management to provide a holistic suite of tools for self-improvement, brutal introspection, memory tracking, and daily progression.

## Core Features & Modules

The application is heavily modularized into distinct philosophical and functional areas:

- **Dashboard / Command Center**: The main hub for daily tracking, inbox management, and a memory graph view.
- **Psychosomatic Scan**: A tool to log and track physical and mental states over time.
- **Brutalist Review**: Unfiltered, direct self-reviews and reflections to foster extreme accountability.
- **Liar's Chart (Goals)**: A mechanism to confront personal deceptions and track hard goals.
- **Crucible State**: A deep-focus or intense working mode tracker.
- **Spirituality (Gita Service)**: Daily Bhagavad Gita shlokas with offline caching.
- **Energy Economy**: Tracking personal energy as a resource.
- **Wardrobe (Clothing Item)**: Managing and tracking daily wear.
- **Coach Chat**: An AI-powered interaction layer.
- **Integrations**: Supports GitHub PR tracking, Wakatime coding stats, Google APIs, and Finance tracking.

## Architecture & Tech Stack

- **Framework**: Flutter (Material 3 UI, Target Platforms: Android, iOS, Web, Windows, macOS, Linux)
- **Language**: Dart SDK `^3.10.1`
- **Local Database**: [Isar](https://isar.dev/) for high-performance on-device storage of all core models (Tasks, Metrics, Goals, Shlokas, Graph Nodes, etc.)
- **State Management**: [Riverpod](https://riverpod.dev/) for predictable, reactive state.
- **API & Networking**: standard `http` package with dedicated service classes for external integrations (GitHub, WakaTime, etc.).

### Project Structure

```text
lib/
  main.dart                      # App entry point & Isar initialization
  app.dart                       # MaterialApp & routing setup
  Nav/
    main_scaffold.dart           # Bottom navigation shell
  core/
    models/                      # Isar Collections (Task, LiarGoal, GitaShloka, etc.)
    services/                    # External and Internal services (Gita, GitHub, Graph)
    theme/                       # App-wide theming
  features/
    dashboard/                   # Command Center, Inbox, Memory Graph
    brutalist_review/            # Honest self-reflection UI
    psychosomatic/               # Mind/body scan UI
    liars_chart/                 # Goal tracking UI
    spirituality/                # Gita/spiritual features
    wardrobe/                    # Clothing tracking
    Coach_chat/                  # AI coaching
    profile/                     # User profile & stats
```

## Getting Started

### 1. Prerequisites

- Flutter SDK installed and configured.
- Dart SDK (included with Flutter).

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Isar Code

Because the app uses Isar, you must generate the `.g.dart` files for the models anytime they change:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run the App

```bash
flutter run
```

## Development & Roadmap

- **Data Connectivity**: Connecting mock/UI views to the underlying Isar database collections (e.g., Memory Nodes, Tasks, Crucible State).
- **Service Integration**: Finalizing OAuth and token flows for GitHub, WakaTime, and Google API services.
- **AI Integration**: Replacing mock coach flows with real on-device or cloud LLM inference.
