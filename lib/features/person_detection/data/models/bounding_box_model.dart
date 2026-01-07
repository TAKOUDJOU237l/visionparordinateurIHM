import '../../domain/entities/bounding_box.dart';

/// Modèle de données pour BoundingBox avec sérialisation JSON.
class BoundingBoxModel extends BoundingBox {
  const BoundingBoxModel({
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    required super.confidence,
  });

  /// Crée un BoundingBoxModel depuis un JSON
  factory BoundingBoxModel.fromJson(Map<String, dynamic> json) {
    return BoundingBoxModel(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  /// Convertit le BoundingBoxModel en JSON
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'confidence': confidence,
    };
  }

  /// Crée un BoundingBoxModel depuis une Entity
  factory BoundingBoxModel.fromEntity(BoundingBox entity) {
    return BoundingBoxModel(
      x: entity.x,
      y: entity.y,
      width: entity.width,
      height: entity.height,
      confidence: entity.confidence,
    );
  }
}
