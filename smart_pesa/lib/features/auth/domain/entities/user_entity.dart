import 'package:equatable/equatable.dart';

/// User entity representing a Smart-Pesa user
/// This is a domain entity - independent of any framework or database
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool isPremium;
  final DateTime? premiumExpiryDate;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isPremium = false,
    this.premiumExpiryDate,
    required this.createdAt,
  });

  /// Check if premium subscription is still active
  bool get isPremiumActive {
    if (!isPremium) return false;
    if (premiumExpiryDate == null) return false;
    return premiumExpiryDate!.isAfter(DateTime.now());
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        isPremium,
        premiumExpiryDate,
        createdAt,
      ];

  /// Create a copy of this entity with updated fields
  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? isPremium,
    DateTime? premiumExpiryDate,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiryDate: premiumExpiryDate ?? this.premiumExpiryDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

