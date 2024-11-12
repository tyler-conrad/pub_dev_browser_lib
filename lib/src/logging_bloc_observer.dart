import 'package:bloc/bloc.dart' as b;

import 'logger.dart' as l;

/// A [b.BlocObserver] that logs all bloc events and transitions.
///
/// Used for debugging purposes.
class LoggingBlocObserver extends b.BlocObserver {
  const LoggingBlocObserver();

  @override
  void onCreate(b.BlocBase bloc) {
    super.onCreate(bloc);
    l.log.d('Create: ${bloc.runtimeType}');
  }

  @override
  void onEvent(b.Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    l.log.d('Event: ${bloc.runtimeType} $event');
  }

  @override
  void onChange(b.BlocBase bloc, b.Change change) {
    super.onChange(bloc, change);
    l.log.d('Change: ${bloc.runtimeType} $change');
  }

  @override
  void onTransition(b.Bloc bloc, b.Transition transition) {
    super.onTransition(bloc, transition);
    l.log.d('Transition: ${bloc.runtimeType} $transition');
  }

  @override
  void onError(b.BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    l.log.e('Error: ${bloc.runtimeType}', error: error, stackTrace: stackTrace);
  }

  @override
  void onClose(b.BlocBase bloc) {
    super.onClose(bloc);
    l.log.d('Close: ${bloc.runtimeType}');
  }
}
