import 'package:flutter_bloc/flutter_bloc.dart';
import 'premium_state.dart';

class PremiumCubit extends Cubit<PremiumState> {
  PremiumCubit() : super(const PremiumState(isPremium: false));

  void unlockPremium() {
    emit(const PremiumState(isPremium: true));
  }
}
