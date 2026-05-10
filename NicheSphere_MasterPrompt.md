# NicheSphere — Full Production Rebuild Master Prompt

> Copy this entire prompt into your AI coding agent (Claude Code, Cursor, etc.)
> to scaffold the complete app from scratch.

---

## ROLE & MISSION

You are a senior Flutter engineer and UI/UX architect. Your task is to build
**NicheSphere** — a hyperlocal micro-community event discovery app — completely
from scratch. This must be **Play Store-ready**, production-grade, fully
scalable, and maintainable. Delete any prior code in the project and rebuild
everything from the ground up following every specification below.

---

## SECTION 1 — DESIGN SYSTEM (NON-NEGOTIABLE)

This is the most critical section. Every pixel must match this spec.

### 1.1 Color Palette

```dart
// lib/core/theme/app_colors.dart

// ── Backgrounds ──────────────────────────────────
static const Color bgPrimary    = Color(0xFFFFF8F0); // Warm peach-white
static const Color bgSecondary  = Color(0xFFFFF1E6); // Soft peach
static const Color bgTertiary   = Color(0xFFFDE8D8); // Deeper peach

// ── Pastel Gradients (use in LinearGradient) ─────
static const Color gradStart    = Color(0xFFFFF1E6); // Peach
static const Color gradMid      = Color(0xFFFFE4F0); // Blush pink
static const Color gradEnd      = Color(0xFFE8E4FF); // Soft lavender

// ── Glass surfaces ───────────────────────────────
static const Color glassWhite   = Color(0xCCFFFFFF); // 80% white
static const Color glassPink    = Color(0x33FFB3C6); // 20% pink
static const Color glassBlue    = Color(0x33B3C6FF); // 20% blue

// ── Neon Glow (selected states, CTAs) ────────────
static const Color neonBlue     = Color(0xFF6C8EFF); // Gaming
static const Color neonPink     = Color(0xFFFF6CB0); // Anime/Art  
static const Color neonGreen    = Color(0xFF5BFFC8); // Tech
static const Color neonPurple   = Color(0xFFB06CFF); // Music
static const Color neonOrange   = Color(0xFFFFB06C); // Food/Travel

// ── Bubble Pastels (unselected tags) ─────────────
static const Color bubblePink   = Color(0xFFFFD6E7);
static const Color bubbleBlue   = Color(0xFFD6E4FF);
static const Color bubbleGreen  = Color(0xFFD6FFF0);
static const Color bubbleYellow = Color(0xFFFFFAD6);
static const Color bubblePurple = Color(0xFFEDD6FF);
static const Color bubbleMint   = Color(0xFFD6FFF9);
static const Color bubblePeach  = Color(0xFFFFE8D6);

// ── Text ─────────────────────────────────────────
static const Color textPrimary   = Color(0xFF2D2D3A);
static const Color textSecondary = Color(0xFF6B6B80);
static const Color textHint      = Color(0xFFAAAAAF);
static const Color textOnDark    = Color(0xFFF8F8FF);

// ── Semantic ──────────────────────────────────────
static const Color success = Color(0xFF5BFFC8);
static const Color warning = Color(0xFFFFD96C);
static const Color error   = Color(0xFFFF6C8E);
static const Color info    = Color(0xFF6CB0FF);
```

### 1.2 Typography — Google Fonts: Outfit

```dart
// All text uses Outfit font exclusively.
// Scale:
displayXL : Outfit 36px Bold    (splash logo text)
displayL  : Outfit 28px Bold    (screen titles like "Discover")
titleXL   : Outfit 22px SemiBold
titleL    : Outfit 18px SemiBold
titleM    : Outfit 16px SemiBold
bodyL     : Outfit 15px Regular
bodyM     : Outfit 14px Regular
bodyS     : Outfit 13px Regular
label     : Outfit 12px Medium  (tags, chips, badges)
micro     : Outfit 10px Regular (captions)
```

### 1.3 Glassmorphism Card Spec

Every glass card must use this exact implementation:

```dart
// lib/shared/widgets/glass_card.dart
// Parameters: blur (default 20), opacity (default 0.15), 
// borderOpacity (default 0.3), glowColor (optional)
//
// Implementation:
// 1. ClipRRect with borderRadius
// 2. BackdropFilter blur sigmaX=blur, sigmaY=blur
// 3. Container with color = Colors.white.withOpacity(opacity)
// 4. Border: 1.5px solid Colors.white.withOpacity(borderOpacity)
// 5. Optional: BoxShadow with glowColor.withOpacity(0.2) blurRadius=20
```

### 1.4 Background Gradient (every screen)

Every scaffold background must be:
```dart
BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.bgSecondary,   // warm peach
      Colors.white,
      AppColors.gradEnd,       // soft lavender
    ],
    stops: [0.0, 0.5, 1.0],
  ),
)
```

### 1.5 Neon Glow Effect (selected interest bubbles & CTAs)

