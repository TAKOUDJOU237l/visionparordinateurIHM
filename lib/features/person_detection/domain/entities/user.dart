import 'package:equatable/equatable.dart';

/// Entité User représentant un utilisateur dans le domaine métier
class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? fullName;
  final String? profileImagePath;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.fullName,
    this.profileImagePath,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        fullName,
        profileImagePath,
        createdAt,
        updatedAt,
      ];

  /// Copie l'utilisateur avec des modifications
  User copyWith({
    String? id,
    String? email,
    String? username,
    String? fullName,
    String? profileImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Retourne les initiales de l'utilisateur pour l'avatar
  String get initials {
    if (fullName != null && fullName!.isNotEmpty) {
      final parts = fullName!.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return fullName![0].toUpperCase();
    }
    return username[0].toUpperCase();
  }

  /// Retourne le nom d'affichage
  String get displayName => fullName ?? username;
}