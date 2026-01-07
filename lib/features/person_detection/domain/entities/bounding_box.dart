import 'package:equatable/equatable.dart';

/// Représente une boîte englobante (bounding box) autour d'une personne détectée.
///
/// Utilisée pour dessiner les rectangles de détection sur l'image.
class BoundingBox extends Equatable {
  /// Position X du coin supérieur gauche (0.0 - 1.0, normalisé)
  final double x;

  /// Position Y du coin supérieur gauche (0.0 - 1.0, normalisé)
  final double y;

  /// Largeur de la boîte (0.0 - 1.0, normalisé)
  final double width;

  /// Hauteur de la boîte (0.0 - 1.0, normalisé)
  final double height;

  /// Niveau de confiance de la détection (0.0 - 1.0)
  final double confidence;

  const BoundingBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.confidence,
  });

  /// Vérifie si la confiance est supérieure ou égale au seuil donné
  bool isAboveThreshold(double threshold) => confidence >= threshold;

  /// Retourne true si la détection est hautement fiable (> 90%)
  bool get isHighConfidence => confidence >= 0.9;

  /// Retourne true si la détection est incertaine (50-90%)
  bool get isUncertain => confidence >= 0.5 && confidence < 0.9;

  @override
  List<Object?> get props => [x, y, width, height, confidence];

  @override
  String toString() {
    return 'BoundingBox(x: $x, y: $y, width: $width, height: $height, confidence: ${(confidence * 100).toStringAsFixed(1)}%)';
  }
}