```dart
// When a bubble/chip is selected:
BoxShadow(
  color: neonColor.withOpacity(0.35),
  blurRadius: 16,
  spreadRadius: 2,
  offset: Offset(0, 2),
)
// Border: 2px solid neonColor.withOpacity(0.8)
// Background: neonColor.withOpacity(0.18)
```

### 1.6 Border Radius Scale
```
xs: 8px   (chips, badges)
sm: 12px  (small cards)
md: 16px  (buttons)
lg: 24px  (cards)
xl: 32px  (event image cards)
xxl: 40px (bottom sheet header, modal top)
pill: 999px (tags, nav items)
```

### 1.7 Spacing Scale (use multiples of 4)
`4 8 12 16 20 24 32 40 48 64 80`

### 1.8 Animation Principles
- Page transitions: FadeTransition + slight vertical slide (20px up), 300ms
- List items: staggered fadeIn + slideX (20px), 150ms delay per item
- Interest bubbles: scale 1.0→1.08 + shimmer on select, 200ms
- Cards: scale 0.98→1.0 on tap (press feedback), 100ms
- Bottom nav: selected icon does a small bounce (scale 1.2→1.0), 200ms
- All curves: Curves.easeOutCubic unless specified

---

## SECTION 2 — ARCHITECTURE

### 2.1 Folder Structure

