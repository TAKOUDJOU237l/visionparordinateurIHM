import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case pour l'inscription utilisateur
class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  /// Execute l'inscription
  Future<User> call({
    required String email,
    required String password,
    required String username,
    String? fullName,
  }) async {
    // Validation
    if (email.isEmpty) {
      throw Exception('L\'email est requis');
    }
    if (password.isEmpty) {
      throw Exception('Le mot de passe est requis');
    }
    if (username.isEmpty) {
      throw Exception('Le nom d\'utilisateur est requis');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Format d\'email invalide');
    }

    if (!_isValidPassword(password)) {
      throw Exception(
        'Le mot de passe doit contenir au moins 8 caractères, '
        'une majuscule, une minuscule et un chiffre',
      );
    }

    if (!_isValidUsername(username)) {
      throw Exception(
        'Le nom d\'utilisateur doit contenir entre 3 et 20 caractères '
        'et uniquement des lettres, chiffres et underscores',
      );
    }

    // Vérifier si l'email existe déjà
    if (await repository.emailExists(email)) {
      throw Exception('Cet email est déjà utilisé');
    }

    // Vérifier si le username existe déjà
    if (await repository.usernameExists(username)) {
      throw Exception('Ce nom d\'utilisateur est déjà pris');
    }

    return await repository.signup(
      email: email,
      password: password,
      username: username,
      fullName: fullName,
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    // Au moins 8 caractères, une majuscule, une minuscule, un chiffre
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    return true;
  }

  bool _isValidUsername(String username) {
    // Entre 3 et 20 caractères, lettres, chiffres et underscores uniquement
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
    return usernameRegex.hasMatch(username);
  }
}