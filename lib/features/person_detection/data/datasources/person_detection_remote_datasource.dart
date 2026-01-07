import 'dart:io';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/tflite_service.dart';
import '../models/bounding_box_model.dart';
import '../models/detection_result_model.dart';

/// Interface du datasource remote pour la détection de personnes.
abstract class PersonDetectionRemoteDataSource {
  /// Détecte les personnes dans une image en utilisant le modèle TensorFlow Lite
  Future<DetectionResultModel> detectPersonsInImage({
    required String imagePath,
    required double minConfidence,
  });
}

/// Implémentation du datasource remote utilisant TensorFlow Lite local
class PersonDetectionRemoteDataSourceImpl
    implements PersonDetectionRemoteDataSource {
  final TFLiteService tfliteService;

  PersonDetectionRemoteDataSourceImpl({required this.tfliteService});

  @override
  Future<DetectionResultModel> detectPersonsInImage({
    required String imagePath,
    required double minConfidence,
  }) async {
    try {
      // Vérifier que le fichier existe
      final file = File(imagePath);
      if (!await file.exists()) {
        throw DetectionException('Image file not found: $imagePath');
      }

      // Détection réelle avec TensorFlow Lite
      final detections = await tfliteService.detectPersons(
        imagePath: imagePath,
        minConfidence: minConfidence,
      );

      final result = DetectionResultModel(
        personCount: detections.length,
        averageConfidence: _calculateAverageConfidence(detections),
        detections: detections,
        timestamp: DateTime.now(),
        imagePath: imagePath,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      return result;
    } catch (e) {
      if (e is DetectionException) rethrow;
      throw DetectionException('Failed to detect persons: $e');
    }
  }

  double _calculateAverageConfidence(List<BoundingBoxModel> detections) {
    if (detections.isEmpty) return 0.0;
    final sum = detections.fold<double>(0.0, (sum, box) => sum + box.confidence);
    return sum / detections.length;
  }
}
