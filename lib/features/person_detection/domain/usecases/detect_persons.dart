import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/detection_result.dart';
import '../repositories/person_detection_repository.dart';

/// Use case pour détecter les personnes dans une image.
///
/// Prend en entrée un chemin d'image et un seuil de confiance optionnel,
/// et retourne un [DetectionResult] avec les personnes détectées.
class DetectPersons extends UseCase<DetectionResult, DetectPersonsParams> {
  final PersonDetectionRepository repository;

  DetectPersons({required this.repository});

  @override
  Future<Either<Failure, DetectionResult>> call(
    DetectPersonsParams params,
  ) async {
    return await repository.detectPersons(
      imagePath: params.imagePath,
      minConfidence: params.minConfidence,
    );
  }
}

/// Paramètres pour le use case DetectPersons
class DetectPersonsParams {
  final String imagePath;
  final double minConfidence;

  const DetectPersonsParams({
    required this.imagePath,
    this.minConfidence = 0.5,
  });
}
