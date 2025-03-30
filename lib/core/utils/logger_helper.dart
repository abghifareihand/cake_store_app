import 'package:logger/logger.dart';

class LoggerHelper {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 3,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  static String _getYellowText(String text) {
    return '\x1B[33m$text\x1B[0m'; // Kode ANSI untuk warna kuning
  }

  static void logInfo(String message) {
    _logger.i(_getYellowText(message));
  }

  static void logError(String message) {
    _logger.e(message);
  }

  static void logDebug(String message) {
    _logger.d(message);
  }

  static void logRequest(String url, Map<String, String> headers, String body) {
    _logger.i(_getYellowText('Request URL: $url'));
    _logger.i(_getYellowText('Request Headers: $headers'));
    _logger.i(_getYellowText('Request Body: $body'));
  }

  static void logResponse(int statusCode, String response) {
    _logger.i(_getYellowText('Response Status Code: $statusCode'));
    _logger.i(_getYellowText('Response Body: $response'));
  }
}
