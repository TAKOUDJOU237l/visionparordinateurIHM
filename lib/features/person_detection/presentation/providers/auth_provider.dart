import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/datasources/database_helper.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/entities/auth_state.dart';

// ==================== DATA LAYER ====================

/// Provider pour DatabaseHelper (singleton)
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

/// Provider pour UUID
final uuidProvider = Provider<Uuid>((ref) {
  return const Uuid();
});

/// Provider pour AuthLocalDataSource
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource(
    dbHelper: ref.watch(databaseHelperProvider),
    uuid: ref.watch(uuidProvider),
  );
});

/// Provider pour AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

// ==================== DOMAIN LAYER ====================

/// Provider pour LoginUseCase
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

/// Provider pour SignupUseCase
final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  return SignupUseCase(ref.watch(authRepositoryProvider));
});

/// Provider pour LogoutUseCase
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

/// Provider pour GetCurrentUserUseCase
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

/// Provider pour UpdateProfileUseCase
final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.watch(authRepositoryProvider));
});

/// Provider pour ChangePasswordUseCase
final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>((ref) {
  return ChangePasswordUseCase(ref.watch(authRepositoryProvider));
});

/// Provider pour DeleteAccountUseCase
final deleteAccountUseCaseProvider = Provider<DeleteAccountUseCase>((ref) {
  return DeleteAccountUseCase(ref.watch(authRepositoryProvider));
});

// ==================== PRESENTATION LAYER ====================

/// Provider pour l'état d'authentification (StateNotifier)
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.watch(loginUseCaseProvider),
    signupUseCase: ref.watch(signupUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    getCurrentUserUseCase: ref.watch(getCurrentUserUseCaseProvider),
    updateProfileUseCase: ref.watch(updateProfileUseCaseProvider),
    changePasswordUseCase: ref.watch(changePasswordUseCaseProvider),
    deleteAccountUseCase: ref.watch(deleteAccountUseCaseProvider),
  );
});

/// Notifier pour gérer l'état d'authentification
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  AuthNotifier({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
    required this.deleteAccountUseCase,
  }) : super(const AuthState.initial()) {
    checkAuthStatus();
  }

  /// Vérifie le statut d'authentification au démarrage
  Future<void> checkAuthStatus() async {
    try {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  /// Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final user = await loginUseCase(email: email, password: password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.unauthenticated(e.toString());
    }
  }

  /// Signup
  Future<void> signup({
    required String email,
    required String password,
    required String username,
    String? fullName,
  }) async {
    state = const AuthState.loading();
    try {
      final user = await signupUseCase(
        email: email,
        password: password,
        username: username,
        fullName: fullName,
      );
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.unauthenticated(e.toString());
    }
  }

  /// Logout
  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      await logoutUseCase();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.unauthenticated(e.toString());
    }
  }

  /// Update profile
  Future<void> updateProfile({
    String? username,
    String? fullName,
    String? profileImagePath,
  }) async {
    if (state.user == null) return;

    try {
      final updatedUser = await updateProfileUseCase(
        userId: state.user!.id,
        username: username,
        fullName: fullName,
        profileImagePath: profileImagePath,
      );
      state = AuthState.authenticated(updatedUser);
    } catch (e) {
      // En cas d'erreur, on garde l'état actuel
      rethrow;
    }
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (state.user == null) return;

    try {
      await changePasswordUseCase(
        userId: state.user!.id,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    if (state.user == null) return;

    try {
      await deleteAccountUseCase(state.user!.id);
      state = const AuthState.unauthenticated();
    } catch (e) {
      rethrow;
    }
  }
}