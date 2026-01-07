import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/detection_result.dart';
import '../repositories/person_detection_repository.dart';

/// Use case pour sauvegarder un résultat de détection dans l'historique.
class SaveDetectionResult extends UseCase<void, SaveDetectionResultParams> {
  final PersonDetectionRepository repository;

  SaveDetectionResult({required this.repository});

  @override
  Future<Either<Failure, void>> call(SaveDetectionResultParams params) async {
    return await repository.saveDetectionResult(
      result: params.result,
    );
  }
}

/// Paramètres pour le use case SaveDetectionResult
class SaveDetectionResultParams {
  final DetectionResult result;

  const SaveDetectionResultParams({required this.result});
}
