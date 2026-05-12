<div align="center">

<img src="https://raw.githubusercontent.com/nichesphere/assets/main/logo.png" width="120" height="120" alt="NicheSphere Logo" />

# NicheSphere

### Hyperlocal Micro-Community Event Discovery

<p>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.38+-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.3+-0175C2?style=flat-square&logo=dart&logoColor=white" alt="Dart" /></a>
  <a href="https://firebase.google.com"><img src="https://img.shields.io/badge/Firebase-Firestore%20%7C%20Auth%20%7C%20FCM-FFCA28?style=flat-square&logo=firebase&logoColor=black" alt="Firebase" /></a>
  <a href="https://riverpod.dev"><img src="https://img.shields.io/badge/Riverpod-2.x-00B4D8?style=flat-square" alt="Riverpod" /></a>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=flat-square" alt="Platform" />
  <img src="https://img.shields.io/badge/License-MIT-blue?style=flat-square" alt="License" />
  <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen?style=flat-square" alt="PRs Welcome" />
</p>

<p>
  <strong>Discover events. Build communities. Find your people.</strong>
  <br />
  NicheSphere connects people through hyperlocal micro-events across every niche—from indie game dev meetups and sunset yoga sessions to artisan coffee tours and D&D campaigns.
</p>

<br />

<img src="https://raw.githubusercontent.com/nichesphere/assets/main/hero-banner.png" width="100%" alt="NicheSphere App Screenshots" />

<br />