```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart          # env config, feature flags
│   │   └── firebase_options.dart    # generated
│   ├── constants/
│   │   ├── app_constants.dart       # strings, numbers
│   │   └── asset_paths.dart         # all asset paths as constants
│   ├── di/
│   │   └── providers.dart           # all global Riverpod providers
│   ├── errors/
│   │   ├── app_exception.dart       # base exception class
│   │   ├── failures.dart            # typed failures
│   │   └── error_handler.dart       # global error handler
│   ├── extensions/
│   │   ├── context_extensions.dart  # mediaQuery, theme, navigator
│   │   ├── string_extensions.dart
│   │   ├── date_extensions.dart
│   │   └── list_extensions.dart
│   ├── network/
│   │   ├── api_client.dart          # Dio client + interceptors
│   │   └── connectivity_service.dart
│   ├── router/
│   │   ├── app_router.dart          # GoRouter config
│   │   ├── route_names.dart         # const route name strings
│   │   └── route_guards.dart        # auth guard, onboarding guard
│   ├── services/
│   │   ├── analytics_service.dart   # Firebase Analytics wrapper
│   │   ├── crash_reporting.dart     # Firebase Crashlytics wrapper
│   │   ├── notification_service.dart# FCM + local notifications
│   │   ├── location_service.dart    # Geolocator wrapper
│   │   └── storage_service.dart     # Hive + SecureStorage wrapper
│   └── theme/
│       ├── app_colors.dart
│       ├── app_text_styles.dart
│       ├── app_theme.dart
│       ├── app_spacing.dart
│       └── app_border_radius.dart
│
├── data/
│   ├── datasources/
│   │   ├── remote/
│   │   │   ├── event_remote_ds.dart
│   │   │   ├── user_remote_ds.dart
│   │   │   ├── community_remote_ds.dart
│   │   │   └── chat_remote_ds.dart
│   │   └── local/
│   │       ├── event_local_ds.dart
│   │       └── user_local_ds.dart
│   ├── models/
│   │   ├── event_model.dart         # with fromJson/toJson/fromFirestore
│   │   ├── user_model.dart
│   │   ├── community_model.dart
│   │   ├── message_model.dart
│   │   ├── badge_model.dart
│   │   ├── rsvp_model.dart
│   │   └── review_model.dart
│   └── repositories/
│       ├── event_repository_impl.dart
│       ├── user_repository_impl.dart
│       ├── community_repository_impl.dart
│       └── chat_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   ├── event.dart
│   │   ├── user.dart
│   │   ├── community.dart
│   │   ├── message.dart
│   │   └── badge.dart
│   ├── repositories/
│   │   ├── event_repository.dart    # abstract
│   │   ├── user_repository.dart
│   │   ├── community_repository.dart
│   │   └── chat_repository.dart
│   └── usecases/
│       ├── events/
│       │   ├── get_nearby_events.dart
│       │   ├── get_event_by_id.dart
│       │   ├── create_event.dart
│       │   ├── rsvp_event.dart
│       │   ├── search_events.dart
│       │   └── get_trending_events.dart
│       ├── users/
│       │   ├── get_user_profile.dart
│       │   ├── update_profile.dart
│       │   ├── follow_user.dart
│       │   └── get_user_badges.dart
│       └── communities/
│           ├── get_communities.dart
│           ├── join_community.dart
│           └── create_community.dart
│
├── features/
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── onboarding/
│   │   ├── screens/
│   │   │   ├── welcome_screen.dart
│   │   │   ├── interest_selector_screen.dart
│   │   │   ├── location_permission_screen.dart
│   │   │   └── notification_permission_screen.dart
│   │   ├── widgets/
│   │   │   ├── interest_bubble.dart
│   │   │   └── onboarding_progress.dart
│   │   └── providers/
│   │       └── onboarding_provider.dart
│   ├── auth/
│   │   ├── screens/
│   │   │   ├── auth_gate.dart
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   └── forgot_password_screen.dart
│   │   ├── widgets/
│   │   │   ├── social_auth_button.dart
│   │   │   └── auth_text_field.dart
│   │   └── providers/
│   │       └── auth_provider.dart
│   ├── home/
│   │   ├── screens/
│   │   │   └── home_screen.dart
│   │   ├── widgets/
│   │   │   ├── featured_event_card.dart
│   │   │   ├── event_list_tile.dart
│   │   │   ├── category_chip.dart
│   │   │   ├── sphere_chip.dart       # "Popular Spheres" row
│   │   │   └── section_header.dart
│   │   └── providers/
│   │       └── home_provider.dart
│   ├── explore/
│   │   ├── screens/
│   │   │   └── explore_screen.dart
│   │   ├── widgets/
│   │   │   ├── search_bar.dart
│   │   │   ├── filter_sheet.dart
│   │   │   └── explore_grid_tile.dart
│   │   └── providers/
│   │       └── explore_provider.dart
│   ├── event_details/
│   │   ├── screens/
│   │   │   └── event_details_screen.dart
│   │   ├── widgets/
│   │   │   ├── attendee_avatars.dart
│   │   │   ├── event_info_row.dart
│   │   │   ├── similar_events_row.dart
│   │   │   ├── organizer_card.dart
│   │   │   └── rsvp_bottom_sheet.dart
│   │   └── providers/
│   │       └── event_details_provider.dart
│   ├── create_event/
│   │   ├── screens/
│   │   │   └── create_event_screen.dart
│   │   ├── widgets/
│   │   │   ├── media_picker_tile.dart
│   │   │   ├── location_picker.dart
│   │   │   └── tag_input.dart
│   │   └── providers/
│   │       └── create_event_provider.dart
│   ├── communities/
│   │   ├── screens/
│   │   │   ├── communities_screen.dart
│   │   │   └── community_detail_screen.dart
│   │   ├── widgets/
│   │   │   ├── community_card.dart
│   │   │   └── member_list_tile.dart
│   │   └── providers/
│   │       └── communities_provider.dart
│   ├── map/
│   │   ├── screens/
│   │   │   └── map_screen.dart
│   │   ├── widgets/
│   │   │   ├── custom_map_pin.dart
│   │   │   └── map_event_sheet.dart
│   │   └── providers/
│   │       └── map_provider.dart
│   ├── chat/
│   │   ├── screens/
│   │   │   ├── inbox_screen.dart
│   │   │   └── chat_room_screen.dart
│   │   ├── widgets/
│   │   │   ├── message_bubble.dart
│   │   │   ├── chat_list_tile.dart
│   │   │   └── message_input.dart
│   │   └── providers/
│   │       └── chat_provider.dart
│   ├── notifications/
│   │   ├── screens/
│   │   │   └── notifications_screen.dart
│   │   ├── widgets/
│   │   │   └── notification_tile.dart
│   │   └── providers/
│   │       └── notifications_provider.dart
│   ├── profile/
│   │   ├── screens/
│   │   │   ├── profile_screen.dart
│   │   │   ├── edit_profile_screen.dart
│   │   │   ├── badges_screen.dart
│   │   │   └── followers_screen.dart
│   │   ├── widgets/
│   │   │   ├── badge_card.dart
│   │   │   ├── stats_row.dart
│   │   │   └── hosted_events_list.dart
│   │   └── providers/
│   │       └── profile_provider.dart
│   └── settings/
│       ├── screens/
│       │   ├── settings_screen.dart
│       │   ├── privacy_screen.dart
│       │   └── blocked_users_screen.dart
│       └── providers/
│           └── settings_provider.dart
│
└── shared/
    ├── widgets/
    │   ├── glass_card.dart
    │   ├── pastel_bubble.dart
    │   ├── app_bottom_nav.dart
    │   ├── app_snackbar.dart
    │   ├── loading_shimmer.dart
    │   ├── empty_state.dart
    │   ├── error_state.dart
    │   ├── avatar_widget.dart
    │   ├── success_overlay.dart
    │   ├── gradient_background.dart
    │   └── app_button.dart
    └── utils/
        ├── date_utils.dart
        ├── image_utils.dart
        └── validator_utils.dart
```

### 2.2 State Management Rules
- All state via **Riverpod 2.x** (AsyncNotifier, Notifier, StreamProvider)
- No StatefulWidget except for pure animation controllers
- All providers are `final` and auto-disposed unless global
- Use `ref.watch` in build, `ref.read` in callbacks
- Use `AsyncValue` everywhere (.when, .data, .error, .loading)

### 2.3 Repository Pattern
- Domain layer has abstract repository interfaces
- Data layer implements them (Firestore + local cache via Hive)
- UseCases call repositories, return `Either<Failure, T>` using `fpdart` package

