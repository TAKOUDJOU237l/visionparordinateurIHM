import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/person_detection/presentation/pages/home_page.dart';
import '../../features/person_detection/presentation/pages/camera_page.dart';
import '../../features/person_detection/presentation/pages/result_page.dart';
import '../../features/person_detection/presentation/pages/history_page.dart';
import '../../features/person_detection/presentation/pages/settings_page.dart';
import '../../features/person_detection/presentation/pages/live_detection_page.dart';

import '../theme/app_colors.dart';

/// Provider pour le router de l'application
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.camera,
        name: 'camera',
        builder: (context, state) => const CameraPage(),
      ),
      GoRoute(
        path: AppRoutes.result,
        name: 'result',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final result = extra?['result'];
          if (result == null) {
            return const ErrorPage(message: 'Résultat de détection non trouvé');
          }
          return ResultPage(result: result);
        },
      ),
      GoRoute(
        path: AppRoutes.history,
        name: 'history',
        builder: (context, state) => const HistoryPage(),
      ),

      GoRoute(
        path: '/live-detection',
        name: 'liveDetection',
        builder: (context, state) => const LiveDetectionPage(),
      ),
      
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(message: state.error?.toString() ?? 'Erreur inconnue'),
  );
});

/// Routes de l'application
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String camera = '/camera';
  static const String result = '/result';
  static const String history = '/history';
  static const String settings = '/settings';
}

/// Page d'erreur
class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({
    super.key,
    this.message = 'Une erreur est survenue',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 80,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              const Text(
                'Erreur',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white10,
                ),
                child: const Text('Retour à l\'accueil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
