// NicheSphere — Auth Service (Phase 2)
// Wraps FirebaseAuth + Google Sign-In with Either<Failure, T> returns.
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';
import '../errors/error_handler.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;

  Future<Either<Failure, User>> signInWithEmail(
      String email, String password) async {
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
    return const Left(AuthFailure('Google sign-in is temporarily disabled.'));
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
    await _auth.signOut();
  }
}