---

## SECTION 3 — ALL SCREENS & FEATURES

### SCREEN 1: Splash Screen
- Full screen gradient background (peach → lavender)
- Animated cherry blossom logo (Lottie or flutter_animate)
- Logo: scale from 0.5 to 1.0 with elastic curve, 800ms
- "NicheSphere" text: fade in 600ms delay
- "Hyperlocal Micro-Communities" subtitle: fade in 900ms delay
- Floating particle orbs: 6 soft pastel circles, animate slowly floating
- After 3s: navigate to AuthGate (check if user is logged in + onboarded)

### SCREEN 2: Welcome Screen (Onboarding Step 1)
- Full page illustrations (use simple SVG or Lottie) for 3 slides:
  1. "Discover nearby people who share your passions"
  2. "Join micro-events crafted for your interests"
  3. "Build your local micro-community"
- PageView with dot indicators (animated, pastel)
- "Get Started" button → InterestSelectorScreen
- "Already have an account? Sign In" text button
- Skip button top right

### SCREEN 3: Interest Selector Screen (Onboarding Step 2)
EXACT UI from Image 3 — this is critical:
- Warm peach gradient background (Color(0xFFFFF1E6) to Color(0xFFFFE0CC))
- Title: "What are you into?" — Outfit Bold 28px, dark charcoal
- Subtitle: "Pick at least 3 to personalize your feed"
- **Floating scattered bubble layout** — NOT a simple Wrap:
  - Use a Stack with manually positioned Positioned widgets for a organic scattered look
  - Each bubble has a random-ish slight rotation (-8° to +8°)
  - Some bubbles are larger (featured interests), some smaller
- Interest list with neon colors when selected:
  Art, Reading, Movies, Gaming (neon blue), Photography, Travel, Fashion,
  Fitness, Anime (neon pink), Cooking, Sci-Fi, Tech (neon green), Comics,
  Nature, K-Pop, Design, Writing, Music (neon purple), History, Coffee,
  D&D, Sports, Hiking, Pets, DIY, Plants, Vintage, Streetwear, Crypto
- Selected bubble: neon glow (color specific to category), scale 1.1,
  bold text, colored background, white border with glow
- Unselected: soft pastel fill, light border, regular weight text
- Bottom: "Continue" button — peach/coral gradient, rounded pill,
  disabled (gray) until 3+ selected
- Minimum 3 selections to enable Continue
- flutter_animate staggered entrance: bubbles float in from different
  directions with 20ms stagger per bubble

### SCREEN 4: Location Permission (Onboarding Step 3)
- Illustration: simple map pin with pastel circles radiating outward
- Title: "Find events near you"
- Body: "Allow location access to see what's happening in your neighborhood"
- "Allow Location" primary button
- "Not now" ghost button
- Request geolocator permission on button tap

### SCREEN 5: Notification Permission (Onboarding Step 4)
- Similar layout to location screen
- Bell icon animation (gentle ring)
- "Enable notifications" + "Maybe later"

### SCREEN 6: Auth Gate + Login/Register
- AuthGate: checks Firebase Auth state, redirects to home or onboarding
- Login Screen:
  - Glass card on gradient background
  - Logo at top
  - Email + Password fields with glassmorphic styling
  - "Forgot password?" link
  - "Sign In" primary button (gradient: pink → lavender)
  - Divider "or continue with"
  - Google SSO button, Apple SSO button (styled with glass)
  - "New to NicheSphere? Sign Up" link
- Register Screen:
  - Name, Email, Password, Confirm Password
  - Real-time password strength indicator (colored bar)
  - Username field with live availability check (debounced)
  - Avatar picker (camera / gallery / default avatars)
  - Terms checkbox
- Forgot Password: just email field + send reset link

### SCREEN 7: Home Screen — "Discover"
EXACT UI from Image 1, plus much more:

**Header**:
- NicheSphere logo (small, left) + location pill (current city, tappable) right
- Avatar (top right, tappable → profile)
- "Discover" in large Outfit Bold with gradient text effect (pink→purple)
- "Nearby Events" subtitle

**Search Bar** (below header):
- Glassmorphic pill search bar
- 🔍 icon left, filter icon right
- Tapping opens Explore/Search screen

**Category Chips** (horizontal scrollable):
- 🏠 All, 🎮 Gaming, 💪 Fitness, 🎨 Art, 💻 Tech, 🍳 Cooking,
  🎵 Music, 🧘 Wellness, 📚 Books, 🐾 Pets, ☕ Coffee, 🎭 Events
- Selected chip: neon glow, filled color
- Unselected: glass/frosted

**Featured Event Carousel** (horizontal scroll):
- Each card: 280x380px
- Full bleed image with gradient overlay (transparent → black 70% bottom)
- Category badge top-left (colored by category)
- Live attendee count badge top-right (pulsing dot if event is live/today)
- Title, location, time at bottom on glass panel
- Heart/save button (top right of card)
- Tap → EventDetails with Hero transition
- PageView indicator dots below

