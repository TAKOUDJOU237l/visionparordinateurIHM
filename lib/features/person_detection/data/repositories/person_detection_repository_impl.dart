import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/detection_result.dart';
import '../../domain/repositories/person_detection_repository.dart';
import '../datasources/person_detection_local_datasource.dart';
import '../datasources/person_detection_remote_datasource.dart';
import '../models/detection_result_model.dart';

/// Implémentation du repository de détection de personnes.
class PersonDetectionRepositoryImpl implements PersonDetectionRepository {
  final PersonDetectionRemoteDataSource remoteDataSource;
  final PersonDetectionLocalDataSource localDataSource;

  PersonDetectionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, DetectionResult>> detectPersons({
    required String imagePath,
    double minConfidence = 0.5,
  }) async {
    try {
      final result = await remoteDataSource.detectPersonsInImage(
        imagePath: imagePath,
        minConfidence: minConfidence,
      );

      // Sauvegarder automatiquement dans le cache
      await localDataSource.cacheDetectionResult(result);

      return Right(result);
    } on DetectionException catch (e) {
      return Left(DetectionFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<DetectionResult>>> getDetectionHistory({
    int? limit,
  }) async {
    try {
      final results = await localDataSource.getCachedDetectionHistory(
        limit: limit,
      );
      return Right(results);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Failed to get history: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveDetectionResult({
    required DetectionResult result,
  }) async {
    try {
      final model = DetectionResultModel.fromEntity(result);
      await localDataSource.cacheDetectionResult(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Failed to save result: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDetectionResult({
    required String id,
  }) async {
    try {
      await localDataSource.deleteDetectionResult(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Failed to delete result: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory() async {
    try {
      await localDataSource.clearHistory();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Failed to clear history: $e'));
    }
  }
}
