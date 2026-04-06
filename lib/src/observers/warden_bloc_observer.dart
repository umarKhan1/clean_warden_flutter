import 'package:bloc/bloc.dart';
import '../identity/warden_member.dart';
import '../engine/warden_engine.dart';

/// An observer for `bloc` and `flutter_bloc` that automatically validates emitted states.
class WardenBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is WardenMember) {
      WardenEngine.check(bloc as WardenMember, change.nextState);
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }
}