**"Popular Spheres" section**:
- Horizontal scroll row of sphere chips (communities)
- Each has emoji + name + member count
- Exactly as shown in Image 1: Fitness, Gaming, Art, Tech, Cooking, etc.

**"Happening Now"** (if any events are live today):
- Special highlighted row with pulsing live indicator
- Horizontal scroll of live event cards

**"Upcoming Near You"** (vertical list):
- Glass list tiles with thumbnail, title, date/time, attendee count
- Show distance (e.g. "0.8 km away")
- RSVP quick-button on each tile

**"You Might Like"** (personalized based on interests):
- Horizontal scroll, smaller cards 200x240px

**"New Spheres (Communities)"** row

**Bottom Navigation Bar** (glassmorphic floating):
- EXACTLY as shown in Image 1: Home, Explore, Create (+), Inbox, Profile
- Floating, 24px margins from sides and bottom
- GlassCard with blur=20, opacity=0.6
- Selected icon: filled variant + label
- Create (+) icon: larger, gradient fill circle
- Animated badge on Inbox for unread count

### SCREEN 8: Explore Screen
- Full screen with:
  - Animated glassmorphic search bar (expands on focus)
  - Filter chips: All / Today / This Week / Free / Online
  - Trending categories grid (2 col) with gradient cards
  - Recent searches (Hive persisted)
  - Popular near you: infinite scroll grid
  - Filter bottom sheet: date range, category multi-select,
    distance slider, free/paid toggle, min attendees

### SCREEN 9: Event Details Screen
EXACT UI from Image 2, plus:

**Top section**:
- Full width hero image (height = 55% of screen)
- Back button (glass pill, top left)
- Share button (glass pill, top right)
- More options (•••) button

**Content sheet** (slides up over image, white, rounded corners 40px top):
- Category badge (colored)
- Event title (Outfit Bold 24px)
- "by [Organizer Community]" subtitle
- **3-pill info row** (exactly as Image 2):
  - 📅 Date pill (glass)
  - 📍 Location pill (glass)
  - 👤 Organizer pill with avatar (glass)
- Description text (expandable, "Read more" if > 3 lines)
- Attendee count + "X spots left" warning (if nearly full)
- Attendee avatars row (overlapping circles, +N more)
- **Map preview** (mini Google Map widget, tappable → full map)
- "Similar Events" horizontal row
- **Organizer card**: avatar, name, bio, follow button, events count
- **Reviews/Ratings section**: star rating, review cards
- **"Attend Event"** CTA button (full width, gradient pill, bold)
  - If already attending: "You're Going! ✓" (green)
  - Shows share sheet option after RSVP

### SCREEN 10: Create Event Screen
- Multi-step form (3 steps, progress bar at top):
  
  **Step 1 — Basics**:
  - Event name (large text field, glass)
  - Description (multiline, glass)
  - Category selector (horizontal scroll of icon+label chips)
  
  **Step 2 — Details**:
  - Media picker: drag/drop or tap — shows image preview with edit overlay
  - Date & Time picker: custom animated wheel picker with pastel styling
  - Duration picker
  - Location: text field + map pin picker (opens mini map)
  - Max attendees toggle + number input
  - Free / Paid toggle (if paid: price field + currency)
  
  **Step 3 — Community**:
  - Link to a Sphere (community) or create standalone
  - Tags input (add custom tags)
  - Visibility: Public / Friends only / Private (invite link)
  - Co-hosts: search and add users
  
- Navigation: Back/Next buttons + step dots
- Publish button (step 3): animates to success overlay (Lottie confetti)

### SCREEN 11: Communities (Spheres) Screen
- Header: "Your Spheres" + "Discover Spheres"
- Tab bar: My Spheres | Discover | Trending
- Community card: banner image, sphere name, member count, category,
  short description, Join/Joined button
- Create Sphere FAB button (pastel gradient)

### SCREEN 12: Community Detail Screen
- Banner image + sphere logo (overlapping)
- Name, member count, category
- About text
- Upcoming events from this sphere
- Members grid (top members)
- Join/Leave button
- Chat shortcut button

### SCREEN 13: Map Screen
- Full screen Google Map
- Custom pastel-colored map pins (by category color)
- Cluster pins when zoomed out
- Floating glass search bar at top
- My Location button (glass pill, bottom right)
- Bottom sheet: tapping a pin shows event preview sheet
  (slides up, shows image + title + quick RSVP)
- Filter fab: filter which categories show on map
- Map style: custom light pastel style JSON (apply to GoogleMap via mapStyle)

### SCREEN 14: Inbox Screen
- Tab bar: Chats | Event Updates | Notifications
- Chats: list of chat rooms (event group chats + DMs)
  - Each tile: avatar, name, last message preview, time, unread badge
- Event Updates: RSVP confirmations, event changes, reminders
- Notifications: follows, likes, comments

