# NicheSphere — Phase 2: Backend & State Layer Prompt

> Paste this ENTIRE prompt into Claude Code (`claude` in terminal) to implement
> the full backend, Riverpod state layer, and replace all MockData with real Firebase.
> The UI layer (Phase 1) is already complete. Do NOT touch any screen or widget files.

---

## ROLE & MISSION

You are a senior Flutter/Firebase engineer. The NicheSphere app already has a
complete UI layer (all 20 screens, design system, routing). Your job is to wire
up the entire backend: Firebase Auth, Firestore repositories, Riverpod providers,
real-time state, and replace every `MockData` reference with live data.

**Touch only these layers:**
- `lib/core/` — services, config, DI providers, error types, router guards
- `lib/data/` — datasources, repository implementations
- `lib/domain/` — entities, abstract repo interfaces, use cases
- `lib/features/*/providers/` — ALL provider files
- `lib/main.dart` — Firebase init, Hive init, Crashlytics setup
- `android/app/src/main/AndroidManifest.xml` — permissions
- `ios/Runner/Info.plist` — permissions

**Do NOT modify** any file in `lib/features/*/screens/` or `lib/features/*/widgets/`
or `lib/shared/widgets/` — the UI is done.

---

## SECTION 1 — SETUP & INITIALIZATION

### 1.1 main.dart — Complete rewrite

```dart
// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/config/firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Crashlytics — catch all Flutter + platform errors
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Hive local cache
  await Hive.initFlutter();
  await Hive.openBox('settings');      // onboarding flag, theme prefs
  await Hive.openBox('events_cache'); // last 50 home feed events
  await Hive.openBox('user_cache');    // current user profile

  // System UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
  ));

  runApp(const ProviderScope(child: NicheSphereApp()));
}

class NicheSphereApp extends ConsumerWidget {
  const NicheSphereApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'NicheSphere',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
```

### 1.2 Run FlutterFire CLI

After writing code, run:
```bash
flutterfire configure
# This generates lib/core/config/firebase_options.dart
```

---

## SECTION 2 — ERROR TYPES

### 2.1 `lib/core/errors/failures.dart`

```dart
sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure    extends Failure { const NetworkFailure()    : super('Check your connection and try again.'); }
class NotFoundFailure   extends Failure { const NotFoundFailure()   : super('This item no longer exists.'); }
class AuthFailure       extends Failure { const AuthFailure(String msg) : super(msg); }
class PermissionFailure extends Failure { const PermissionFailure() : super('You don\'t have permission to do that.'); }
class StorageFailure    extends Failure { const StorageFailure()    : super('Failed to upload file. Try again.'); }
class ValidationFailure extends Failure { const ValidationFailure(String msg) : super(msg); }
class UnknownFailure    extends Failure { const UnknownFailure()    : super('Something went wrong. Please try again.'); }
```

### 2.2 `lib/core/errors/app_exception.dart`

```dart
class AppException implements Exception {
  final String message;
  final String? code;
  const AppException(this.message, {this.code});
}
```

### 2.3 `lib/core/errors/error_handler.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'failures.dart';

Failure handleException(Object e) {
  if (e is FirebaseAuthException) return AuthFailure(_authMessage(e.code));
  if (e is FirebaseException) {
    if (e.code == 'not-found')          return const NotFoundFailure();
    if (e.code == 'permission-denied')  return const PermissionFailure();
    return UnknownFailure();
  }
  if (e is FirebaseStorageException)    return const StorageFailure();
  return const UnknownFailure();
}

