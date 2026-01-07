import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/detection_result.dart';
import '../repositories/person_detection_repository.dart';

/// Use case pour récupérer l'historique des détections.
///
/// Retourne la liste des détections passées, triées par date décroissante.
class GetDetectionHistory
    extends UseCase<List<DetectionResult>, GetDetectionHistoryParams> {
  final PersonDetectionRepository repository;

  GetDetectionHistory({required this.repository});

  @override
  Future<Either<Failure, List<DetectionResult>>> call(
    GetDetectionHistoryParams params,
  ) async {
    return await repository.getDetectionHistory(
      limit: params.limit,
    );
  }
}

/// Paramètres pour le use case GetDetectionHistory
class GetDetectionHistoryParams {
  final int? limit;

  const GetDetectionHistoryParams({this.limit});
}