### SCREEN 15: Chat Room Screen
- Event group chat OR DM
- Header: event/user name + avatar + status
- Message bubbles:
  - Own messages: right-aligned, gradient fill (pink→purple), white text
  - Other messages: left-aligned, glass card, dark text
  - Timestamps + read receipts
- Message input bar (glass pill):
  - Text field (expands to multiline)
  - Attachment button (image from gallery)
  - Emoji button
  - Send button (gradient circle when text present)
- Reaction support (long press → emoji picker)
- Event info banner at top (pinned, tappable)

### SCREEN 16: Notifications Screen
- Grouped by: Today, This Week, Earlier
- Notification types:
  - Someone RSVPed to your event
  - Event reminder (24h before)
  - New follower
  - Comment on your event
  - Event you saved has spots filling up
  - Community post
- Each tile: avatar, action text, time, event thumbnail if relevant
- Mark all as read button
- Swipe to dismiss

### SCREEN 17: Profile Screen
- Header: gradient background with avatar (large, 80px radius)
- Name (bold), username (@handle), bio
- Location tag (pill)
- Stats row: Events Hosted | Events Attended | Followers | Following
  (all tappable → respective lists)
- **Badges section** (horizontal scroll):
  - Earned badges with icons and names
  - "View All Badges" button
- **Interests tags** (horizontal scroll of colored bubbles)
- **Upcoming events** I'm attending
- **Events I'm Hosting** list
- Edit Profile button (top right, glass pill)
- Share Profile button
- If viewing others' profile: Follow / Message button

### SCREEN 18: Edit Profile Screen
- Avatar picker (camera/gallery, shows cropper)
- Name, Username, Bio (char count), Location, Website
- Interest re-selector
- Social links (Instagram, Twitter, etc.)
- Save button

### SCREEN 19: Badges Screen
- Header: "Your Achievements"
- Stats: X badges earned / Y to unlock
- Grid of badge cards:
  - Earned: full color + name + unlock date
  - Locked: grayscale + "X events to unlock"
- Badge categories: Explorer, Host, Community Builder, Trendsetter, etc.
- Lottie animation when first unlocking a badge (trophy pop)

### SCREEN 20: Settings Screen
- Glass list tiles grouped:
  - Account: Edit Profile, Change Password, Connected Accounts
  - Preferences: Notifications, Privacy, Location Sharing
  - App: Theme, Language, Clear Cache
  - Support: Help Center, Report a Bug, Rate the App
  - Danger Zone: Delete Account (confirmation dialog)
- Each row: icon (pastel colored) + label + chevron

---

## SECTION 4 — DATA MODELS

```dart
// lib/data/models/event_model.dart
class EventModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> tags;
  final DateTime startAt;
  final DateTime endAt;
  final String locationName;
  final String locationAddress;
  final GeoPoint coordinates;
  final String imageUrl;
  final List<String> imageUrls;      // gallery
  final int attendeeCount;
  final int maxAttendees;            // 0 = unlimited
  final bool isFree;
  final double? price;
  final String currency;
  final String organizerId;
  final String organizerName;
  final String? organizerAvatarUrl;
  final String? communityId;         // linked Sphere
  final EventStatus status;          // upcoming|live|ended|cancelled
  final EventVisibility visibility;  // public|friendsOnly|private
  final List<String> coHostIds;
  final double avgRating;
  final int reviewCount;
  final DateTime createdAt;
  final bool isFeatured;
  final String? liveStreamUrl;       // for hybrid events
}

// lib/data/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final String? location;
  final String? website;
  final List<String> interests;
  final int eventsHosted;
  final int eventsAttended;
  final int followersCount;
  final int followingCount;
  final List<String> badgeIds;
  final UserSettings settings;
  final DateTime createdAt;
  final bool isVerified;
}

// lib/data/models/community_model.dart
class CommunityModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final String bannerUrl;
  final int memberCount;
  final String creatorId;
  final List<String> adminIds;
  final bool isPrivate;
  final DateTime createdAt;
  final List<String> tags;
  final double activityScore;  // for trending sort
}

// lib/data/models/message_model.dart
class MessageModel {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String senderName;
  final String? senderAvatarUrl;
  final String content;
  final MessageType type; // text|image|event_share|system
  final String? imageUrl;
  final DateTime sentAt;
  final List<String> readBy;
  final Map<String, String> reactions; // userId → emoji
}
```

---

## SECTION 5 — FIREBASE STRUCTURE

```
Firestore Collections:
/events/{eventId}
/users/{userId}
/communities/{communityId}
/chatRooms/{roomId}/messages/{messageId}
/rsvps/{rsvpId}
/reviews/{reviewId}
/notifications/{notificationId}
/badges/{badgeId}
/userBadges/{userId}/earned/{badgeId}
/follows/{followId}  (followerId + followingId)

Security Rules:
- Events: anyone can read public events; only creator can write
- Users: owner can write own profile; all can read public fields
- ChatRooms: only members can read/write
- RSVPs: authenticated users only
- Communities: anyone reads public; members write posts
```