String _authMessage(String code) {
  return switch (code) {
    'user-not-found'       => 'No account found with this email.',
    'wrong-password'       => 'Incorrect password. Try again.',
    'email-already-in-use' => 'This email is already registered.',
    'weak-password'        => 'Password must be at least 6 characters.',
    'invalid-email'        => 'Please enter a valid email address.',
    'user-disabled'        => 'This account has been disabled.',
    'too-many-requests'    => 'Too many attempts. Try again later.',
    _                      => 'Authentication failed. Please try again.',
  };
}
```

---

## SECTION 3 — SERVICES

### 3.1 `lib/core/services/auth_service.dart`

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';
import '../errors/error_handler.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;

  Future<Either<Failure, User>> signInWithEmail(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password);
      return Right(cred.user!);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  Future<Either<Failure, User>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password);
      await cred.user!.updateDisplayName(name);
      return Right(cred.user!);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final googleUser = await _google.signIn();
      if (googleUser == null) return Left(const AuthFailure('Google sign-in cancelled.'));
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final cred = await _auth.signInWithCredential(credential);
      return Right(cred.user!);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  Future<Either<Failure, Unit>> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const Right(unit);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _google.signOut()]);
  }
}
```

### 3.2 `lib/core/services/location_service.dart`

```dart
import 'package:geolocator/geolocator.dart';
import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';

class LocationService {
  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return Left(const PermissionFailure());

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Left(const PermissionFailure());
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Left(const PermissionFailure());
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return Right(position);
    } catch (e) {
      return Left(const UnknownFailure());
    }
  }
}
```

### 3.3 `lib/core/services/storage_service.dart`

```dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  Future<Either<Failure, String>> uploadEventImage(File file) async {
    return _uploadImage(file, 'event_images');
  }

  Future<Either<Failure, String>> uploadAvatar(File file) async {
    return _uploadImage(file, 'avatars');
  }

  Future<Either<Failure, String>> _uploadImage(File file, String folder) async {
    try {
      // Compress before upload
      final compressed = await _compress(file);
      final fileName = '${_uuid.v4()}.jpg';
      final ref = _storage.ref().child('$folder/$fileName');
      await ref.putFile(compressed);
      final url = await ref.getDownloadURL();
      return Right(url);
    } catch (e) {
      return Left(const StorageFailure());
    }
  }

  Future<File> _compress(File file) async {
    final dir = await getTemporaryDirectory();
    final target = '${dir.path}/${_uuid.v4()}.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, target,
      quality: 75, minWidth: 1080, minHeight: 1080,
    );
    return result != null ? File(result.path) : file;
  }
}
```

