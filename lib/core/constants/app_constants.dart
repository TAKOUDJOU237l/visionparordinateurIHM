/// Constantes globales de l'application SmartHeadCount
class AppConstants {
  AppConstants._();

  // Application Info
  static const String appName = 'SmartHeadCount';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Application de comptage automatique de personnes par intelligence artificielle';

  // API & Network
  static const String baseUrl = 'https://api.smartheadcount.com';
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds

  // Local Storage Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyFirstLaunch = 'first_launch';

  // Detection Settings
  static const double minConfidenceThreshold = 0.5;
  static const double defaultConfidenceThreshold = 0.7;
  static const int maxDetectionsPerImage = 100;

  // Camera Settings
  static const int imageQuality = 90;
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 2.0;

  // Animation Durations
  static const int shortAnimationDuration = 200; // milliseconds
  static const int mediumAnimationDuration = 400; // milliseconds
  static const int longAnimationDuration = 600; // milliseconds

  // Supported Languages
  static const List<String> supportedLanguages = ['fr', 'en'];

  // Error Messages
  static const String errorGeneric = 'Une erreur est survenue';
  static const String errorNetwork = 'Erreur de connexion réseau';
  static const String errorPermission = 'Permission refusée';
  static const String errorCameraNotAvailable = 'Caméra non disponible';
  static const String errorImageProcessing =
      'Erreur lors du traitement de l\'image';

  // Success Messages
  static const String successDetection = 'Détection effectuée avec succès';
  static const String successSave = 'Sauvegarde réussie';

  // Model Files
  static const String modelFileName = 'person_detection_model.tflite';
  static const String modelLabelsFileName = 'labels.txt';
}
