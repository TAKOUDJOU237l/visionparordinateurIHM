import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/utils/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure system UI overlay
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    print('🚀 Démarrage de SmartHeadCount...');
    
    // Initialize dependencies (CHANGÉ ICI)
    await setupDependencyInjection();
    
    // Initialize TFLite service in background (optional)
    initializeTFLiteService().catchError((e) {
      print(' TFLite sera initialisé plus tard: $e');
    });
    
    print(' Application prête!');
    
    runApp(
      const ProviderScope(
        child: SmartHeadCountApp(),
      ),
    );
    
  } catch (e, stackTrace) {
    print(' Erreur fatale au démarrage: $e');
    print(stackTrace);
    
    // Afficher un écran d'erreur
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Erreur de démarrage',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}