### 3.4 `lib/core/services/notification_service.dart`

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    tz.initializeTimeZones();

    // Local notifications init
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _local.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    // FCM permissions
    await _fcm.requestPermission();

    // Handle foreground FCM messages
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        _showLocalNotification(
          title: message.notification!.title ?? 'NicheSphere',
          body:  message.notification!.body  ?? '',
        );
      }
    });
  }

  Future<String?> getFcmToken() => _fcm.getToken();

  Future<void> scheduleEventReminder({
    required int id,
    required String title,
    required DateTime eventTime,
  }) async {
    final reminderTime = tz.TZDateTime.from(
      eventTime.subtract(const Duration(hours: 24)),
      tz.local,
    );
    if (reminderTime.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _local.zonedSchedule(
      id, '🗓️ Tomorrow: $title',
      'Your event starts in 24 hours!',
      reminderTime,
      const NotificationDetails(
        android: AndroidNotificationDetails('reminders', 'Event Reminders',
          importance: Importance.high, priority: Priority.high),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelReminder(int id) => _local.cancel(id);

  Future<void> _showLocalNotification({required String title, required String body}) async {
    await _local.show(
      DateTime.now().millisecond, title, body,
      const NotificationDetails(
        android: AndroidNotificationDetails('general', 'General',
          importance: Importance.defaultImportance),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
```

### 3.5 `lib/core/services/analytics_service.dart`

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logScreenView(String screenName) =>
      _analytics.logScreenView(screenName: screenName);

  Future<void> logEventViewed(String eventId) =>
      _analytics.logEvent(name: 'event_viewed', parameters: {'event_id': eventId});

  Future<void> logEventRsvp(String eventId) =>
      _analytics.logEvent(name: 'event_rsvp', parameters: {'event_id': eventId});

  Future<void> logEventCreated(String category) =>
      _analytics.logEvent(name: 'event_created', parameters: {'category': category});

  Future<void> logCommunityJoined(String communityId) =>
      _analytics.logEvent(name: 'community_joined', parameters: {'community_id': communityId});

  Future<void> logSearch(String query) =>
      _analytics.logSearch(searchTerm: query);

  Future<void> logBadgeEarned(String badgeId) =>
      _analytics.logEvent(name: 'badge_earned', parameters: {'badge_id': badgeId});
}
```

---

## SECTION 4 — DOMAIN LAYER

### 4.1 Abstract Repository Interfaces

Create `lib/domain/repositories/event_repository.dart`:

```dart
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../entities/event.dart';

abstract interface class EventRepository {
  Stream<List<Event>> watchFeaturedEvents();
  Stream<List<Event>> watchNearbyEvents({required double lat, required double lng, String? category});
  Future<Either<Failure, Event>> getEventById(String id);
  Future<Either<Failure, List<Event>>> searchEvents(String query, {String? category});
  Future<Either<Failure, String>> createEvent(Event event);
  Future<Either<Failure, Unit>> rsvpEvent(String eventId);
  Future<Either<Failure, Unit>> cancelRsvp(String eventId);
  Future<Either<Failure, Unit>> saveEvent(String eventId);
  Future<Either<Failure, Unit>> unsaveEvent(String eventId);
  Stream<bool> watchIsRsvped(String eventId);
  Stream<bool> watchIsSaved(String eventId);
}
```

Create `lib/domain/repositories/user_repository.dart`:

```dart
abstract interface class UserRepository {
  Future<Either<Failure, Unit>> createUserDocument(UserModel user);
  Future<Either<Failure, UserModel>> getUserById(String id);
  Stream<UserModel?> watchCurrentUser();
  Future<Either<Failure, Unit>> updateUser(Map<String, dynamic> fields);
  Future<Either<Failure, Unit>> saveInterests(List<String> interests);
  Future<Either<Failure, Unit>> followUser(String targetUserId);
  Future<Either<Failure, Unit>> unfollowUser(String targetUserId);
  Stream<bool> watchIsFollowing(String targetUserId);
  Future<Either<Failure, bool>> isUsernameAvailable(String username);
}
```

Create `lib/domain/repositories/community_repository.dart`:

```dart
abstract interface class CommunityRepository {
  Stream<List<Community>> watchPopularCommunities();
  Stream<List<Community>> watchUserCommunities();
  Future<Either<Failure, Community>> getCommunityById(String id);
  Future<Either<Failure, Unit>> joinCommunity(String communityId);
  Future<Either<Failure, Unit>> leaveCommunity(String communityId);
  Stream<bool> watchIsMember(String communityId);
  Future<Either<Failure, String>> createCommunity(Community community);
}
```

Create `lib/domain/repositories/chat_repository.dart`:

```dart
abstract interface class ChatRepository {
  Stream<List<Message>> watchMessages(String chatRoomId);
  Future<Either<Failure, Unit>> sendMessage(String chatRoomId, String content);
  Future<Either<Failure, Unit>> sendImageMessage(String chatRoomId, File image);
  Future<Either<Failure, Unit>> addReaction(String chatRoomId, String messageId, String emoji);
  Future<Either<Failure, String>> getOrCreateEventChatRoom(String eventId);
  Stream<List<ChatRoom>> watchUserChatRooms();
}
```

### 4.2 Use Cases

Create one file per use case. Pattern for all:

```dart
// lib/domain/usecases/events/rsvp_event.dart
import 'package:fpdart/fpdart.dart';
import '../../repositories/event_repository.dart';
import '../../../core/errors/failures.dart';

class RsvpEvent {
  final EventRepository _repo;
  const RsvpEvent(this._repo);

  Future<Either<Failure, Unit>> call(String eventId) =>
      _repo.rsvpEvent(eventId);
}
```

Create use cases for:
- `GetNearbyEvents`, `GetFeaturedEvents`, `GetEventById`, `SearchEvents`, `CreateEvent`, `RsvpEvent`, `CancelRsvp`, `SaveEvent`
- `GetUserProfile`, `UpdateProfile`, `SaveInterests`, `FollowUser`, `UnfollowUser`
- `GetCommunities`, `JoinCommunity`, `LeaveCommunity`, `CreateCommunity`
- `SendMessage`, `GetChatMessages`

---

## SECTION 5 — DATA LAYER

### 5.1 `lib/data/datasources/remote/event_remote_ds.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/event_model.dart';

class EventRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<EventModel>> getFeaturedEvents() {
    return _db.collection('events')
        .where('isFeatured', isEqualTo: true)
        .where('status', isEqualTo: 'upcoming')
        .orderBy('startAt')
        .limit(10)
        .snapshots()
        .map((s) => s.docs.map((d) => EventModel.fromFirestore(d)).toList());
  }

  Stream<List<EventModel>> getNearbyEvents({
    required double lat,
    required double lng,
    String? category,
    int limitCount = 20,
  }) {
    // Use geohash prefix query for proximity
    // Install: geoflutterfire_plus for proper geospatial querying
    var query = _db.collection('events')
        .where('status', isEqualTo: 'upcoming')
        .orderBy('startAt')
        .limit(limitCount);
    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category) as Query<Map<String, dynamic>>;
    }
    return query.snapshots()
        .map((s) => s.docs.map((d) => EventModel.fromFirestore(d)).toList());
  }

  Future<EventModel?> getEventById(String id) async {
    final doc = await _db.collection('events').doc(id).get();
    if (!doc.exists) return null;
    return EventModel.fromFirestore(doc);
  }

  Future<List<EventModel>> searchEvents(String query, {String? category}) async {
    // Basic Firestore search (for full-text, integrate Algolia or Typesense)
    var q = _db.collection('events')
        .where('status', isEqualTo: 'upcoming')
        .orderBy('title')
        .startAt([query]).endAt(['$query\uf8ff'])
        .limit(20);
    final snapshot = await q.get();
    return snapshot.docs.map((d) => EventModel.fromFirestore(d)).toList();
  }

  Future<String> createEvent(EventModel event) async {
    final ref = _db.collection('events').doc();
    final model = event.copyWith(id: ref.id);
    await ref.set(model.toJson());
    return ref.id;
  }

  Future<void> rsvpEvent(String eventId, String userId) async {
    final batch = _db.batch();
    final rsvpRef = _db.collection('rsvps').doc('${userId}_$eventId');
    final eventRef = _db.collection('events').doc(eventId);

    batch.set(rsvpRef, {
      'id': '${userId}_$eventId',
      'userId': userId,
      'eventId': eventId,
      'status': 'attending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.update(eventRef, {
      'attendeeCount': FieldValue.increment(1),
    });
    await batch.commit();
  }

  Future<void> cancelRsvp(String eventId, String userId) async {
    final batch = _db.batch();
    final rsvpRef = _db.collection('rsvps').doc('${userId}_$eventId');
    final eventRef = _db.collection('events').doc(eventId);

    batch.delete(rsvpRef);
    batch.update(eventRef, {
      'attendeeCount': FieldValue.increment(-1),
    });
    await batch.commit();
  }

  Stream<bool> watchIsRsvped(String eventId, String userId) {
    return _db.collection('rsvps')
        .doc('${userId}_$eventId')
        .snapshots()
        .map((doc) => doc.exists && doc.data()?['status'] == 'attending');
  }
}

// Add fromFirestore to EventModel:
// factory EventModel.fromFirestore(DocumentSnapshot doc) {
//   final data = doc.data() as Map<String, dynamic>;
//   return EventModel.fromJson({...data, 'id': doc.id});
// }
```

### 5.2 `lib/data/datasources/remote/user_remote_ds.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';

class UserRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  Future<void> createUserDocument(UserModel user) async {
    await _db.collection('users').doc(user.id).set({
      ...user.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<UserModel?> getUserById(String id) async {
    final doc = await _db.collection('users').doc(id).get();
    if (!doc.exists) return null;
    return UserModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  Stream<UserModel?> watchCurrentUser() {
    return _db.collection('users').doc(_uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromJson({...doc.data()!, 'id': doc.id});
    });
  }

  Future<void> updateUser(Map<String, dynamic> fields) async {
    await _db.collection('users').doc(_uid).update({
      ...fields,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveInterests(List<String> interests) async {
    await _db.collection('users').doc(_uid).update({'interests': interests});
  }

  Future<void> followUser(String targetId) async {
    final batch = _db.batch();
    batch.set(
      _db.collection('follows').doc('${_uid}_$targetId'),
      {'followerId': _uid, 'followingId': targetId, 'createdAt': FieldValue.serverTimestamp()},
    );
    batch.update(_db.collection('users').doc(_uid),     {'followingCount': FieldValue.increment(1)});
    batch.update(_db.collection('users').doc(targetId), {'followersCount': FieldValue.increment(1)});
    await batch.commit();
  }

  Future<void> unfollowUser(String targetId) async {
    final batch = _db.batch();
    batch.delete(_db.collection('follows').doc('${_uid}_$targetId'));
    batch.update(_db.collection('users').doc(_uid),     {'followingCount': FieldValue.increment(-1)});
    batch.update(_db.collection('users').doc(targetId), {'followersCount': FieldValue.increment(-1)});
    await batch.commit();
  }

  Stream<bool> watchIsFollowing(String targetId) {
    return _db.collection('follows').doc('${_uid}_$targetId')
        .snapshots().map((doc) => doc.exists);
  }

  Future<bool> isUsernameAvailable(String username) async {
    final q = await _db.collection('users')
        .where('username', isEqualTo: username.toLowerCase()).limit(1).get();
    return q.docs.isEmpty;
  }
}
```

### 5.3 Repository Implementations

Create `lib/data/repositories/event_repository_impl.dart`:

```dart
import 'package:fpdart/fpdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/errors/error_handler.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/remote/event_remote_ds.dart';
import '../datasources/local/event_local_ds.dart';
import '../models/event_model.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource _remote;
  final EventLocalDataSource  _local;
  final FirebaseAuth          _auth;

  const EventRepositoryImpl(this._remote, this._local, this._auth);

  String get _uid => _auth.currentUser!.uid;

  @override
  Stream<List<EventModel>> watchFeaturedEvents() {
    return _remote.getFeaturedEvents().handleError((_) => <EventModel>[]);
  }

  @override
  Future<Either<Failure, EventModel>> getEventById(String id) async {
    try {
      final event = await _remote.getEventById(id);
      if (event == null) return const Left(NotFoundFailure());
      return Right(event);
    } catch (e) { return Left(handleException(e)); }
  }

  @override
  Future<Either<Failure, Unit>> rsvpEvent(String eventId) async {
    try {
      await _remote.rsvpEvent(eventId, _uid);
      return const Right(unit);
    } catch (e) { return Left(handleException(e)); }
  }

  @override
  Future<Either<Failure, Unit>> cancelRsvp(String eventId) async {
    try {
      await _remote.cancelRsvp(eventId, _uid);
      return const Right(unit);
    } catch (e) { return Left(handleException(e)); }
  }

  @override
  Stream<bool> watchIsRsvped(String eventId) =>
      _remote.watchIsRsvped(eventId, _uid);

  @override
  Future<Either<Failure, String>> createEvent(EventModel event) async {
    try {
      final id = await _remote.createEvent(event.copyWith(organizerId: _uid));
      return Right(id);
    } catch (e) { return Left(handleException(e)); }
  }

  // Implement remaining methods similarly...
  @override Stream<List<EventModel>> watchNearbyEvents({required double lat, required double lng, String? category}) =>
      _remote.getNearbyEvents(lat: lat, lng: lng, category: category);

  @override Future<Either<Failure, List<EventModel>>> searchEvents(String query, {String? category}) async {
    try {
      final results = await _remote.searchEvents(query, category: category);
      return Right(results);
    } catch (e) { return Left(handleException(e)); }
  }

  @override Future<Either<Failure, Unit>> saveEvent(String eventId) async => const Right(unit); // TODO
  @override Future<Either<Failure, Unit>> unsaveEvent(String eventId) async => const Right(unit); // TODO
  @override Stream<bool> watchIsSaved(String eventId) => Stream.value(false); // TODO
}
```

Create `lib/data/repositories/user_repository_impl.dart` similarly, wrapping `UserRemoteDataSource`.

---

## SECTION 6 — DEPENDENCY INJECTION

### 6.1 `lib/core/di/providers.dart`

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/auth_service.dart';
import '../services/analytics_service.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../../data/datasources/remote/event_remote_ds.dart';
import '../../data/datasources/remote/user_remote_ds.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/event_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/events/rsvp_event.dart';
import '../../domain/usecases/events/get_nearby_events.dart';
// ... import all use cases

part 'providers.g.dart';

// ── Services ────────────────────────────────────────
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final analyticsServiceProvider = Provider<AnalyticsService>((ref) => AnalyticsService());
final locationServiceProvider = Provider<LocationService>((ref) => LocationService());
final storageServiceProvider = Provider<StorageService>((ref) => StorageService());
final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

// ── Firebase Auth stream ─────────────────────────────
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// ── Datasources ──────────────────────────────────────
final eventRemoteDsProvider = Provider<EventRemoteDataSource>((ref) => EventRemoteDataSource());
final userRemoteDsProvider   = Provider<UserRemoteDataSource>((ref) => UserRemoteDataSource());

// ── Repositories ─────────────────────────────────────
final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepositoryImpl(
    ref.watch(eventRemoteDsProvider),
    EventLocalDataSource(),   // Hive
    FirebaseAuth.instance,
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    ref.watch(userRemoteDsProvider),
    FirebaseAuth.instance,
  );
});

// ── Use Cases ────────────────────────────────────────
final rsvpEventProvider = Provider<RsvpEvent>((ref) =>
    RsvpEvent(ref.watch(eventRepositoryProvider)));

final getNearbyEventsProvider = Provider<GetNearbyEvents>((ref) =>
    GetNearbyEvents(ref.watch(eventRepositoryProvider)));

// ... one provider per use case
```

---

## SECTION 7 — FEATURE PROVIDERS

### 7.1 `lib/features/auth/providers/auth_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/di/providers.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<void> build() async {}

  Future<String?> signIn(String email, String password) async {
    state = const AsyncLoading();
    final result = await ref.read(authServiceProvider).signInWithEmail(email, password);
    return result.fold(
      (failure) { state = AsyncError(failure.message, StackTrace.current); return failure.message; },
      (user)    { state = const AsyncData(null); return null; },
    );
  }

  Future<String?> register({required String email, required String password, required String name}) async {
    state = const AsyncLoading();
    final authResult = await ref.read(authServiceProvider).registerWithEmail(
      email: email, password: password, name: name);
    return authResult.fold(
      (failure) { state = AsyncError(failure.message, StackTrace.current); return failure.message; },
      (user) async {
        // Create Firestore user document
        final userRepo = ref.read(userRepositoryProvider);
        await userRepo.createUserDocument(UserModel(
          id: user.uid, name: name, username: email.split('@').first.toLowerCase(),
          email: email, createdAt: DateTime.now(),
        ));
        state = const AsyncData(null);
        return null;
      },
    );
  }

  Future<String?> signInWithGoogle() async {
    state = const AsyncLoading();
    final result = await ref.read(authServiceProvider).signInWithGoogle();
    return result.fold(
      (f) { state = AsyncError(f.message, StackTrace.current); return f.message; },
      (_) { state = const AsyncData(null); return null; },
    );
  }

  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
    Hive.box('settings').delete('onboarding_complete');
  }
}
```

### 7.2 `lib/features/onboarding/providers/onboarding_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/di/providers.dart';

part 'onboarding_provider.g.dart';

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  Set<String> build() => {};

  void toggle(String interest) {
    state = state.contains(interest)
        ? {...state}..remove(interest)
        : {...state, interest};
  }

  Future<bool> completeOnboarding() async {
    if (state.length < 3) return false;
    final repo = ref.read(userRepositoryProvider);
    final result = await repo.saveInterests(state.toList());
    return result.fold((_) => false, (_) {
      Hive.box('settings').put('onboarding_complete', true);
      Hive.box('settings').put('interests', state.toList());
      return true;
    });
  }
}
```

### 7.3 `lib/features/home/providers/home_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/di/providers.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/community_model.dart';

part 'home_provider.g.dart';

// Featured events — real-time stream
@riverpod
Stream<List<EventModel>> featuredEvents(FeaturedEventsRef ref) {
  return ref.watch(eventRepositoryProvider).watchFeaturedEvents();
}

// Nearby events — real-time stream filtered by user location
@riverpod
Stream<List<EventModel>> nearbyEvents(NearbyEventsRef ref) {
  final location = ref.watch(userLocationProvider);
  return location.when(
    data: (pos) => ref.watch(eventRepositoryProvider).watchNearbyEvents(
      lat: pos.latitude, lng: pos.longitude),
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
}

// User location
@riverpod
Future<Position> userLocation(UserLocationRef ref) async {
  final result = await ref.watch(locationServiceProvider).getCurrentLocation();
  return result.fold(
    (_) => throw Exception('Location unavailable'),
    (pos) => pos,
  );
}

// Selected category filter
@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() => 'All';
  void select(String category) => state = category;
}
```

### 7.4 `lib/features/event_details/providers/event_details_provider.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/di/providers.dart';
import '../../../data/models/event_model.dart';

part 'event_details_provider.g.dart';

@riverpod
Future<EventModel> eventDetails(EventDetailsRef ref, String eventId) async {
  final result = await ref.watch(eventRepositoryProvider).getEventById(eventId);
  return result.fold((f) => throw f.message, (e) => e);
}

@riverpod
Stream<bool> isRsvped(IsRsvpedRef ref, String eventId) {
  return ref.watch(eventRepositoryProvider).watchIsRsvped(eventId);
}

@riverpod
class RsvpNotifier extends _$RsvpNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> rsvp(String eventId) async {
    state = const AsyncLoading();
    final result = await ref.read(eventRepositoryProvider).rsvpEvent(eventId);
    state = result.fold(
      (f) => AsyncError(f.message, StackTrace.current),
      (_) => const AsyncData(null),
    );
    // Schedule reminder notification
    // ...
  }

  Future<void> cancel(String eventId) async {
    state = const AsyncLoading();
    final result = await ref.read(eventRepositoryProvider).cancelRsvp(eventId);
    state = result.fold(
      (f) => AsyncError(f.message, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}
```

### 7.5 Create providers for ALL remaining features:

- `lib/features/explore/providers/explore_provider.dart` — searchQuery state + search results stream
- `lib/features/create_event/providers/create_event_provider.dart` — multi-step form state + submit
- `lib/features/communities/providers/communities_provider.dart` — community list stream + join notifier
- `lib/features/profile/providers/profile_provider.dart` — user stream + follow notifier
- `lib/features/chat/providers/chat_provider.dart` — message stream + send notifier
- `lib/features/notifications/providers/notifications_provider.dart` — notifications stream
- `lib/features/settings/providers/settings_provider.dart` — update profile, sign out, delete account

---

## SECTION 8 — CONNECT PROVIDERS TO SCREENS

For each screen, replace MockData references with `ref.watch()`:

### Home Screen update pattern:

```dart
// BEFORE (MockData):
final mockEvents = MockData.featuredEvents;

// AFTER (real Riverpod):
final featuredAsync = ref.watch(featuredEventsProvider);
featuredAsync.when(
  data:    (events) => _buildFeaturedCarousel(events),
  loading: () => const ShimmerCardList(),
  error:   (e, _)  => ErrorState(message: e.toString(),
    onRetry: () => ref.invalidate(featuredEventsProvider)),
)
```

### Event Details update pattern:

```dart
// BEFORE:
final event = MockData.featuredEvents.first;

// AFTER:
final eventAsync = ref.watch(eventDetailsProvider(eventId));
final isRsvped   = ref.watch(isRsvpedProvider(eventId));
```

### Login Screen update pattern:

```dart
// BEFORE:
onTap: () => context.go(RouteNames.home)

// AFTER:
onTap: () async {
  final error = await ref.read(authNotifierProvider.notifier)
      .signIn(_emailController.text, _passwordController.text);
  if (error != null) {
    AppSnackbar.show(context, message: error, type: SnackbarType.error);
  } else {
    context.go(RouteNames.home);
  }
}
```

---

## SECTION 9 — ROUTER GUARDS

Update `lib/core/router/app_router.dart` to add auth redirect:

```dart
static final GoRouter router = GoRouter(
  initialLocation: RouteNames.splash,
  redirect: (context, state) {
    final authState = ProviderScope.containerOf(context)
        .read(authStateProvider);
    final isLoggedIn = authState.value != null;
    final isOnboarded = Hive.box('settings')
        .get('onboarding_complete', defaultValue: false) as bool;

    final goingToAuth = state.matchedLocation.startsWith('/login') ||
        state.matchedLocation.startsWith('/register') ||
        state.matchedLocation.startsWith('/welcome') ||
        state.matchedLocation.startsWith('/interests');

    if (!isLoggedIn && !goingToAuth) return RouteNames.welcome;
    if (isLoggedIn && !isOnboarded && !goingToAuth) return RouteNames.welcome;
    if (isLoggedIn && goingToAuth) return RouteNames.home;
    return null;
  },
  routes: [ /* existing routes unchanged */ ],
);
```

---

## SECTION 10 — ANDROID & iOS CONFIGURATION

### Android `AndroidManifest.xml` — add inside `<manifest>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

<!-- Inside <application>: -->
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="${GOOGLE_MAPS_API_KEY}"/>
```

### iOS `Info.plist` — add inside `<dict>`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>NicheSphere uses your location to show events near you.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>NicheSphere uses your location to show events near you.</string>
<key>NSCameraUsageDescription</key>
<string>Used to take photos for your profile and events.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to upload photos for your profile and events.</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Used to save event photos.</string>
```

---

## SECTION 11 — CODE GENERATION

After writing all providers, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates `.g.dart` files for:
- All `@riverpod` providers
- Hive type adapters
- JSON serialization

If you see errors, run:
```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

---

## SECTION 12 — FINAL CHECKLIST BEFORE CALLING THIS DONE

- [ ] `flutter analyze` returns zero errors and zero warnings
- [ ] `flutter test` runs without failures  
- [ ] App launches on Android emulator from cold start
- [ ] Splash → onboarding → auth → home flow works end to end
- [ ] RSVP on an event increments attendeeCount in Firestore
- [ ] Profile shows real user data from Firestore
- [ ] Selecting interests saves to Firestore user document
- [ ] Sign out clears session and redirects to welcome
- [ ] No `MockData` references remain in any feature screen
- [ ] No `setState` in any file except animation-only widgets
- [ ] Every loading state shows shimmer, every error shows ErrorState with retry

---

*End of NicheSphere Phase 2 Prompt — v1.0*
