import '../../domain/entities/detection_result.dart';
import 'bounding_box_model.dart';

/// Modèle de données pour DetectionResult avec sérialisation JSON.
class DetectionResultModel extends DetectionResult {
  const DetectionResultModel({
    required super.personCount,
    required super.averageConfidence,
    required super.detections,
    required super.timestamp,
    required super.imagePath,
    required super.id,
  });

  /// Crée un DetectionResultModel depuis un JSON
  factory DetectionResultModel.fromJson(Map<String, dynamic> json) {
    return DetectionResultModel(
      personCount: json['personCount'] as int,
      averageConfidence: (json['averageConfidence'] as num).toDouble(),
      detections: (json['detections'] as List<dynamic>)
          .map((box) => BoundingBoxModel.fromJson(box as Map<String, dynamic>))
          .toList(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      imagePath: json['imagePath'] as String,
      id: json['id'] as String,
    );
  }

  /// Convertit le DetectionResultModel en JSON
  Map<String, dynamic> toJson() {
    return {
      'personCount': personCount,
      'averageConfidence': averageConfidence,
      'detections': detections
          .map((box) => BoundingBoxModel.fromEntity(box).toJson())
          .toList(),
      'timestamp': timestamp.toIso8601String(),
      'imagePath': imagePath,
      'id': id,
    };
  }

  /// Crée un DetectionResultModel depuis une Entity
  factory DetectionResultModel.fromEntity(DetectionResult entity) {
    return DetectionResultModel(
      personCount: entity.personCount,
      averageConfidence: entity.averageConfidence,
      detections: entity.detections
          .map((box) => BoundingBoxModel.fromEntity(box))
          .toList(),
      timestamp: entity.timestamp,
      imagePath: entity.imagePath,
      id: entity.id,
    );
  }
}
