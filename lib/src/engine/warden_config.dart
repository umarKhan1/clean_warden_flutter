import 'package:flutter/material.dart';

/// Controls how strict the WardenEngine should be when encountering an architectural violation.
enum LogMode {
  /// Only logs the violation to the terminal (useful for gradual adoption).
  logOnly,

  /// Throws a [WardenViolationException] to crash the app (useful for strict enforcement).
  strictCrash,
}

/// Configuration for the Clean Warden engine.
class WardenConfig {
  /// The global logging mode. Defaults to [LogMode.logOnly].
  final LogMode mode;

  /// Specific features to observe. If empty, observes all features.
  final List<String> allowedFeatures;

  /// Specific layers to bypass.
  final List<dynamic>
  ignoredLayers; // Cannot import WardenLayer easily if not passed, but we assume using strings or dynamic if lazy. Actually, we should just import it.

  /// Triggers a sleek in-app SnackBar when violations occur. Requires passing `WardenConfig.messengerKey` to MaterialApp.
  final bool enableInAppAlerts;

  const WardenConfig({
    this.mode = LogMode.logOnly,
    this.allowedFeatures = const [],
    this.ignoredLayers = const [],
    this.enableInAppAlerts = false,
  });

  /// The default global configuration.
  static WardenConfig current = const WardenConfig();

  /// Global key to be passed into `MaterialApp(scaffoldMessengerKey: ...)`
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Updates the global configuration.
  static void setup(WardenConfig config) {
    current = config;
  }
}
