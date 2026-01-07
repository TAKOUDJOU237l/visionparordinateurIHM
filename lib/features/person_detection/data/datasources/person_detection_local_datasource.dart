import 'package:hive/hive.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/detection_result_model.dart';

/// Interface du datasource local pour la détection de personnes.
abstract class PersonDetectionLocalDataSource {
  /// Sauvegarde un résultat de détection dans Hive
  Future<void> cacheDetectionResult(DetectionResultModel result);

  /// Récupère l'historique des détections depuis Hive
  Future<List<DetectionResultModel>> getCachedDetectionHistory({int? limit});

  /// Supprime un résultat de détection
  Future<void> deleteDetectionResult(String id);

  /// Vide l'historique complet
  Future<void> clearHistory();
}

/// Implémentation du datasource local utilisant Hive
class PersonDetectionLocalDataSourceImpl
    implements PersonDetectionLocalDataSource {
  final Box<dynamic> box;

  PersonDetectionLocalDataSourceImpl({required this.box});

  @override
  Future<void> cacheDetectionResult(DetectionResultModel result) async {
    try {
      await box.put(result.id, result.toJson());
      print('✓ Résultat sauvegardé: ${result.id}');
    } catch (e) {
      print('Erreur de sauvegarde: $e');
      throw CacheException('Failed to cache detection result: $e');
    }
  }

  @override
  Future<List<DetectionResultModel>> getCachedDetectionHistory({
    int? limit,
  }) async {
    try {
      print(' Récupération de l\'historique depuis Hive...');
      final values = box.values.toList();
      print('   Nombre d\'éléments: ${values.length}');

      if (values.isEmpty) {
        print('   Historique vide');
        return [];
      }

      // Convertir en DetectionResultModel avec gestion correcte des types
      final results = <DetectionResultModel>[];
      
      for (var i = 0; i < values.length; i++) {
        final value = values[i];
        
        try {
          // Convertir Map<dynamic, dynamic> en Map<String, dynamic>
          Map<String, dynamic> jsonMap;
          
          if (value is Map<String, dynamic>) {
            // Déjà au bon format
            jsonMap = value;
          } else if (value is Map) {
            // Conversion explicite de Map<dynamic, dynamic> vers Map<String, dynamic>
            jsonMap = {};
            value.forEach((key, val) {
              if (key is String) {
                // Convertir les valeurs également si nécessaire
                if (val is Map) {
                  // Pour les sous-maps (comme detections)
                  jsonMap[key] = _convertMapToStringKeys(val);
                } else if (val is List) {
                  // Pour les listes (comme la liste des détections)
                  jsonMap[key] = val.map((item) {
                    if (item is Map) {
                      return _convertMapToStringKeys(item);
                    }
                    return item;
                  }).toList();
                } else {
                  jsonMap[key] = val;
                }
              }
            });
          } else {
            print('⚠️  Type non supporté à l\'index $i: ${value.runtimeType}');
            continue;
          }
          
          // Créer le modèle
          final result = DetectionResultModel.fromJson(jsonMap);
          results.add(result);
          
        } catch (e) {
          print('⚠️  Erreur lors de la conversion de l\'élément $i: $e');
          print('   Type: ${value.runtimeType}');
          // Continuer avec les autres résultats
          continue;
        }
      }

      print('✓ ${results.length} résultats chargés');

      // Trier par date décroissante
      results.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Appliquer la limite si spécifiée
      if (limit != null && limit < results.length) {
        return results.sublist(0, limit);
      }

      return results;
    } catch (e, stackTrace) {
      print(' Erreur lors de la récupération de l\'historique: $e');
      print('StackTrace: $stackTrace');
      throw CacheException('Failed to get cached history: $e');
    }
  }

  /// Convertit une Map avec des clés dynamic en Map<String, dynamic>
  Map<String, dynamic> _convertMapToStringKeys(Map map) {
    final result = <String, dynamic>{};
    map.forEach((key, value) {
      if (key is String) {
        if (value is Map) {
          result[key] = _convertMapToStringKeys(value);
        } else if (value is List) {
          result[key] = value.map((item) {
            if (item is Map) {
              return _convertMapToStringKeys(item);
            }
            return item;
          }).toList();
        } else {
          result[key] = value;
        }
      }
    });
    return result;
  }

  @override
  Future<void> deleteDetectionResult(String id) async {
    try {
      await box.delete(id);
      print('✓ Résultat supprimé: $id');
    } catch (e) {
      print(' Erreur de suppression: $e');
      throw CacheException('Failed to delete detection result: $e');
    }
  }

  @override
  Future<void> clearHistory() async {
    try {
      await box.clear();
      print('✓ Historique vidé');
    } catch (e) {
      print(' Erreur lors du vidage: $e');
      throw CacheException('Failed to clear history: $e');
    }
  }
}