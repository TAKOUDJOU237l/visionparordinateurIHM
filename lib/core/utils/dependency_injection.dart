import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/person_detection/data/datasources/person_detection_local_datasource.dart';
import '../../features/person_detection/data/datasources/person_detection_remote_datasource.dart';
import '../../features/person_detection/data/repositories/person_detection_repository_impl.dart';
import '../../features/person_detection/domain/repositories/person_detection_repository.dart';
import '../../features/person_detection/domain/usecases/detect_persons.dart';
import '../../features/person_detection/domain/usecases/get_detection_history.dart';
import '../../features/person_detection/domain/usecases/save_detection_result.dart';
import '../services/tflite_service.dart';

final getIt = GetIt.instance;

/// Initialise toutes les dépendances de l'application
Future<void> setupDependencyInjection() async {
  // ===== Services externes =====
  
  // SharedPreferences (AJOUTÉ)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  print(' SharedPreferences enregistré');
  
  // Initialiser Hive
  await Hive.initFlutter();
  
  // Ouvrir la box avec le bon type (Map pour stocker les détections)
  final detectionBox = await Hive.openBox<Map<dynamic, dynamic>>('detections');
  
  print('Hive initialisé - Box: ${detectionBox.name}');
  
  // Service TFLite (SINGLETON - une seule instance)
  getIt.registerLazySingleton<TFLiteService>(
    () => TFLiteService(),
  );
  
  // ===== Data Sources =====
  
  // Remote Data Source (utilise TFLite)
  getIt.registerLazySingleton<PersonDetectionRemoteDataSource>(
    () => PersonDetectionRemoteDataSourceImpl(
      tfliteService: getIt<TFLiteService>(),
    ),
  );
  
  // Local Data Source (utilise Hive)
  getIt.registerLazySingleton<PersonDetectionLocalDataSource>(
    () => PersonDetectionLocalDataSourceImpl(
      box: detectionBox,
    ),
  );
  
  // ===== Repositories =====
  
  getIt.registerLazySingleton<PersonDetectionRepository>(
    () => PersonDetectionRepositoryImpl(
      remoteDataSource: getIt<PersonDetectionRemoteDataSource>(),
      localDataSource: getIt<PersonDetectionLocalDataSource>(),
    ),
  );
  
  // ===== Use Cases =====
  
  getIt.registerLazySingleton<DetectPersons>(
    () => DetectPersons(repository: getIt<PersonDetectionRepository>()),
  );
  
  getIt.registerLazySingleton<GetDetectionHistory>(
    () => GetDetectionHistory(repository: getIt<PersonDetectionRepository>()),
  );
  
  getIt.registerLazySingleton<SaveDetectionResult>(
    () => SaveDetectionResult(repository: getIt<PersonDetectionRepository>()),
  );
  
  print(' Dependency Injection configuré avec succès');
}

/// Initialise le service TFLite au démarrage
Future<void> initializeTFLiteService() async {
  try {
    print('Initialisation du service TFLite...');
    final tfliteService = getIt<TFLiteService>();
    await tfliteService.initialize(model: 'mobilenet');
    print(' Service TFLite prêt!');
  } catch (e) {
    print('  Erreur d\'initialisation TFLite: $e');
    print('   Le modèle sera téléchargé lors de la première détection.');
    // Ne pas rethrow - l'app peut continuer
  }
}

/// Libère toutes les ressources
Future<void> disposeDependencies() async {
  try {
    final tfliteService = getIt<TFLiteService>();
    tfliteService.dispose();
  } catch (e) {
    print('  Erreur lors de la libération de TFLite: $e');
  }
  
  try {
    await Hive.close();
  } catch (e) {
    print(' Erreur lors de la fermeture de Hive: $e');
  }
  
  print(' Ressources libérées');
}

// ALIAS pour compatibilité avec votre ancien code
Future<void> configureDependencies() => setupDependencyInjection();