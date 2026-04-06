class SensitiveDataMasker {
  /// Replaces sensitive values like password, token, or nif with ***.
  static String mask(String input) {
    // Basic regex to find attributes in toString() representations
    // e.g., password: "my_secret", token: "xyz"
    final keysToMask = ['password', 'token', 'nif', 'secret', 'auth'];
    
    String masked = input;
    for (final key in keysToMask) {
      // Matches: key: value, key=value, "key":"value" etc.
      final regExp = RegExp('($key["\']?\\s*[:=]\\s*["\']?)([^\\s,"\']+)["\']?', caseSensitive: false);
      masked = masked.replaceAllMapped(regExp, (match) {
        return '${match.group(1)}***';
      });
    }
    return masked;
  }
}
