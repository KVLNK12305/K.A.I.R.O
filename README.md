# K.A.I.R.O

> **Knowledge • Ascension • Introspection • Resilience • Overcoming**

K.A.I.R.O is a modern, high-performance Flutter-based **Life OS** and personal command center. Built around a **Neo-Pastel Editorial Bento Design System**, it combines telemetry metrics, time-audit ledgers, focus modes, and native Android home screen widgets for brutal self-accountability and progression.

---

## 📸 Screenshots & Demos
*(Screenshots and GIFs coming soon once the UI stabilizes during the 60-90 day validation period.)*

---

## 🎯 Why I Built K.A.I.R.O

Most productivity apps focus on tracking endless lists of tasks. Very few focus on the reality that **you get 168 hours every week**. I built K.A.I.R.O around the concept of a **168h Weekly Ledger**—a system that forces you to confront exactly where those hours go. It's less about ticking boxes and more about understanding capacity, energy, and the true cost of inaction. It's designed to be a system I actually want to open every morning.

---

## 🎨 Neo-Pastel Editorial Bento Design System

The UI follows modern sports/editorial magazine aesthetics—curated color blocks, crisp ink-black headers, high-contrast badges, and dynamic micro-animations.

**Design Philosophy:** Create an interface that feels responsive, alive, and highly premium, using a curated color palette instead of standard generic colors.

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
  - **168h Weekly Ledger (The Centerpiece)**: High-contrast time audit tile with interactive **Hour (`[HRS h]`) vs Percentage (`[PCT %]`)** allocation toggle, live capacity gauge (`% USED`), and custom recurring block manager.
  - **Crucible Cost of Delay**: Calculates the financial impact of procrastination using an estimated hourly rate and missed productive time, with an instant Lockdown mode.
  - **Sleep & Recovery Intelligence**: Sleep duration, quality index, and morning alarm recommendations.
  - **Primary Anchor & Objective**: Define single non-negotiable daily objectives and energy peaks.
  - **Terminal Scratchpad**: Instant markdown brain dump with automated local state sync.
  - **GitHub & WakaTime Telemetry**: Real-time pull request pipeline tracking and coding stat counters.

- **System Profile & Identity**:
  - Live real-time clock & date banner.
  - Clerk Auth Zero-Config & Google OAuth identity synchronization.
  - **User Baseline & Rate Calculation**: Forms to establish baseline metrics and calculate estimated hourly rates.

- **Native Android Home Screen AppWidgets**:
  - `DailyAuditWidgetProvider`: Live 168h free hours & time budget.
  - `TaskPulseWidgetProvider`: Live daily completion & peak task metrics.
  - `StreakFlameWidgetProvider`: 21-day discipline ring & particle animation.
  - **Energy Gauge Widget (`EnergyArcWidgetProvider`)**: Visualizes daily energy capacity across primary peaks and recovery periods.
  - `QuotePrismWidgetProvider`: Bhagavad Gita shlokas with Sanskrit transliteration.

---

## 🛠️ Architecture & Tech Stack
*(Architecture diagram coming soon)*

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

---

## 🗺️ Roadmap
- [ ] **Stage 1 (Current): Private Validation**. 60-90 days of daily dogfooding. Validating the 168h ledger and core workflows.
- [ ] **Stage 2: Portfolio Public**. Clean up the repo, document the architecture, ensure widget reliability, and finalize UI.
- [ ] **Stage 3: Product (Optional)**. Consider CI/CD, Privacy Policy, Licensing, and potential Play Store release if it moves beyond a personal tool.

---

## ⚠️ Known Limitations
- The app is currently in Stage 1 validation. The architecture, data models, and UI are subject to frequent changes.
- Syncing and telemetry features are tailored to the current operator's environment and may require configuration to work elsewhere.

---

## 📄 License
This project is currently for personal use. License will be determined prior to the Stage 2 public release.
