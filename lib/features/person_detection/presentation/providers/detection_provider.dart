import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/dependency_injection.dart';
import '../../domain/entities/detection_result.dart';
import '../../domain/usecases/detect_persons.dart';
import '../../domain/usecases/get_detection_history.dart';
import '../../domain/usecases/save_detection_result.dart';

/// Provider pour le use case de détection
final detectPersonsUseCaseProvider = Provider<DetectPersons>((ref) {
  return getIt<DetectPersons>();
});

/// Provider pour le use case de récupération de l'historique
final getDetectionHistoryUseCaseProvider =
    Provider<GetDetectionHistory>((ref) {
  return getIt<GetDetectionHistory>();
});

/// Provider pour le use case de sauvegarde
final saveDetectionResultUseCaseProvider =
    Provider<SaveDetectionResult>((ref) {
  return getIt<SaveDetectionResult>();
});

/// État de détection
sealed class DetectionState {}

class DetectionInitial extends DetectionState {}

class DetectionLoading extends DetectionState {}

class DetectionSuccess extends DetectionState {
  final DetectionResult result;
  DetectionSuccess(this.result);
}

class DetectionError extends DetectionState {
  final String message;
  DetectionError(this.message);
}

/// Notifier pour la détection de personnes
class DetectionNotifier extends StateNotifier<DetectionState> {
  final DetectPersons detectPersonsUseCase;
  final SaveDetectionResult saveDetectionResultUseCase;

  DetectionNotifier({
    required this.detectPersonsUseCase,
    required this.saveDetectionResultUseCase,
  }) : super(DetectionInitial());

  /// Détecte les personnes dans une image
  Future<void> detectPersons(String imagePath,
      {double minConfidence = 0.7,}) async {
    state = DetectionLoading();

    final result = await detectPersonsUseCase(
      DetectPersonsParams(
        imagePath: imagePath,
        minConfidence: minConfidence,
      ),
    );

    result.fold(
      (failure) => state = DetectionError(failure.message),
      (detectionResult) => state = DetectionSuccess(detectionResult),
    );
  }

  /// Reset l'état à initial
  void reset() {
    state = DetectionInitial();
  }
}

/// Provider pour le notifier de détection
final detectionNotifierProvider =
    StateNotifierProvider<DetectionNotifier, DetectionState>((ref) {
  return DetectionNotifier(
    detectPersonsUseCase: ref.watch(detectPersonsUseCaseProvider),
    saveDetectionResultUseCase: ref.watch(saveDetectionResultUseCaseProvider),
  );
});

/// Provider pour l'historique des détections
final detectionHistoryProvider = FutureProvider<List<DetectionResult>>((ref) async {
  final useCase = ref.watch(getDetectionHistoryUseCaseProvider);
  final result = await useCase(const GetDetectionHistoryParams());

  return result.fold(
    (failure) => throw Exception(failure.message),
    (history) => history,
  );
});
