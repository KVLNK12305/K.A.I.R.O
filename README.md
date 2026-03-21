# K.A.I.R.O

Knowledge • Ascension • Introspection • Resilience • Overcoming

K.A.I.R.O is a Flutter productivity and self-improvement app concept built around four core experiences:

- Daily blueprint planning
- AI-powered diagnostics simulation
- Coach-style chat interactions
- Personal metrics and achievements tracking

The app currently focuses on a strong UI foundation and feature scaffolding, with mock interactions that are ready to be connected to real backend and AI services.

## Demo Scope

Current implemented screens:

- Plan: daily objectives and coach tip
- AI Scan: diagnostic tool cards with mock scan flow
- Coach: in-app coach conversation experience
- You: progress metrics and achievement list

## Project Structure

```text
lib/
	main.dart                      # App entry point
	app.dart                       # MaterialApp setup
	Nav/
		main_scaffold.dart           # Bottom navigation + page shell
	core/
		models/
			chat_message.dart          # Chat message model
			task.dart                  # Task model
		theme/
			app_theme.dart             # Global dark theme
	features/
		dashboard/
			dashboard_page.dart
			widgets/
				task.dart                # Task UI tile
				coach_tips.dart
		AI_Tools/
			tools_page.dart
			mock_scanner.dart
			widgets/
				tool_card.dart
		Coach_chat/
			ai_coach_chat_page.dart
			widgets/
				chat_bubble.dart         # Reserved for reusable chat bubble
		profile/
			profile_page.dart
			widgets/
				metric_bar.dart
				achievement_tile.dart
```

## Architecture Notes

- Feature-first layout for presentation code
- Shared domain objects in core models
- Centralized app theme in core theme
- Bottom navigation shell in a dedicated Nav module

This keeps UI responsibilities clear and prepares the codebase for state management and data-layer expansion.

## Tech Stack

- Flutter (Material 3)
- Dart SDK ^3.10.1
- Target platforms: Android, iOS, Web, Windows, macOS, Linux

## Getting Started

### 1. Prerequisites

- Flutter SDK installed and configured
- Dart SDK (included with Flutter)
- Platform toolchains as needed (Android Studio, Xcode, etc.)

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

### 4. Run static analysis

```bash
flutter analyze
```

### 5. Run tests

```bash
flutter test
```

## Development Roadmap

Suggested next milestones:

- Replace mock scanner flow with real camera input and on-device/cloud inference
- Add state management layer (Riverpod, Bloc, or Provider)
- Introduce repositories and services for clean data boundaries
- Persist tasks, metrics, and chat history locally
- Add authentication and optional sync backend
- Expand test coverage for widgets and business logic.
