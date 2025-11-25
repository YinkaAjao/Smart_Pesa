import 'package:flutter_bloc/flutter_bloc.dart';
import 'premium_event.dart';
import 'premium_state.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  bool _isSubscribed = false;

  PremiumBloc() : super(PremiumInitial()) {
    on<LoadSubscription>((event, emit) {
      emit(PremiumLoadSuccess(isSubscribed: _isSubscribed));
    });

    on<UpgradeSubscription>((event, emit) {
      _isSubscribed = true;
      emit(PremiumLoadSuccess(isSubscribed: _isSubscribed));
    });
  }
}