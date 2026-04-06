import 'package:flutter/material.dart';
import '../engine/warden_config.dart';

/// Renders a non-intrusive floating snackbar when architectural violations occur.
class InAppAlerter {
  static void show(String layerName, String dataName, String rule) {
    // Attempt to retrieve the globally provided messenger key
    final messenger = WardenConfig.messengerKey.currentState;
    if (messenger == null) return;

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.gavel_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Clean Warden Alert',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${layerName.toUpperCase()} improperly received $dataName',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              rule,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
