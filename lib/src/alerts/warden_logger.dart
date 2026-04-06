import 'dart:developer' as developer;
import 'sensitive_data_masker.dart';

class WardenLogger {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';

  static void logViolation(String rawMessage) {
    final maskedMessage = SensitiveDataMasker.mask(rawMessage);
    final border = '=========================================';
    final output = '\n$_red$border\n$maskedMessage\n$border$_reset\n';
    developer.log(output, name: 'CleanWarden');
    // Also print to ensure it's visible in all consoles
    print(output);
  }

  static void logWarning(String rawMessage) {
    final maskedMessage = SensitiveDataMasker.mask(rawMessage);
    final output = '$_yellow$maskedMessage$_reset';
    developer.log(output, name: 'CleanWarden');
    print(output);
  }
}
