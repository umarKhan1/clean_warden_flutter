import 'layer_enums.dart';

/// Mixin that assigns an architectural identity to a class.
///
/// Classes (like BLoCs, Repositories, UseCases) must implement this to be scanned by the [WardenEngine].
mixin WardenMember {
  /// The Clean Architecture layer this class belongs to.
  WardenLayer get layer;

  /// Optional feature name for granular filtering and logging.
  String? get featureName => null;
}