---

## SECTION 6 — PUBSPEC.YAML (COMPLETE)

```yaml
name: nichesphere
description: Hyperlocal micro-community event discovery
version: 1.0.0+1
publish_to: none

environment:
  sdk: ">=3.2.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  # State & Navigation
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^14.2.0

  # Firebase
  firebase_core: ^2.32.0
  firebase_auth: ^4.19.6
  cloud_firestore: ^4.17.5
  firebase_storage: ^11.7.6
  firebase_messaging: ^14.9.4
  firebase_analytics: ^10.10.7
  firebase_crashlytics: ^3.5.7
  firebase_performance: ^0.9.4+7

  # UI & Animation
  flutter_animate: ^4.5.0
  lottie: ^3.1.2
  google_fonts: ^6.2.1
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0

  # Maps & Location
  google_maps_flutter: ^2.9.0
  geolocator: ^11.1.0
  geocoding: ^3.0.0

  # Storage & Local DB
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.2.2

  # Networking
  dio: ^5.7.0
  pretty_dio_logger: ^1.4.0

  # Image
  image_picker: ^1.1.2
  image_cropper: ^8.0.2
  flutter_image_compress: ^2.3.0

  # Utilities
  intl: ^0.19.0
  timeago: ^3.7.0
  uuid: ^4.4.2
  permission_handler: ^11.3.1
  url_launcher: ^6.3.0
  share_plus: ^10.0.2
  fpdart: ^1.1.0
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

  # Auth (Social)
  google_sign_in: ^6.2.1
  sign_in_with_apple: ^6.1.2

  # Notifications
  flutter_local_notifications: ^17.2.3

  # Forms
  reactive_forms: ^17.0.1

  # Other
  package_info_plus: ^8.1.2
  connectivity_plus: ^6.1.0
  flutter_svg: ^2.0.10+1
  dotted_border: ^2.1.0
  smooth_page_indicator: ^1.2.0+3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.12
  riverpod_generator: ^2.4.3
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  hive_generator: ^2.0.1
  mocktail: ^1.0.4

flutter:
  uses-material-design: true
  assets:
    - assets/animations/
    - assets/images/
    - assets/icons/
    - assets/fonts/
    - assets/map_styles/
```

---

## SECTION 7 — KEY WIDGET IMPLEMENTATIONS

### 7.1 GlassCard (master implementation)
```dart
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderOpacity;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? tintColor;
  final Color? glowColor;
  final double glowIntensity;
  final VoidCallback? onTap;

  // In build():
  // 1. GestureDetector (if onTap)
  // 2. ClipRRect
  // 3. BackdropFilter blur
  // 4. AnimatedContainer (for tap scale feedback)
  // 5. Container with glass decoration
}
```

### 7.2 AppBottomNav
```dart
// Floating glass bottom nav
// Positioned(bottom: 24, left: 24, right: 24)
// GlassCard with blur=20, opacity=0.65, border radius pill
// 5 items: Home(ti-home), Explore(ti-search), Create(custom FAB), 
//          Inbox(ti-bell), Profile(ti-user)
// Create button: gradient circle (pink→purple), 52px, raised above bar
// Unread badge: small red circle with count on Inbox icon
// Selected: icon fills + label appears with fade, glow dot below icon
// Animation: selected icon bounces scale 1.0→1.2→1.0 on select, 300ms
```

### 7.3 InterestBubble
```dart
// Scattered floating layout:
// - Build with Stack + Positioned (use deterministic offset from interest index)
// - Each bubble positioned with: top=sin(i*0.9)*spread, left=cos(i*1.2)*spread
// - Selected: AnimatedContainer with neonColor bg, glow shadow, scale 1.08
// - Unselected: AnimatedContainer with pastelColor bg, 0.3 opacity
// - Both: rounded pill, border, flutter_animate .scale on state change
// - Icon prefix for known categories (gaming controller, art palette, etc.)
```

### 7.4 EventCard (carousel)
```dart
// 280×380px card
// Hero tag: 'event-image-${event.id}'
// Stack:
//   - CachedNetworkImage (BoxFit.cover)
//   - Gradient overlay (transparent → black 65%, bottom half only)
//   - Top-left: category badge (glass, colored text)
//   - Top-right: heart/save button (glass circle)
//   - Top-right: live pulse badge if event is today
//   - Bottom: glass card with title, location, time, attendee count
// Tap: Hero navigate to EventDetails
```

### 7.5 LoadingShimmer
```dart
// Use shimmer package
// Pastel shimmer: base=Color(0xFFE8E4FF), highlight=Colors.white
// Match exact layout of the card/tile it's replacing
// Show 3-5 placeholder cards in carousel, 3 list tiles
```

---

## SECTION 8 — GAMIFICATION & ENGAGEMENT FEATURES

