import 'package:apod/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.i(
      """
    Transition
    - currentState: ${transition.currentState},
    - event: ${transition.event},
    - nextState: ${transition.nextState}
    """,
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.e('Bloc onError', error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    logger.t('Bloc onEvent -> $event');
    super.onEvent(bloc, event);
  }
}
