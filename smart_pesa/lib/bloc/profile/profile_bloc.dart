import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../models/user.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) {
      if (currentUser.name.isEmpty && currentUser.email.isEmpty) {
        emit(ProfileLoadFailure("No user found"));
      } else {
        emit(ProfileLoadSuccess(user: currentUser));
      }
    });

    on<CreateProfile>((event, emit) {
      currentUser = User(
        name: event.name,
        email: event.email,
        avatarUrl: event.avatarUrl,
      );
      emit(ProfileLoadSuccess(user: currentUser));
    });

    on<UpdateProfile>((event, emit) {
      currentUser.name = event.name;
      currentUser.email = event.email;
      emit(ProfileLoadSuccess(user: currentUser));
    });
  }
}