### 8.1 Badge System
Implement these badge tiers:
- **Explorer**: attend 1 / 5 / 25 / 100 events
- **Host**: host 1 / 5 / 25 events
- **Community Builder**: join 3 / 10 / 25 communities
- **Trendsetter**: have event reach 50 / 100 / 500 attendees
- **Social Butterfly**: follow 10 / 50 users
- **Early Bird**: RSVP to event > 7 days before
- **Local Legend**: attend 10+ events in same city
- **Category Master**: attend 10 events in same category

On badge unlock: full-screen Lottie confetti overlay + badge zoom-in animation

### 8.2 Activity Feed
Home screen shows a "Community Activity" section:
- "{User} just joined {Event}"
- "{User} created a new event in {Sphere}"
- "{Sphere} hit {N} members!"
- Styled as a horizontal scrollable story-bubble row at top

### 8.3 Event Reminders
- Opt-in local notifications: 24h before, 1h before
- Scheduled with flutter_local_notifications
- Firebase Cloud Messaging for organizer announcements

---

## SECTION 9 — PERFORMANCE & PRODUCTION CHECKLIST

### 9.1 Image Optimization
- All NetworkImage replaced with CachedNetworkImage
- flutter_image_compress for upload before Firebase Storage
- Thumbnail vs full image (Firestore stores both URLs)
- BlurHash placeholder while loading (compute on upload)

### 9.2 Offline Support
- Hive caches: last 50 home feed events, user profile, interests
- Connectivity check on launch (connectivity_plus)
- Offline banner widget: "You're offline — showing cached content"
- Optimistic UI updates for RSVP / heart / follow (revert on failure)

### 9.3 Error Handling
- Every async operation wrapped in try/catch
- AppSnackbar utility: success (green), error (pink), info (blue)
- FirebaseException → user-friendly messages
- Network timeout → retry button in error state widget
- Sentry/Crashlytics for unhandled exceptions

### 9.4 Analytics Events (Firebase)
Track: app_open, event_viewed, event_rsvp, interest_selected,
community_joined, search_performed, map_opened, event_created,
profile_viewed, badge_earned, notification_clicked

### 9.5 Accessibility
- All images have semanticsLabel
- All buttons have Tooltip or semantic label
- Minimum tap target 48x48px
- Support system font scaling (use MediaQuery.textScaleFactor)
- Color contrast ratios AA compliant

### 9.6 Play Store Requirements
- App icon: 512x512 adaptive icon (foreground + background layers)
- Feature graphic: 1024x500 banner
- Screenshots: 6 minimum for Play Store listing
- Privacy policy URL in manifest
- Target SDK: API 34 (Android 14)
- INTERNET, ACCESS_FINE_LOCATION, CAMERA, READ_EXTERNAL_STORAGE permissions with rationale dialogs

---

## SECTION 10 — IMPLEMENTATION PRIORITY ORDER

Build in this exact order:
1. Folder structure + all model classes + theme system
2. GlassCard + GradientBackground + AppBottomNav shared widgets
3. Splash → Onboarding (Welcome, InterestSelector, Permissions)
4. Auth (Login/Register/Gate)
5. Home Screen (static mock data first)
6. Event Details Screen (Hero transition)
7. Explore Screen
8. Create Event Screen
9. Map Screen
10. Profile Screen
11. Badges Screen
12. Communities Screen
13. Inbox + Chat Screens
14. Notifications Screen
15. Settings Screen
16. Wire up Firebase (replace all mock data with Firestore)
17. Push notifications
18. Badge system logic
19. Polish animations, loading states, error states
20. Production hardening (analytics, crashlytics, performance)

---

## SECTION 11 — COLORS FILE BUG FIX

The existing `colors.dart` has a Dart syntax error on this line:
```dart
// BROKEN:
static const Color textMain = Color(0 street: 0xFF4A4A4A);

// FIXED (use new color names from SECTION 1):
static const Color textPrimary = Color(0xFF2D2D3A);
```
Delete the old colors.dart entirely and use the new AppColors from Section 1.

---

## SECTION 12 — FINAL REMINDERS FOR THE AI AGENT

1. **Never use StatefulWidget** unless it's purely for AnimationController
2. **Every color must come from AppColors** — no hardcoded hex values in widgets
3. **Every spacing value from AppSpacing** — no magic numbers
4. **Every text style from AppTextStyles** — no inline TextStyle declarations
5. **All assets referenced via AssetPaths constants** — no raw string paths
6. **All routes via RouteNames constants** — no raw string paths in context.go()
7. **All Firestore calls inside Repository implementations** — features only call usecases
8. **Production error handling everywhere** — no uncaught exceptions
9. **flutter_animate on every list/page** — entrance animations mandatory
10. **The UI must match the screenshots** — soft peach background, glassmorphic cards,
    neon glow on selected items, floating scattered bubbles on onboarding,
    gradient bottom nav bar always floating above content

---

*End of NicheSphere Master Prompt — v1.0*
