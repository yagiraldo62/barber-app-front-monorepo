class InvalidAuthTokenException implements Exception {
  final String token;
  String? message;

  InvalidAuthTokenException(this.token, [this.message]);

  @override
  String toString() {
    if (message != null) return 'InvalidAuthTokenException: $message [$token]';

    return 'InvalidAuthTokenException: The supplied token is invalid [$token]';
  }
}
