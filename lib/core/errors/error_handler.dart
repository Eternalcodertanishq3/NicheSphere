/// NicheSphere — Error Handler (Phase 2)
/// Maps Firebase exceptions to typed Failure objects.
library;


import 'package:firebase_auth/firebase_auth.dart';
import 'failures.dart';

Failure handleException(Object e) {
  if (e is FirebaseAuthException) return AuthFailure(_authMessage(e.code));
  if (e is FirebaseException) {
    if (e.code == 'not-found') return const NotFoundFailure();
    if (e.code == 'permission-denied') return const PermissionFailure();
    return const UnknownFailure();
  }
  return const UnknownFailure();
}

String _authMessage(String code) {
  return switch (code) {
    'user-not-found' => 'No account found with this email.',
    'wrong-password' => 'Incorrect password. Try again.',
    'email-already-in-use' => 'This email is already registered.',
    'weak-password' => 'Password must be at least 6 characters.',
    'invalid-email' => 'Please enter a valid email address.',
    'user-disabled' => 'This account has been disabled.',
    'too-many-requests' => 'Too many attempts. Try again later.',
    _ => 'Authentication failed. Please try again.',
  };
}
