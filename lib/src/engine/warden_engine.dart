import '../identity/layer_enums.dart';
import '../identity/warden_member.dart';
import '../identity/warden_type.dart';
import 'warden_config.dart';
import '../alerts/warden_logger.dart';
import '../alerts/warden_suggestions.dart';
import '../alerts/in_app_alerter.dart';

/// Exception thrown when strict mode is enabled and a violation occurs.
class WardenViolationException implements Exception {
  final String message;
  WardenViolationException(this.message);
  
  @override
  String toString() => 'WardenViolationException: $message';
}

/// The core validation engine that checks data boundaries.
class WardenEngine {
  /// Evaluates whether passing [data] to [target] violates Clean Architecture rules.
  static void check(WardenMember target, Object? data) {
    if (data == null) return;
    
    final config = WardenConfig.current;

    // Feature filtering
    if (config.allowedFeatures.isNotEmpty && target.featureName != null) {
      if (!config.allowedFeatures.contains(target.featureName)) {
        return;
      }
    }

    // Layer ignoring
    if (config.ignoredLayers.contains(target.layer)) {
      return;
    }

    final dataName = WardenType.extractName(data);

    // Rule 1: Presentation layer shouldn't handle Models/DTOs (Data Layer concepts) directly.
    if (target.layer == WardenLayer.presentation) {
      if (dataName.contains('Model') || dataName.contains('Dto')) {
        _triggerViolation(
          target: target,
          dataName: dataName,
          rule: 'Presentation Logic should interact with Domain Entities, not Data Models.',
          suggestion: WardenSuggestions.forPresentationModel(),
        );
      }
    }

    // Rule 2: Domain layer shouldn't know about requests or responses directly.
    if (target.layer == WardenLayer.domain) {
      if (dataName.contains('Response') || dataName.contains('Request') || dataName.contains('Model') || dataName.contains('Dto')) {
         _triggerViolation(
          target: target,
          dataName: dataName,
          rule: 'Domain layer must be completely independent of Data representations (Models/Responses).',
          suggestion: WardenSuggestions.forDomainData(),
        );
      }
    }
  }

  static void _triggerViolation({
    required WardenMember target,
    required String dataName,
    required String rule,
    required String suggestion,
  }) {
    final message = '''
ARCHITECTURAL VIOLATION DETECTED!
Location: ${target.runtimeType} (Layer: ${target.layer.name})
Offending Data: $dataName
Rule Broken: $rule
Suggested Fix: $suggestion
''';

    WardenLogger.logViolation(message);

    if (WardenConfig.current.enableInAppAlerts) {
      InAppAlerter.show(target.layer.name, dataName, rule);
    }

    if (WardenConfig.current.mode == LogMode.strictCrash) {
      throw WardenViolationException(message);
    }
  }
}
