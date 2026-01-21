import '../entities/user.dart';

/// Interface du repository d'authentification
/// Définit les opérations possibles sans implémentation (Clean Architecture)
abstract class AuthRepository {
  /// Connexion avec email et mot de passe
  Future<User> login(String email, String password);

  /// Inscription d'un nouvel utilisateur
  Future<User> signup({
    required String email,
    required String password,
    required String username,
    String? fullName,
  });

  /// Déconnexion
  Future<void> logout();

  /// Récupère l'utilisateur actuellement connecté
  Future<User?> getCurrentUser();

  /// Met à jour le profil utilisateur
  Future<User> updateProfile({
    required String userId,
    String? username,
    String? fullName,
    String? profileImagePath,
  });

  /// Change le mot de passe
  Future<void> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });

  /// Supprime le compte utilisateur
  Future<void> deleteAccount(String userId);

  /// Vérifie si un email existe déjà
  Future<bool> emailExists(String email);

  /// Vérifie si un username existe déjà
  Future<bool> usernameExists(String username);
}