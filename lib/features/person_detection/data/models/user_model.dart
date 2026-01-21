import '../../domain/entities/user.dart';

/// Modèle de données pour User avec sérialisation JSON/SQLite
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    super.fullName,
    super.profileImagePath,
    required super.createdAt,
    super.updatedAt,
  });

  /// Crée un UserModel depuis un JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String?,
      profileImagePath: json['profileImagePath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convertit le UserModel en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'fullName': fullName,
      'profileImagePath': profileImagePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Crée un UserModel depuis une Entity
  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      username: entity.username,
      fullName: entity.fullName,
      profileImagePath: entity.profileImagePath,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Crée un UserModel depuis une ligne de base de données SQLite
  factory UserModel.fromDatabase(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      fullName: map['full_name'] as String?,
      profileImagePath: map['profile_image_path'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  /// Convertit en Map pour l'insertion dans SQLite
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'full_name': fullName,
      'profile_image_path': profileImagePath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}