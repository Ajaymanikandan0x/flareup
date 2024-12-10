
class Logger {
  static void debug(String message) {
    print('[DEBUG] $message');
  }

  static void error(String message, dynamic error, [StackTrace? stackTrace]) {
    print('[ERROR] $message');
    print('Error details: ${error.toString()}');
    if (stackTrace != null) {
      print('Stack trace: $stackTrace');
    }
  }
}