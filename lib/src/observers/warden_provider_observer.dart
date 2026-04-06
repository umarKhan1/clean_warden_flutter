import 'package:riverpod/riverpod.dart';
import '../identity/warden_member.dart';
import '../engine/warden_engine.dart';

/// An observer for `riverpod` and `flutter_riverpod` that automatically validates provider state changes.
base class WardenProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    super.didUpdateProvider(context, previousValue, newValue);

    // In Riverpod 3.x, checking if the provider definition itself implements WardenMember
    if (context.provider is WardenMember) {
      WardenEngine.check(context.provider as WardenMember, newValue);
    }
  }
}
