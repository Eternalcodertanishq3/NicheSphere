/// NicheSphere — App Exception (Phase 2)
class AppException implements Exception {
  final String message;
  final String? code;
  const AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message (code: $code)';
}
