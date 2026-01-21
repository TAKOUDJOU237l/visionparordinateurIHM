import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case pour la connexion utilisateur
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Execute le login
  Future<User> call({
    required String email,
    required String password,
  }) async {
    // Validation
    if (email.isEmpty) {
      throw Exception('L\'email est requis');
    }
    if (password.isEmpty) {
      throw Exception('Le mot de passe est requis');
    }
    if (!_isValidEmail(email)) {
      throw Exception('Format d\'email invalide');
    }

    return await repository.login(email, password);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}