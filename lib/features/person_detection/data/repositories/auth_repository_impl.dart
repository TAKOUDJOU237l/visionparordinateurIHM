import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

/// Implémentation du repository d'authentification
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<User> login(String email, String password) async {
    try {
      final user = await localDataSource.login(email, password);
      await localDataSource.saveSession(user.id);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> signup({
    required String email,
    required String password,
    required String username,
    String? fullName,
  }) async {
    try {
      final user = await localDataSource.signup(
        email: email,
        password: password,
        username: username,
        fullName: fullName,
      );
      await localDataSource.saveSession(user.id);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localDataSource.logout();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      return await localDataSource.getCurrentUser();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> updateProfile({
    required String userId,
    String? username,
    String? fullName,
    String? profileImagePath,
  }) async {
    try {
      return await localDataSource.updateProfile(
        userId: userId,
        username: username,
        fullName: fullName,
        profileImagePath: profileImagePath,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await localDataSource.changePassword(
        userId: userId,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount(String userId) async {
    try {
      await localDataSource.deleteAccount(userId);
      await localDataSource.logout();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> emailExists(String email) async {
    try {
      return await localDataSource.emailExists(email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> usernameExists(String username) async {
    try {
      return await localDataSource.usernameExists(username);
    } catch (e) {
      rethrow;
    }
  }
}