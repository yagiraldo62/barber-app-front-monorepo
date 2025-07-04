import 'package:flutter/foundation.dart';

class Log {
  Log(dynamic message, [List<dynamic> otherMessages = const []]) {
    if (kDebugMode) {
      for (final dynamic message in [message, ...otherMessages]) {
        print(message);
      }
    }
  }
}
