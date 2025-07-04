import 'package:base/exceptions/auth.exception.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

bool isValidJWT(String? token) {
  try {
    if (token == null || token.isEmpty) {
      return false;
    }

    InvalidAuthTokenException? error;

    // Regular expression to validate a JWT token
    RegExp jwtRegex = RegExp(
      r'^[A-Za-z0-9-_=]+\.[A-Za-z0-9-_=]+\.[A-Za-z0-9-_.+/=]*$',
    );

    // Check if the token matches the regex pattern
    if (!jwtRegex.hasMatch(token)) {
      error = InvalidAuthTokenException(token);
    }

    // Check if the token is expired
    bool isExpired = JwtDecoder.isExpired(token);

    if (isExpired) {
      error = InvalidAuthTokenException(token, "Token expired");
    }

    if (error != null) {
      print(error);
      return false;
    }

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
