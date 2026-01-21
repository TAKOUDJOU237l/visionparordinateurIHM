import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import vos pages existantes
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/person_detection/presentation/pages/home_page.dart';
import '../../features/person_detection/presentation/pages/camera_page.dart';
import '../../features/person_detection/presentation/pages/result_page.dart';
import '../../features/person_detection/presentation/pages/history_page.dart';
import '../../features/person_detection/presentation/pages/settings_page.dart';
import '../../features/person_detection/presentation/pages/live_detection_page.dart';

// Import les nouvelles pages d'authentification
import '../../features/person_detection/presentation/pages/login_page.dart';
import '../../features/person_detection/presentation/pages/signup_page.dart';
import '../../features/person_detection/presentation/pages/profile_page.dart';
import '../../features/person_detection/presentation/providers/auth_provider.dart';
import '../../features/person_detection/domain/entities/auth_state.dart';

import '../theme/app_colors.dart';

/// Provider pour le router de l'application avec authentification
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    
    // Redirection pour gérer l'authentification
    redirect: (context, state) {
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isLoading = authState.status == AuthStatus.loading;
      final location = state.matchedLocation;
      
      // Si l'état est en chargement, ne pas rediriger
      if (isLoading) {
        return null;
      }
      
      // Pages publiques (accessibles sans authentification)
      final publicRoutes = [
        AppRoutes.splash,
        AppRoutes.onboarding,
        AppRoutes.login,
        AppRoutes.signup,
      ];
      
      final isPublicRoute = publicRoutes.contains(location);

      // Si on est sur splash ou onboarding, on laisse passer
      if (location == AppRoutes.splash || location == AppRoutes.onboarding) {
        return null;
      }

      // Si authentifié et sur login/signup, rediriger vers home
      if (isAuthenticated && (location == AppRoutes.login || location == AppRoutes.signup)) {
        return AppRoutes.home;
      }

      // Si pas authentifié et pas sur une page publique, rediriger vers login
      if (!isAuthenticated && !isPublicRoute) {
        return AppRoutes.login;
      }

      return null;
    },

    routes: [
      // Onboarding
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

      // Authentification
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),

      // Application principale (nécessite authentification)
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
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
        path: AppRoutes.liveDetection,
        name: 'liveDetection',
        builder: (context, state) => const LiveDetectionPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    
    errorBuilder: (context, state) => ErrorPage(
      message: state.error?.toString() ?? 'Erreur inconnue',
    ),
  );
});

/// Routes de l'application
class AppRoutes {
  AppRoutes._();

  // Onboarding
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  
  // Authentification
  static const String login = '/login';
  static const String signup = '/signup';
  
  // Application
  static const String home = '/home';
  static const String profile = '/profile';
  static const String camera = '/camera';
  static const String result = '/result';
  static const String history = '/history';
  static const String liveDetection = '/live-detection';
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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