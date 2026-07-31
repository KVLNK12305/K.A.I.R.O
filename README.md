# K.A.I.R.O

> **Knowledge • Ascension • Introspection • Resilience • Overcoming**

K.A.I.R.O is a modern, high-performance Flutter-based **Life OS** and personal command center. Built around a **Neo-Pastel Editorial Bento Design System**, it combines telemetry metrics, time-audit ledgers, focus modes, and native Android home screen widgets for brutal self-accountability and progression.

---

## 🎨 Neo-Pastel Editorial Bento Design System

The UI follows modern sports/editorial magazine aesthetics—curated color blocks, crisp ink-black headers, high-contrast badges, and dynamic micro-animations:

| Token | Color Hex | Visual Role |
| :--- | :--- | :--- |
| `AppTheme.pastelPink` | `#F7C5DD` | Soft Rose Pink — Cost of Delay & Operator Identity |
| `AppTheme.pastelBlue` | `#8DC0FA` | Sky Blue — WakaTime & Real-Time Clock Banner |
| `AppTheme.pastelGreen` | `#C7F3C6` | Mint Green — Task Pulse & Digital Wardrobe Launcher |
| `AppTheme.pastelAmber` | `#FAD168` | Honey Amber — Today's Expense & Demographics Seeding |
| `AppTheme.coralRed` | `#FF5232` | Punch Coral Red — Primary CTA Buttons & Alert Badges |
| `AppTheme.inkBlack` | `#0F0F12` | Deep Crisp Ink Black — High-Contrast Headers & Typography |
| `AppTheme.cardWhite` | `#FFFFFF` | Pure White — 168h Weekly Ledger & System Cards |

---

## ⚡ Core Modules & Features

- **Command Center Dashboard**:
  - **168h Weekly Ledger**: High-contrast time audit tile with interactive **Hour (`[HRS h]`) vs Percentage (`[PCT %]`)** allocation toggle, live capacity gauge (`% USED`), and custom recurring block manager.
  - **Crucible Cost of Delay**: Soft Rose Pink card tracking financial cost-of-inaction with instant Lockdown mode.
  - **Sleep & Recovery Intelligence**: Sleep duration, quality index, and morning alarm recommendations.
  - **Primary Anchor & Objective**: Define single non-negotiable daily objectives and energy peaks.
  - **Terminal Scratchpad**: Instant markdown brain dump with automated local state sync.
  - **GitHub & WakaTime Telemetry**: Real-time pull request pipeline tracking and coding stat counters.

- **System Profile & Identity**:
  - Live real-time clock & date banner.
  - Clerk Auth Zero-Config & Google OAuth identity synchronization.
  - Demographics & Hostility seeding forms with hourly rate calculation.

- **Native Android Home Screen AppWidgets**:
  - `DailyAuditWidgetProvider`: Live 168h free hours & time budget.
  - `TaskPulseWidgetProvider`: Live daily completion & peak task metrics.
  - `StreakFlameWidgetProvider`: 21-day discipline ring & particle animation.
  - `EnergyArcWidgetProvider`: Triple energy economy gauge (Peak 1, Peak 2, Recovery).
  - `QuotePrismWidgetProvider`: Bhagavad Gita shlokas with Sanskrit transliteration.

---

## 🛠️ Architecture & Tech Stack

- **Framework**: Flutter (Material 3 UI, Target Platforms: Android, iOS, Web, Desktop)
- **Database**: [Isar](https://isar.dev/) on-device database for lightning-fast offline storage
- **State Management**: [Riverpod](https://riverpod.dev/) for reactive state flow
- **Home Widgets**: `home_widget` plugin with Kotlin AppWidget providers
- **Networking**: `http` with OAuth integrations (Google, GitHub, Clerk)

### Project Structure

```text
lib/
  main.dart                      # App entry point & Isar database init
  Nav/                           # Routing & Scaffold Navigation
  core/
    models/                      # Isar Collections (Task, GitaShloka, SleepLog, etc.)
    services/                    # HomeWidgetSyncService, TimeAuditService, AlarmService
    theme/                       # AppTheme Neo-Pastel design tokens
  features/
    dashboard/                   # Command Center Page & 168h Weekly Ledger
    profile/                     # System Profile & Demographics
    widgets/                     # Bento Card Deck & Native AppWidget Providers
      cards/                     # BentoCard, StreakFlame, CostOfDelay, SleepIntelligence
    energy_economy/              # Energy economy & task pulse providers
```

---

## 🚀 Getting Started

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Isar Code
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run App
```bash
flutter run
```