[**Live Demo**](https://nichesphere.app) · [**Documentation**](./docs) · [**Report a Bug**](https://github.com/nichesphere/nichesphere/issues/new?template=bug_report.md) · [**Request a Feature**](https://github.com/nichesphere/nichesphere/issues/new?template=feature_request.md)

</div>

---

## Why NicheSphere?

Most event discovery apps show you what's popular. NicheSphere shows you what's **yours**.

Instead of recommending mega-concerts and city-wide festivals, NicheSphere surfaces a 12-person watercolor workshop three blocks away, or a Friday night indie game playtest at the coffee shop down the street. The app learns your interests and connects you with the people who share them — building genuine micro-communities, not just follower counts.

---

## Features

### For Attendees
- **Personalized Discovery** — Interest-based onboarding tailors every feed to you from minute one
- **Hyperlocal Radar** — Geospatial event queries surface events within walking distance
- **One-tap RSVP** — Confirm attendance, get reminders, and join the event group chat instantly
- **Smart Explore** — Filter by date, category, distance, price, and attendee count
- **Live Map View** — Custom pastel-colored pins clustered by category on an interactive map
- **Offline Mode** — Last 50 events cached locally; browse even without a connection

### For Organizers
- **Multi-step Event Builder** — Create events with cover image, location picker, co-hosts, and custom tags
- **Sphere Linking** — Tie events to a Sphere (community) for recurring audiences
- **Attendance Management** — Set capacity limits, track RSVPs, and send group announcements
- **Analytics Dashboard** — Views, RSVP conversion, and attendee demographics
- **Flexible Pricing** — Free, paid ($), or donation-based events with built-in payment handling

### For Communities (Spheres)
- **Sphere Creation** — Build a named micro-community around any interest or niche
- **Member Management** — Public, private, or invite-only communities with admin roles
- **Community Chat** — Real-time group messaging with reactions and image sharing
- **Activity Feed** — See when members RSVP, create events, or hit milestones
- **Trending Spheres** — Discovery surface for growing communities

### Gamification
- **Badge System** — 8 badge categories (Explorer, Host, Builder, Trendsetter...) with tier progression
- **Streak Tracking** — Attendance streaks reward consistent community engagement
- **Leaderboards** — Per-Sphere top contributors (optional, toggled by organizer)

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3.38+ (Dart 3.3+) |
| **State Management** | Riverpod 2.x (AsyncNotifier, code generation) |
| **Navigation** | GoRouter 14.x with auth guards |
| **Auth** | Firebase Auth (Email, Google, Apple) |
| **Database** | Cloud Firestore (real-time streams) |
| **Storage** | Firebase Storage (images, media) |
| **Push Notifications** | Firebase Cloud Messaging (FCM) |
| **Local Notifications** | flutter_local_notifications |
| **Analytics** | Firebase Analytics + Crashlytics |
| **Maps** | Google Maps Flutter + custom pastel style |
| **Geolocation** | Geolocator + geoflutterfire_plus |
| **Local Cache** | Hive + Flutter Secure Storage |
| **Networking** | Dio + connectivity_plus |
| **Images** | CachedNetworkImage + flutter_image_compress |
| **Animations** | flutter_animate + Lottie |
| **Architecture** | Clean Architecture (Data / Domain / Feature) |

---

## Architecture

NicheSphere follows **Clean Architecture** with a strict layer separation:

```
lib/
├── core/           # App-wide config, theme, router, services
├── data/           # Models, Firestore datasources, repository impls
├── domain/         # Entities, abstract repos, use cases
├── features/       # Feature-sliced UI (screens, widgets, providers)
└── shared/         # Reusable widgets, utilities
```

State flows in one direction:

```
UI Widget
  └─ ref.watch(provider)
       └─ AsyncNotifier / Notifier
            └─ UseCase
                 └─ Repository (abstract)
                      └─ RemoteDataSource (Firestore)
                      └─ LocalDataSource (Hive cache)
```

Every async operation returns `Either<Failure, T>` via `fpdart`, making error handling explicit and composable throughout the domain layer.

See [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) for the full breakdown.

---

## Screens

| Screen | Description |
|---|---|
| Splash | Animated logo with floating pastel orbs |
| Onboarding | 3-slide welcome + scattered interest bubble picker |
| Auth | Email/password + Google/Apple SSO with glass UI |
| Home | Discover feed with featured carousel, spheres row, upcoming list |
| Explore | Full-text search + filter sheet + infinite grid |
| Event Details | Hero transition, 3-pill info row, map preview, reviews, RSVP |
| Create Event | 3-step form with image picker, location, co-hosts |
| Map | Full-screen map with clustered pins and event bottom sheet |
| Communities | My Spheres / Discover / Trending tabs |
| Inbox | Chat list + event updates + notifications |
| Chat Room | Real-time group messages with reactions |
| Profile | Stats, badges, interests, events hosted/attended |
| Badges | Achievement grid with unlock progress |
| Settings | Account, preferences, privacy, danger zone |

---

## Design System

NicheSphere ships with a hand-crafted design system:

**Pastel Glassmorphism** — Every surface uses `BackdropFilter` blur with soft pastel tints. Cards feel like frosted glass layered over warm gradients.

**Neon Glow** — Selected states use category-specific neon accents (Gaming=Blue, Art=Pink, Tech=Green, Music=Purple, Food=Orange) with `BoxShadow` glow.

**Outfit Typography** — Single Google Font, 10-step scale from `micro` (10px) to `displayXL` (36px), all weights 400–700.

All design tokens live in `lib/core/theme/`:

```dart
AppColors       // Full palette — backgrounds, neons, bubbles, semantic
AppTextStyles   // 10-step type scale
AppSpacing      // 4px-based spacing grid
AppBorderRadius // xs / sm / md / lg / xl / xxl / pill
```

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.38.0`
- Dart SDK `>=3.3.0`
- Firebase CLI (`npm install -g firebase-tools`)
- Android Studio (for Android emulator) or Xcode 15+ (for iOS)
- A Google Maps API key (Android + iOS)

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/nichesphere/nichesphere.git
cd nichesphere
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Run code generation** (Riverpod, Freezed, Hive adapters)
```bash
dart run build_runner build --delete-conflicting-outputs
```

**4. Configure Firebase**
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Connect to your Firebase project
flutterfire configure
```

**5. Add Google Maps API key**

Android — `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_API_KEY_HERE"/>
```

iOS — `ios/Runner/AppDelegate.swift`:
```swift
GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```

**6. Run the app**
```bash
flutter run
```

### Environment Configuration

Copy `.env.example` to `.env` and fill in your keys:
```bash
cp .env.example .env
```

```env
GOOGLE_MAPS_API_KEY=your_key_here
STRIPE_PUBLISHABLE_KEY=your_key_here   # optional, for paid events
SENTRY_DSN=your_dsn_here               # optional, for error tracking
```

---

## Firestore Data Model

```
/users/{userId}
/events/{eventId}
/communities/{communityId}
/rsvps/{userId}_{eventId}
/follows/{followerId}_{followingId}
/chatRooms/{roomId}
  /messages/{messageId}
/notifications/{notificationId}
/badges/{badgeId}
/userBadges/{userId}/earned/{badgeId}
/reviews/{reviewId}
```

Full schema and security rules: [`docs/FIRESTORE.md`](./docs/FIRESTORE.md)

---

## Contributing

Contributions are welcome and appreciated.

```bash
# 1. Fork the repo and create your branch
git checkout -b feature/amazing-feature

# 2. Make your changes following the code style
flutter analyze
flutter test

# 3. Commit using conventional commits
git commit -m "feat: add event repeat scheduling"

# 4. Push and open a PR
git push origin feature/amazing-feature
```

Please read [`CONTRIBUTING.md`](./CONTRIBUTING.md) before submitting a pull request.

**Branch naming convention:**
- `feature/` — new features
- `fix/` — bug fixes
- `chore/` — maintenance, dependencies
- `docs/` — documentation only

---

## Roadmap

- [x] UI layer — all 20 screens
- [x] Design system — colors, typography, spacing, glassmorphism
- [x] Data models — Event, User, Community, Message, Badge
- [x] Routing — GoRouter with all named routes
- [ ] **Phase 2** — Firebase auth + Firestore repositories
- [ ] **Phase 2** — Riverpod providers replacing MockData
- [ ] **Phase 2** — Real-time chat via Firestore streams
- [ ] **Phase 3** — Google Maps integration + geospatial queries
- [ ] **Phase 3** — Push notifications (FCM + local)
- [ ] **Phase 3** — Image upload with compression
- [ ] **Phase 4** — Badge system + gamification logic
- [ ] **Phase 4** — Paid events (Stripe integration)
- [ ] **Phase 5** — Analytics dashboard for organizers
- [ ] **Phase 5** — Play Store release

---

## License

Distributed under the MIT License. See [`LICENSE`](./LICENSE) for details.

---

## Acknowledgements

- [Flutter](https://flutter.dev) — the framework that makes beautiful cross-platform apps possible
- [Firebase](https://firebase.google.com) — real-time backend infrastructure
- [Riverpod](https://riverpod.dev) — elegant, compile-safe state management
- [flutter_animate](https://pub.dev/packages/flutter_animate) — effortless animation chaining
- [Outfit](https://fonts.google.com/specimen/Outfit) — the typeface that defines NicheSphere's voice
- [Unsplash](https://unsplash.com) — placeholder imagery during development

---

<div align="center">

Built with ❤️ by the NicheSphere team

[Website](https://nichesphere.app) · [Twitter](https://twitter.com/nichesphere) · [Discord](https://discord.gg/nichesphere)

</div>
