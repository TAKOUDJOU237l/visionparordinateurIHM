import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authStateProvider.notifier).signup(
            email: _emailController.text.trim(),
            username: _usernameController.text.trim(),
            password: _passwordController.text,
            fullName: _fullNameController.text.trim().isEmpty
                ? null
                : _fullNameController.text.trim(),
          );

      if (mounted) {
        // Attendre un peu pour que l'état soit bien mis à jour
        await Future.delayed(const Duration(milliseconds: 100));
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(e.toString().replaceAll('Exception: ', ''))),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        
                        // Logo et titre
                        _buildHeader(),
                        
                        const SizedBox(height: 40),

                        // Formulaire dans une carte
                        _buildFormCard(),
                        
                        const SizedBox(height: 24),

                        // Lien vers connexion
                        _buildLoginLink(),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo avec animation
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentBlue.withOpacity(0.4),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.person_add_rounded,
            size: 45,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Rejoignez-nous',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Créez votre compte HeadCount',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Email
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'kennefranck@gmail.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email requis';
              }
              if (!value.contains('@')) {
                return 'Email invalide';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Username
          CustomTextField(
            controller: _usernameController,
            label: 'Nom d\'utilisateur',
            hint: 'username',
            prefixIcon: Icons.alternate_email_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nom d\'utilisateur requis';
              }
              if (value.length < 3) {
                return 'Minimum 3 caractères';
              }
              if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                return 'Lettres, chiffres et _ uniquement';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Full Name (optionnel)
          CustomTextField(
            controller: _fullNameController,
            label: 'Nom complet (optionnel)',
            hint: 'Kenne Franck',
            prefixIcon: Icons.badge_outlined,
          ),
          const SizedBox(height: 16),

          // Password
          CustomTextField(
            controller: _passwordController,
            label: 'Mot de passe',
            hint: '••••••••',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mot de passe requis';
              }
              if (value.length < 8) {
                return 'Minimum 8 caractères';
              }
              if (!value.contains(RegExp(r'[A-Z]'))) {
                return 'Au moins une majuscule';
              }
              if (!value.contains(RegExp(r'[a-z]'))) {
                return 'Au moins une minuscule';
              }
              if (!value.contains(RegExp(r'[0-9]'))) {
                return 'Au moins un chiffre';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm Password
          CustomTextField(
            controller: _confirmPasswordController,
            label: 'Confirmer le mot de passe',
            hint: '••••••••',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirmation requise';
              }
              if (value != _passwordController.text) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Bouton d'inscription
          CustomButton(
            text: 'Créer mon compte',
            onPressed: _isLoading ? null : _handleSignup,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Déjà membre ? ',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          GestureDetector(
            onTap: () => context.go(AppRoutes.login),
            child: Text(
              'Se connecter',
              style: TextStyle(
                color: AppColors.accentBlue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}