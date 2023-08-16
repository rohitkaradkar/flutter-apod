import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(
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
    print('Bloc onError -> $error');
    print(stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    print('Bloc onEvent -> $event');
    super.onEvent(bloc, event);
  }
}
