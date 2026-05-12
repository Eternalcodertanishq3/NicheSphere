/// NicheSphere — Failure Types (Phase 2)
/// Sealed class hierarchy for typed error handling via fpdart Either.
sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('Check your connection and try again.');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure() : super('This item no longer exists.');
}

class AuthFailure extends Failure {
  const AuthFailure(super.msg);
}

class PermissionFailure extends Failure {
  const PermissionFailure()
      : super('You don\'t have permission to do that.');
}

class StorageFailure extends Failure {
  const StorageFailure() : super('Failed to upload file. Try again.');
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.msg);
}

class UnknownFailure extends Failure {
  const UnknownFailure()
      : super('Something went wrong. Please try again.');
}
