import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/detection_provider.dart';

/// Page d'accueil principale - Design moderne épuré avec profil utilisateur
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              // App Bar avec profil utilisateur
              SliverToBoxAdapter(
                child: _buildHeader(context, user?.fullName ?? user?.username ?? 'Utilisateur'),
              ),

              // Hero Section
              SliverToBoxAdapter(
                child: _buildHeroSection(context),
              ),

              // Quick Actions
              SliverToBoxAdapter(
                child: _buildQuickActions(context, ref),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 100), // Espace pour le bottom nav
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, user),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, user) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: Icons.home_rounded,
                label: 'Accueil',
                isSelected: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              
              _NavBarItem(
                icon: Icons.history_rounded,
                label: 'Historique',
                isSelected: _selectedIndex == 1,
                onTap: () {
                  setState(() => _selectedIndex = 1);
                  context.push(AppRoutes.history);
                },
              ),
              
              // Floating Action Button au centre
              _FloatingCameraButton(
                onTap: () => context.push(AppRoutes.camera),
              ),
              
              _NavBarItem(
                icon: Icons.settings_rounded,
                label: 'Réglages',
                isSelected: _selectedIndex == 2,
                onTap: () {
                  setState(() => _selectedIndex = 2);
                  context.push(AppRoutes.settings);
                },
              ),
              
              // Profil utilisateur dans la nav
              _NavBarProfile(
                initials: user?.initials ?? 'U',
                label: 'Profil',
                isSelected: _selectedIndex == 3,
                onTap: () {
                  setState(() => _selectedIndex = 3);
                  context.go(AppRoutes.profile);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userName) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Salutation avec nom d'utilisateur
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userName,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Logo
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentBlue.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.analytics_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Hello 👋';
    } else if (hour < 18) {
      return 'Bon après-midi 👋';
    } else {
      return 'Bonsoir 👋';
    }
  }

  Widget _buildHeroSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comptez intelligemment',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Détection instantanée du nombre de personnes sur vos photos avec l\'intelligence artificielle',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.6,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              'Actions rapides',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),

          // Live Detection Card - Featured
          _ModernActionCard(
            icon: Icons.videocam_rounded,
            title: 'Détection Live',
            subtitle: 'Comptage en temps réel',
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.accentBlue,
                AppColors.accentBlueDark,
              ],
            ),
            onTap: () => context.push('/live-detection'),
            isFeatured: true,
          ),

          const SizedBox(height: 12),

          // Two column layout for other actions
          Row(
            children: [
              Expanded(
                child: _CompactActionCard(
                  icon: Icons.camera_alt_rounded,
                  title: 'Capture',
                  onTap: () => context.push(AppRoutes.camera),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CompactActionCard(
                  icon: Icons.photo_library_rounded,
                  title: 'Galerie',
                  onTap: () => _pickFromGallery(context, ref),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromGallery(BuildContext context, WidgetRef ref) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: AppColors.accentBlue,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Analyse...',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await ref.read(detectionNotifierProvider.notifier).detectPersons(
          image.path,
          minConfidence: 0.5,
        );

        if (context.mounted) Navigator.of(context).pop();

        final state = ref.read(detectionNotifierProvider);

        if (state is DetectionSuccess) {
          if (context.mounted) {
            context.push(
              AppRoutes.result,
              extra: {'result': state.result},
            );
          }
        } else if (state is DetectionError) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accentBlue.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.accentBlue : AppColors.textSecondary,
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.accentBlue : AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarProfile extends StatelessWidget {
  final String initials;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarProfile({
    required this.initials,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accentBlue.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: isSelected 
                      ? AppColors.primaryGradient 
                      : LinearGradient(
                          colors: [
                            AppColors.textSecondary,
                            AppColors.textSecondary.withOpacity(0.8),
                          ],
                        ),
                  shape: BoxShape.circle,
                  border: isSelected 
                      ? Border.all(color: AppColors.accentBlue, width: 2)
                      : null,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.accentBlue : AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingCameraButton extends StatelessWidget {
  final VoidCallback onTap;

  const _FloatingCameraButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.accentBlue.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.camera_alt_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.divider,
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.accentBlue,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _ModernActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;
  final bool isFeatured;

  const _ModernActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentBlue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _CompactActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.divider,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.accentBlue,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}