import 'package:equatable/equatable.dart';

import 'bounding_box.dart';

/// Résultat d'une détection de personnes sur une image.
///
/// Contient le nombre de personnes détectées, le niveau de confiance global,
/// les boîtes englobantes individuelles et les métadonnées.
class DetectionResult extends Equatable {
  /// Nombre total de personnes détectées
  final int personCount;

  /// Niveau de confiance moyen de toutes les détections (0.0 - 1.0)
  final double averageConfidence;

  /// Liste des boîtes englobantes pour chaque personne détectée
  final List<BoundingBox> detections;

  /// Timestamp de la détection
  final DateTime timestamp;

  /// Chemin de l'image analysée
  final String imagePath;

  /// ID unique de la détection
  final String id;

  const DetectionResult({
    required this.personCount,
    required this.averageConfidence,
    required this.detections,
    required this.timestamp,
    required this.imagePath,
    required this.id,
  });

  /// Crée un résultat vide (aucune détection)
  factory DetectionResult.empty() {
    return DetectionResult(
      personCount: 0,
      averageConfidence: 0.0,
      detections: const [],
      timestamp: DateTime.now(),
      imagePath: '',
      id: '',
    );
  }

  /// Filtre les détections par seuil de confiance minimum
  DetectionResult filterByConfidence(double minConfidence) {
    final filteredDetections = detections
        .where((box) => box.confidence >= minConfidence)
        .toList();

    return DetectionResult(
      personCount: filteredDetections.length,
      averageConfidence: _calculateAverageConfidence(filteredDetections),
      detections: filteredDetections,
      timestamp: timestamp,
      imagePath: imagePath,
      id: id,
    );
  }

  /// Calcule la confiance moyenne d'une liste de détections
  static double _calculateAverageConfidence(List<BoundingBox> boxes) {
    if (boxes.isEmpty) return 0.0;
    final sum = boxes.fold<double>(0.0, (sum, box) => sum + box.confidence);
    return sum / boxes.length;
  }

  /// Retourne le pourcentage de confiance formaté (ex: "95%")
  String get confidencePercentage =>
      '${(averageConfidence * 100).toStringAsFixed(0)}%';

  /// Retourne true si la détection est fiable (confiance >= 80%)
  bool get isReliable => averageConfidence >= 0.8;

  /// Retourne true si la détection contient des résultats
  bool get hasDetections => personCount > 0;

  @override
  List<Object?> get props => [
        personCount,
        averageConfidence,
        detections,
        timestamp,
        imagePath,
        id,
      ];

  @override
  String toString() {
    return 'DetectionResult(personCount: $personCount, confidence: $confidencePercentage, time: $timestamp)';
  }
}
