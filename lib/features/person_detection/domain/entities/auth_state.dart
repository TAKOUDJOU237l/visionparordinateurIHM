import 'package:equatable/equatable.dart';
import 'user.dart';

/// États possibles de l'authentification
enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
}

/// Représente l'état d'authentification de l'application
class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  /// État initial
  const AuthState.initial()
      : status = AuthStatus.initial,
        user = null,
        errorMessage = null;

  /// État authentifié
  const AuthState.authenticated(User this.user)
      : status = AuthStatus.authenticated,
        errorMessage = null;

  /// État non authentifié
  const AuthState.unauthenticated([this.errorMessage])
      : status = AuthStatus.unauthenticated,
        user = null;

  /// État de chargement
  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        errorMessage = null;

  @override
  List<Object?> get props => [status, user, errorMessage];

  /// Vérifie si l'utilisateur est authentifié
  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
}