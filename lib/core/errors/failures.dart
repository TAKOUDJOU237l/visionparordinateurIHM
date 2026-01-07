import 'package:equatable/equatable.dart';

/// Classe de base pour toutes les erreurs métier de l'application.
///
/// Les Failures représentent des erreurs du domaine métier,
/// indépendantes de toute implémentation technique.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Erreur serveur / API
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Erreur de cache / stockage local
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Erreur de réseau / connectivité
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Erreur de permissions (caméra, stockage, etc.)
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Erreur de détection (modèle IA, traitement d'image)
class DetectionFailure extends Failure {
  const DetectionFailure(super.message);
}

/// Erreur de validation (données invalides)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Erreur non gérée / inconnue
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
