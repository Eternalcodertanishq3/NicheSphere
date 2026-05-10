# NicheSphere

Hyperlocal discovery for micro-communities.

## Design Aesthetic
- **Pastel Glassmorphism**: Soft pastel colors with blurred glass surfaces.
- **Animated**: Using `flutter_animate` for smooth transitions and `lottie` for micro-interactions.
- **Interest-First**: Onboarding focused on user interests to curate the feed.

## Tech Stack
- **Framework**: Flutter
- **State Management**: Riverpod
- **Routing**: go_router
- **Animations**: flutter_animate, lottie
- **Backend**: Firebase (Firestore, Auth, Storage) - *Credentials to be added*
- **Maps**: google_maps_flutter

## Getting Started
1. Run `flutter pub get` to install dependencies.
2. Add your `google_services.json` (Android) and `GoogleService-Info.plist` (iOS) for Firebase.
3. Add your Google Maps API key in the respective platform files.
4. Run the app!

## Features Implemented
- [x] Splash Screen with animations
- [x] Onboarding Interest Selector
- [x] Home Feed with Event Carousel
- [x] Glassmorphic UI Components
- [x] Event Details with Hero Transitions
- [x] Map View with custom pins
- [x] Create Event form
- [x] Profile Screen
