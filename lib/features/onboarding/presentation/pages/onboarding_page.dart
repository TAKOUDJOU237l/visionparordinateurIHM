import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';

/// Écran d'introduction avec présentation interactive
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<IntroSlide> _slides = const [
    IntroSlide(
      icon: Icons.add_a_photo_outlined,
      title: 'Importez vos images facilement',
      description:
          'Choisissez une photo depuis votre appareil ou capturez-en une nouvelle directement.',
    ),
    IntroSlide(
      icon: Icons.model_training_outlined,
      title: 'Analyse automatique avancée',
      description:
          'Un système intelligent identifie chaque individu présent sur vos photos avec fiabilité.',
    ),
    IntroSlide(
      icon: Icons.speed_outlined,
      title: 'Comptage rapide et précis',
      description:
          'Visualisez immédiatement le total de personnes détectées et consultez votre historique.',
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _finishIntroduction() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingCompleted, true);

    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  void _goToNextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishIntroduction();
    }
  }

  void _skipIntro() {
    _finishIntroduction();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _slides.length - 1;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Bouton Ignorer
            SizedBox(
              height: 56,
              child: !isLastPage
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: TextButton(
                          onPressed: _skipIntro,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          child: Text(
                            'Ignorer',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    )
                  : null,
            ),

            // Carrousel des écrans
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return _IntroSlideDisplay(slide: _slides[index]);
                },
              ),
            ),

            // Indicateurs de progression
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => _DotIndicator(
                    isActive: index == _currentPage,
                  ),
                ),
              ),
            ),

            // Bouton d'action
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: CustomButton(
                text: isLastPage ? 'Démarrer' : 'Continuer',
                onPressed: _goToNextPage,
                icon: isLastPage
                    ? Icons.rocket_launch_outlined
                    : Icons.arrow_forward_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Structure de données pour chaque écran d'introduction
class IntroSlide {
  final IconData icon;
  final String title;
  final String description;

  const IntroSlide({
    required this.icon,
    required this.title,
    required this.description,
  });
}

/// Composant d'affichage d'un écran d'introduction
class _IntroSlideDisplay extends StatelessWidget {
  final IntroSlide slide;

  const _IntroSlideDisplay({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Conteneur avec icône stylisée
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accentBlue,
                  AppColors.accentBlueLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentBlueOpacity(0.35),
                  blurRadius: 40,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                slide.icon,
                size: 90,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 72),

          // Titre principal
          Text(
            slide.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.accentBlue,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Texte descriptif
          Text(
            slide.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.7,
                  fontSize: 16,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Point indicateur de page active/inactive
class _DotIndicator extends StatelessWidget {
  final bool isActive;

  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 28 : 10,
      height: 10,
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
                colors: [
                  AppColors.accentBlue,
                  AppColors.accentBlueLight,
                ],
              )
            : null,
        color: isActive ? null : AppColors.textTertiary,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}