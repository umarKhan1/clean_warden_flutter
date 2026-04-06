import 'package:flutter/material.dart';
import 'package:clean_warden_flutter/clean_warden_flutter.dart';

// --- Domain ---
class UserEntity {}

// --- Data ---
class UserModel {}
class UserResponse {}

// --- Presentation Components ---
class CleanPresentationComponent with WardenMember {
  @override
  WardenLayer get layer => WardenLayer.presentation;

  void triggerCleanFlow() {
    debugPrint('Sending UserEntity to Presentation Layer');
    WardenEngine.check(this, UserEntity());
  }
}

class BadPresentationComponent with WardenMember {
  @override
  WardenLayer get layer => WardenLayer.presentation;

  void triggerBadFlow() {
    debugPrint('Sending UserModel to Presentation Layer');
    WardenEngine.check(this, UserModel()); // Rule 1 violation!
  }
}

class BadDomainComponent with WardenMember {
  @override
  WardenLayer get layer => WardenLayer.domain;

  void triggerBadFlow() {
    debugPrint('Sending UserResponse to Domain Layer');
    WardenEngine.check(this, UserResponse()); // Rule 2 violation!
  }
}

void main() {
  // Set up the Warden to log warnings without crashing the app, and enable the SnackBar!
  WardenConfig.setup(const WardenConfig(
    mode: LogMode.logOnly,
    enableInAppAlerts: true,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: WardenConfig.messengerKey,
      home: Scaffold(
        appBar: AppBar(title: const Text('Clean Warden Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => CleanPresentationComponent().triggerCleanFlow(),
                child: const Text('Clean Presentation Flow (OK)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => BadPresentationComponent().triggerBadFlow(),
                child: const Text('Bad Presentation Flow (LOG)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => BadDomainComponent().triggerBadFlow(),
                child: const Text('Bad Domain Flow (LOG)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
