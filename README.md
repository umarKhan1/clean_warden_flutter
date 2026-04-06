# Clean Warden Flutter

![Pub Version](https://img.shields.io/pub/v/clean_warden_flutter)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

A strict, powerful, and automated architectural boundary enforcement tool for Flutter projects utilizing Clean Architecture.

This package acts as an automated runtime "Warden." It deeply scans data flows moving through your state management tools and instantly flags architectural violations, ensuring that your Presentation layer never depends on Data models, and your Domain layer remains free of external dependencies.

## Why This Package is Important

As a project scales, architectural erosion is inevitable. Junior developers or rushed timelines often lead to shortcuts, such as passing a `UserModel` (Data Layer) directly to a Widget (Presentation Layer) or processing a `NetworkResponse` directly inside a Use Case or Entity (Domain Layer). 

Simple code reviews are not scalable for catching every leak. Clean Warden automates this supervision. By intercepting data flows at runtime, the package creates a fail-safe that loudly alerts developers the exact moment an architectural boundary is breached. It acts as an automated Senior Architect sitting alongside every developer on your team.

## Core Features

- **Strict Boundary Rules:** Automatically triggers violations if structural boundaries are broken.
- **State Management Native:** Seamlessly ties into `flutter_bloc` and `flutter_riverpod` respectively.
- **In-App SnackBar Alerter:** Optional floating UI alerts that display violations instantly on-screen without requiring the terminal.
- **High-Visibility Formatting:** Terminal warnings utilize ANSI color codes with highly visible separation borders alongside useful "Suggested Fixes".
- **Sensitive Data Masking:** Hardcoded protections mask attributes like `password`, `token`, and `nif` out of the raw error payloads to secure your users' information in the logs.
- **Reflection-free:** Zero reliance on `dart:mirrors`, meaning it works flawlessly and performantly on Flutter Web, iOS, and Android.

---

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  clean_warden_flutter: ^1.0.0
```

---

## Getting Started

### 1. The Identity System (WardenMember)

For the Warden to track your architecture, your state management classes need to declare which layer they belong to. You do this by mixing in `WardenMember`.

```dart
import 'package:clean_warden_flutter/clean_warden_flutter.dart';

// By mixing in WardenMember, we tell the engine this is a UI component.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> with WardenMember {
  
  @override
  WardenLayer get layer => WardenLayer.presentation;

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) {
      // Logic goes here
    });
  }
}
```

Available tracking layers include:
- `WardenLayer.presentation`
- `WardenLayer.domain`
- `WardenLayer.data`
- `WardenLayer.infrastructure`

### 2. Configuration and Observers

Launch the engine in your `main.dart` file and configure it to your strictness preference. You must also supply the observers to your respective state management tool.

**For BLoC:**

```dart
import 'package:clean_warden_flutter/clean_warden_flutter.dart';

void main() {
  // Configure the engine
  WardenConfig.setup(const WardenConfig(
    mode: LogMode.logOnly, // Options: logOnly, strictCrash
    enableInAppAlerts: true,
  ));

  // Connect the observer seamlessly to BLoC
  Bloc.observer = WardenBlocObserver();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Pass the messenger key so SnackBar alerts can trigger globally
      scaffoldMessengerKey: WardenConfig.messengerKey,
      home: const HomeScreen(),
    );
  }
}
```

**For Riverpod:**

```dart
void main() {
  WardenConfig.setup(const WardenConfig(mode: LogMode.strictCrash));

  runApp(
    ProviderScope(
      observers: [WardenProviderObserver()],
      child: const MyApp(),
    )
  );
}
```

---

## How it Works & What Errors Look Like

Under the hood, `clean_warden_flutter` utilizes strict `runtimeType.toString()` checks on the states emitted by your application. 

### Rule 1: The Presentation Leak

Your Presentation Layer (Widgets, UI State) should only interact with Domain Entities or local UI Models. It should never interact with Data Models or Data Transfer Objects (DTOs).

If a class marked with `WardenLayer.presentation` emits an object containing the word "Model" or "Dto", the Warden intercepts it.

If a developer writes:
```dart
emit(UserModel(id: 1, name: "John"));
```

**The user will see the following terminal error:**
```text
=========================================
ARCHITECTURAL VIOLATION DETECTED!
Location: ProfileBloc (Layer: presentation)
Offending Data: UserModel
Rule Broken: Presentation Logic should interact with Domain Entities, not Data Models.
Suggested Fix: Did you forget to use a Mapper in the Domain Layer? Map your Data Models to Domain Entities or Presentation UI Models before passing them to the UI.
=========================================
```

### Rule 2: The Domain Leak

Your Domain core is the heart of Clean Architecture and must not depend on anything. It should never process HTTP Requests or API Responses directly.

If a class marked with `WardenLayer.domain` works with an object containing "Response", "Request", "Model", or "Dto", the Warden intercepts it.

**The user will see the following terminal error:**
```text
=========================================
ARCHITECTURAL VIOLATION DETECTED!
Location: FetchUserUseCase (Layer: domain)
Offending Data: LoginResponse
Rule Broken: Domain layer must be completely independent of Data representations (Models/Responses).
Suggested Fix: Domain layer should only communicate via abstractions (Contracts/Repositories) and Entities. Move the Reponses and Models out to the Data layer and map them.
=========================================
```

---

## Advanced Configurations

### Safe Logging vs Strict Enforcements

Through `WardenConfig`, the architecture's strictness can be toggled via `LogMode`.

- **`LogMode.logOnly`**: Recommended for initial adoption or production environments. The engine cleanly formats the violation in the terminal or SnackBar but allows the code to execute normally without interrupting the user.
- **`LogMode.strictCrash`**: Recommended for development and QA builds. If an architectural violation occurs, an unhandled `WardenViolationException` is immediately thrown, intentionally crashing the app to force developers to fix the mapping layer before committing their code.

### In-App Alerter

If `enableInAppAlerts: true` is passed to the configuration and the `WardenConfig.messengerKey` is attached to your `MaterialApp`, a prominent UI SnackBar will drop down from the top of the user's screen reading:

`Clean Warden Alert: PRESENTATION improperly received UserModel` 

This enables developers and QA testers to physically see the architectural leaks directly on a test device without monitoring the terminal.

### Sensitive Data Masking

Error logs inherently print string representations of objects. If an object payload contains security keys, Clean Warden intercepts the string and automatically masks it.

If a rejected payload has `password: "secretCode123"` inside its parameters, the console output will scrub it to read: `password: ***`. Supported automatic masked keys include: `password`, `token`, `auth`, `secret`, and `nif`.
