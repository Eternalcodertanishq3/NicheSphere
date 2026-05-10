<div align="center">
  <img src="https://raw.githubusercontent.com/NicheSphere/assets/main/logo.png" width="150" alt="NicheSphere Logo">
  <h1>NicheSphere</h1>
  <p><strong>Hyperlocal Micro-Community Event Discovery</strong></p>
  <p>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.19.0-blue.svg?logo=flutter" alt="Flutter"></a>
    <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.3.0-blue.svg?logo=dart" alt="Dart"></a>
    <a href="https://firebase.google.com/"><img src="https://img.shields.io/badge/Firebase-Integrated-FFCA28.svg?logo=firebase" alt="Firebase"></a>
    <a href="https://riverpod.dev/"><img src="https://img.shields.io/badge/Riverpod-2.0-blue.svg" alt="Riverpod"></a>
  </p>
</div>

---

## 🌌 Overview

**NicheSphere** is a premium, beautifully crafted mobile application designed to connect people through shared passions. Move beyond generic city-wide events and discover highly specific, hyperlocal micro-communities—from local indie game dev meetups and sunset watercolor sessions to specialized coffee tasting tours. 

The application utilizes a stunning **pastel glassmorphism** aesthetic, combining blurred layers, neon accents, and organic animations to create a UI that feels alive, modern, and engaging.

---

## ✨ Key Features

* **Hyperlocal Discovery**: Find events happening exactly where you are using advanced geospatial querying.
* **Micro-Communities (Spheres)**: Join specific niches and interact with like-minded individuals.
* **Stunning Glassmorphic UI**: High-end visual design with layered blurs, neon glows, and 60fps animations.
* **Smart Onboarding**: Dynamic, personalized interest selection that tailors your home feed.
* **Real-time Chat**: Connect with event attendees directly in the app.
* **Gamification System**: Earn beautiful neon badges by hosting events, attending meetups, and building communities.

---

## 🛠️ Tech Stack

### Core Architecture
* **Framework**: Flutter (Dart)
* **State Management**: Riverpod 2.0 (Code Generation)
* **Routing**: GoRouter
* **Local Storage**: Hive & Flutter Secure Storage

### Backend & Cloud
* **Authentication**: Firebase Auth (Google & Apple Sign-In)
* **Database**: Cloud Firestore
* **Storage**: Firebase Storage
* **Push Notifications**: Firebase Cloud Messaging (FCM)
* **Analytics**: Firebase Analytics & Crashlytics

### UI & Animations
* **Animations**: flutter_animate & Lottie
* **Design System**: Custom Glassmorphic Component Library

---

## 🎨 Design System

NicheSphere strictly adheres to a carefully curated design language:
* **Typography**: *Outfit* Google Font for a modern, geometric look.
* **Colors**: Soft pastel backgrounds paired with vibrant neon accents (Pink, Purple, Blue, Orange, Green).
* **Components**: 
  * `GlassCard`: The foundational widget using `BackdropFilter` for depth.
  * `AppBottomNav`: A floating, glassmorphic navigation bar with bounce animations.
  * `PastelBubble`: Interactive interest chips with neon glow selection states.

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (>= 3.2.0)
* Dart SDK
* Firebase CLI installed and logged in
* Android Studio / Xcode for emulator setup

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/NicheSphere.git
   cd NicheSphere
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Code (Riverpod, Freezed, Hive):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Configure Firebase:**
   ```bash
   flutterfire configure
   ```

5. **Run the App:**
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

```text
lib/
├── core/                   # Application-wide core configs
│   ├── constants/          # Static values, Enums, Mock Data
│   ├── router/             # GoRouter configuration
│   ├── theme/              # Complete design system (Colors, Styles, Spacing)
│   └── utils/              # Helper functions
├── data/                   # Data layer
│   ├── models/             # Data structures (Event, User, Community)
│   ├── repositories/       # Abstractions for API calls
│   └── services/           # Firebase/Backend connections
├── features/               # Feature-based organization
│   ├── auth/               # Login & Registration
│   ├── home/               # Discover feed
│   ├── onboarding/         # Welcome & Interest selection
│   ├── event_details/      # Hero transition event view
│   ├── profile/            # User profile & Badges
│   └── chat/               # Inbox & messaging
├── shared/                 # Reusable UI components
│   └── widgets/            # GlassCard, PastelBubble, AppButton, etc.
└── main.dart               # Application entry point
```

---

<div align="center">
  <p>Built with ❤️ by NicheSphere Team.</p>
</div>
