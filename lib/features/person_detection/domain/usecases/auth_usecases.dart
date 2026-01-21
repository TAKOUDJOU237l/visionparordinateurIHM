import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case pour la déconnexion
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}

/// Use case pour obtenir l'utilisateur actuel
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<User?> call() async {
    return await repository.getCurrentUser();
  }
}

/// Use case pour mettre à jour le profil
class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<User> call({
    required String userId,
    String? username,
    String? fullName,
    String? profileImagePath,
  }) async {
    if (username != null && username.isNotEmpty) {
      if (!_isValidUsername(username)) {
        throw Exception(
          'Le nom d\'utilisateur doit contenir entre 3 et 20 caractères '
          'et uniquement des lettres, chiffres et underscores',
        );
      }

      // Vérifier si le username existe déjà
      if (await repository.usernameExists(username)) {
        throw Exception('Ce nom d\'utilisateur est déjà pris');
      }
    }

    return await repository.updateProfile(
      userId: userId,
      username: username,
      fullName: fullName,
      profileImagePath: profileImagePath,
    );
  }

  bool _isValidUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
    return usernameRegex.hasMatch(username);
  }
}

/// Use case pour changer le mot de passe
class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<void> call({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    if (currentPassword.isEmpty) {
      throw Exception('Le mot de passe actuel est requis');
    }
    if (newPassword.isEmpty) {
      throw Exception('Le nouveau mot de passe est requis');
    }

    if (!_isValidPassword(newPassword)) {
      throw Exception(
        'Le mot de passe doit contenir au moins 8 caractères, '
        'une majuscule, une minuscule et un chiffre',
      );
    }

    if (currentPassword == newPassword) {
      throw Exception('Le nouveau mot de passe doit être différent');
    }

    await repository.changePassword(
      userId: userId,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  bool _isValidPassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    return true;
  }
}

/// Use case pour supprimer le compte
class DeleteAccountUseCase {
  final AuthRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<void> call(String userId) async {
    await repository.deleteAccount(userId);
  }
}