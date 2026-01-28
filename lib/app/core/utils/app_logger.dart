import 'package:logger/logger.dart';

class AppLogger {
  // ===================>>Singleton<<===================
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 3,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static Logger get instance => _logger;

  // ===================>> Custom line by line logger <<===================
  static void _logLineByLine(void Function(dynamic) logFn, String message) {
    for (final line in message.split('\n')) {
      if (line.trim().isNotEmpty) {
        logFn(line);
      }
    }
  }

  static void i(String message) => _logLineByLine(_logger.i, message);
  static void w(String message) => _logLineByLine(_logger.w, message);
  static void d(String message) => _logLineByLine(_logger.d, message);

  static void e(String message, {dynamic error, StackTrace? stackTrace}) {
    for (final line in message.split('\n')) {
      if (line.trim().isNotEmpty) {
        _logger.e(line, error: error, stackTrace: stackTrace);
      }
    }
  }
}