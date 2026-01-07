import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/detection_result.dart';

/// Interface du repository de détection de personnes.
///
/// Définit le contrat pour accéder aux fonctionnalités de détection,
/// indépendamment de l'implémentation technique (API, ML local, etc.).
abstract class PersonDetectionRepository {
  /// Détecte les personnes dans une image.
  ///
  /// [imagePath] - Chemin vers l'image à analyser
  /// [minConfidence] - Seuil de confiance minimum (optionnel, défaut: 0.5)
  ///
  /// Retourne [Right(DetectionResult)] en cas de succès,
  /// ou [Left(Failure)] en cas d'erreur.
  Future<Either<Failure, DetectionResult>> detectPersons({
    required String imagePath,
    double minConfidence = 0.5,
  });

  /// Récupère l'historique des détections.
  ///
  /// [limit] - Nombre maximum de résultats à retourner (optionnel)
  ///
  /// Retourne [Right(List<DetectionResult>)] en cas de succès,
  /// ou [Left(Failure)] en cas d'erreur.
  Future<Either<Failure, List<DetectionResult>>> getDetectionHistory({
    int? limit,
  });

  /// Sauvegarde un résultat de détection dans l'historique.
  ///
  /// [result] - Le résultat de détection à sauvegarder
  ///
  /// Retourne [Right(void)] en cas de succès,
  /// ou [Left(Failure)] en cas d'erreur.
  Future<Either<Failure, void>> saveDetectionResult({
    required DetectionResult result,
  });

  /// Supprime un résultat de l'historique.
  ///
  /// [id] - ID du résultat à supprimer
  ///
  /// Retourne [Right(void)] en cas de succès,
  /// ou [Left(Failure)] en cas d'erreur.
  Future<Either<Failure, void>> deleteDetectionResult({
    required String id,
  });

  /// Supprime tout l'historique des détections.
  ///
  /// Retourne [Right(void)] en cas de succès,
  /// ou [Left(Failure)] en cas d'erreur.
  Future<Either<Failure, void>> clearHistory();
}
