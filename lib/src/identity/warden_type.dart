/// Utility to introspect object types using strict string matching to avoid dart:mirrors.
class WardenType {
  /// Extracts the simple class name of the given data.
  static String extractName(Object? data) {
    if (data == null) return 'Null';
    return data.runtimeType.toString();
  }

  /// Checks if the data type name indicates it is a Data layer Model.
  static bool isModel(Object? data) {
    final name = extractName(data);
    return name.contains('Model') ||
        name.contains('Dto') ||
        name.contains('Response') ||
        name.contains('Request');
  }

  /// Checks if the data type name indicates it is a Domain layer Entity.
  static bool isEntity(Object? data) {
    final name = extractName(data);
    return name.contains('Entity');
  }
}
