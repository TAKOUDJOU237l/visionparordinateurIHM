import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

import '../../features/person_detection/data/models/bounding_box_model.dart';

/// Service réel pour la détection de personnes avec MobileNet SSD
/// Utilise un modèle local inclus dans l'app (pas de téléchargement)
class TFLiteService {
  Interpreter? _interpreter;
  bool _isInitialized = false;
  String _currentModel = 'mobilenet';
  bool _useGpu = true; // Tente d'utiliser le GPU par défaut

  /// Initialise le service avec le modèle local
  Future<void> initialize({String model = 'mobilenet', bool? useGpu}) async {
    // Si useGpu est spécifié, on met à jour le flag
    if (useGpu != null) {
      _useGpu = useGpu;
    }

    if (_isInitialized && _currentModel == model) return;

    try {
      print(' Initialisation du service de détection...');

      _currentModel = model;

      // Copier le modèle depuis les assets vers un fichier temporaire
      final modelPath = await _loadModelFromAssets();

      print('Chargement du modèle depuis: $modelPath');

      // Options pour l'interpréteur
      final options = InterpreterOptions()..threads = 4;

      // Ajouter le délégué GPU si demandé et disponible
      if (Platform.isAndroid && _useGpu) {
        try {
          options.addDelegate(GpuDelegateV2());
          print('✓ GPU delegate activé');
        } catch (e) {
          print('⚠ GPU non disponible, utilisation du CPU');
          _useGpu = false;
        }
      } else {
        print('ℹ️ Mode CPU activé');
      }

      // Charger le modèle
      _interpreter = Interpreter.fromFile(
        File(modelPath),
        options: options,
      );

      _isInitialized = true;
      print(' Modèle MobileNet SSD chargé avec succès!');

      // Afficher les informations du modèle
      _printModelInfo();

    } catch (e) {
      print(' Erreur lors de l\'initialisation: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  /// Charge le modèle depuis les assets
  Future<String> _loadModelFromAssets() async {
    try {
      // Charger le modèle depuis assets/models/detect.tflite
      final modelData = await rootBundle.load('assets/models/detect.tflite');
      
      // Créer un fichier temporaire
      final appDir = await getApplicationDocumentsDirectory();
      final modelFile = File('${appDir.path}/detect.tflite');
      
      // Écrire les données dans le fichier
      await modelFile.writeAsBytes(
        modelData.buffer.asUint8List(
          modelData.offsetInBytes,
          modelData.lengthInBytes,
        ),
      );
      
      print('✓ Modèle copié depuis les assets (${(modelData.lengthInBytes / 1024 / 1024).toStringAsFixed(2)} MB)');
      
      return modelFile.path;
    } catch (e) {
      print(' Erreur lors du chargement du modèle: $e');
      rethrow;
    }
  }

  /// Affiche les informations du modèle
  void _printModelInfo() {
    if (_interpreter == null) return;
    
    print(' Informations du modèle:');
    try {
      final inputTensors = _interpreter!.getInputTensors();
      final outputTensors = _interpreter!.getOutputTensors();
      
      print('   Inputs:');
      for (var tensor in inputTensors) {
        print('     - Shape: ${tensor.shape}, Type: ${tensor.type}');
      }
      
      print('   Outputs:');
      for (var tensor in outputTensors) {
        print('     - Shape: ${tensor.shape}, Type: ${tensor.type}');
      }
    } catch (e) {
      print('   Impossible d\'obtenir les infos du modèle: $e');
    }
  }

  /// Détecte les personnes dans une image
  Future<List<BoundingBoxModel>> detectPersons({
    required String imagePath,
    required double minConfidence,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      print('🔍 Détection en cours sur: $imagePath');
      
      // Charger et prétraiter l'image
      final imageBytes = await File(imagePath).readAsBytes();
      final image = img.decodeImage(imageBytes);
      
      if (image == null) {
        print('Impossible de décoder l\'image');
        return [];
      }
      
      print('📸 Image: ${image.width}x${image.height}');
      
      // Détection avec MobileNet SSD
      final detections = await _detectWithMobileNet(image, minConfidence);
      
      print(' ${detections.length} personne(s) détectée(s)');
      
      return detections;
      
    } catch (e) {
      print(' Erreur lors de la détection: $e');
      rethrow;
    }
  }

  /// Détection avec MobileNet SSD
  Future<List<BoundingBoxModel>> _detectWithMobileNet(
    img.Image image,
    double minConfidence,
  ) async {
    // Redimensionner l'image à 300x300 (input de MobileNet SSD)
    final resized = img.copyResize(image, width: 300, height: 300);

    // Convertir en tenseur uint8 [1, 300, 300, 3]
    final inputBytes = _imageToByteListUint8(resized, 300);

    // Préparer les outputs
    // MobileNet SSD quantized a 4 outputs:
    // Output 0: Locations [1, 10, 4] - coordonnées des bounding boxes
    // Output 1: Classes [1, 10] - identifiants des classes
    // Output 2: Scores [1, 10] - scores de confiance
    // Output 3: Number of detections [1] - nombre de détections
    final outputLocations = List.generate(
      1,
      (_) => List.generate(10, (_) => List.filled(4, 0.0)),
    );
    final outputClasses = List.generate(1, (_) => List.filled(10, 0.0));
    final outputScores = List.generate(1, (_) => List.filled(10, 0.0));
    final numDetections = List.filled(1, 0.0);

    final outputs = {
      0: outputLocations,
      1: outputClasses,
      2: outputScores,
      3: numDetections,
    };

    // Exécuter l'inférence avec fallback CPU si GPU échoue
    try {
      _interpreter!.runForMultipleInputs([inputBytes], outputs);
    } catch (e) {
      // Si le GPU delegate échoue, on réinitialise en mode CPU
      if (_useGpu) {
        print('⚠️ GPU delegate a échoué, basculement vers CPU...');
        print('   Erreur: $e');

        // Fermer l'interpréteur actuel
        _interpreter?.close();
        _interpreter = null;
        _isInitialized = false;

        // Réinitialiser en mode CPU
        _useGpu = false;
        await initialize(model: _currentModel, useGpu: false);

        // Réessayer l'inférence en mode CPU
        print('🔄 Réessai de l\'inférence en mode CPU...');
        _interpreter!.runForMultipleInputs([inputBytes], outputs);
      } else {
        // Déjà en mode CPU, propager l'erreur
        rethrow;
      }
    }

    // Extraire les détections de personnes
    final detections = <BoundingBoxModel>[];
    final numDet = numDetections[0].toInt().clamp(0, 10);

    print('   Nombre de détections brutes: $numDet');

    for (int i = 0; i < numDet; i++) {
      final score = outputScores[0][i];
      final classId = outputClasses[0][i].toInt();

      print('   Détection $i: classe=$classId, score=${score.toStringAsFixed(2)}');

      // Classe 0 = personne dans COCO dataset
      if (classId == 0 && score >= minConfidence) {
        // Les coordonnées sont normalisées [0, 1] dans l'ordre [ymin, xmin, ymax, xmax]
        final y1 = outputLocations[0][i][0];
        final x1 = outputLocations[0][i][1];
        final y2 = outputLocations[0][i][2];
        final x2 = outputLocations[0][i][3];

        detections.add(BoundingBoxModel(
          x: x1.clamp(0.0, 1.0),
          y: y1.clamp(0.0, 1.0),
          width: (x2 - x1).clamp(0.0, 1.0),
          height: (y2 - y1).clamp(0.0, 1.0),
          confidence: score,
        ));

        print(
          '   ✓ Personne détectée avec confiance ${(score * 100).toStringAsFixed(1)}%',
        );
      }
    }

    return detections;
  }

  /// Convertit une image en liste de bytes uint8 pour MobileNet
  Uint8List _imageToByteListUint8(img.Image image, int size) {
    final bytes = Uint8List(1 * size * size * 3);
    int pixelIndex = 0;
    
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        final pixel = image.getPixel(x, y);
        bytes[pixelIndex++] = pixel.r.toInt();
        bytes[pixelIndex++] = pixel.g.toInt();
        bytes[pixelIndex++] = pixel.b.toInt();
      }
    }
    
    return bytes;
  }

  /// Change le modèle utilisé
  Future<void> switchModel(String model) async {
    if (_currentModel == model) return;
    
    dispose();
    await initialize(model: model);
  }

  /// Libère les ressources
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
    print(' Ressources libérées');
  }
  
  /// Vérifie si le service est initialisé
  bool get isInitialized => _isInitialized;
  
  /// Retourne le modèle actuellement utilisé
  String get currentModel => _currentModel;
}