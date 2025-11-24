// lib/models/user.dart

class User {
  String name;
  String email;
  String avatarUrl;

  User({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });
}

// Predefined dummy user for the app
User currentUser = User(
  name: "Ulrich Rukazambuga",
  email: "ulrich@example.com",
  avatarUrl: "https://i.pravatar.cc/150?img=3", // Sample avatar image
);
