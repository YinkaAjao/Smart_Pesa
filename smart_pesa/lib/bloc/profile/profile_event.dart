abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class CreateProfile extends ProfileEvent {
  final String name;
  final String email;
  final String avatarUrl;

  const CreateProfile({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  @override
  List<Object> get props => [name, email, avatarUrl];
}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String email;

  const UpdateProfile({required this.name, required this.email});

  @override
  List<Object> get props => [name, email];
}