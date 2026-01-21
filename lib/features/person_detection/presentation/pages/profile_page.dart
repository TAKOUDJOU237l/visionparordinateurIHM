import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _fullNameController;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider).user;
    _usernameController = TextEditingController(text: user?.username ?? '');
    _fullNameController = TextEditingController(text: user?.fullName ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authStateProvider).user;
      final usernameChanged = _usernameController.text.trim() != user?.username;
      final fullNameChanged = _fullNameController.text.trim() != user?.fullName;

      if (usernameChanged || fullNameChanged) {
        await ref.read(authStateProvider.notifier).updateProfile(
              username: usernameChanged ? _usernameController.text.trim() : null,
              fullName: fullNameChanged ? _fullNameController.text.trim() : null,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Text('Profil mis à jour avec succès'),
                ],
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          setState(() => _isEditing = false);
        }
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

  Future<void> _handleChangePassword() async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.cardDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.lock_reset, color: AppColors.accentBlue, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Changer le mot de passe',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: currentPasswordController,
                  label: 'Mot de passe actuel',
                  hint: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  obscureText: obscureCurrent,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureCurrent ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setDialogState(() => obscureCurrent = !obscureCurrent);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: newPasswordController,
                  label: 'Nouveau mot de passe',
                  hint: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  obscureText: obscureNew,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureNew ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setDialogState(() => obscureNew = !obscureNew);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: confirmPasswordController,
                  label: 'Confirmer',
                  hint: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  obscureText: obscureConfirm,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setDialogState(() => obscureConfirm = !obscureConfirm);
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (newPasswordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Les mots de passe ne correspondent pas'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                try {
                  await ref.read(authStateProvider.notifier).changePassword(
                        currentPassword: currentPasswordController.text,
                        newPassword: newPasswordController.text,
                      );

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Mot de passe changé avec succès'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString().replaceAll('Exception: ', '')),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: Colors.white,
              ),
              child: Text('Confirmer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.logout, color: AppColors.error, size: 20),
            ),
            const SizedBox(width: 12),
            Text('Déconnexion', style: TextStyle(color: AppColors.textPrimary)),
          ],
        ),
        content: Text(
          'Voulez-vous vraiment vous déconnecter ?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Annuler', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authStateProvider.notifier).logout();
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('Aucun utilisateur connecté', style: TextStyle(color: AppColors.textPrimary)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.accentBlue),
                  onPressed: () => context.pop(),
                ),
                title: Text('Mon Profil', style: TextStyle(color: AppColors.textPrimary)),
                actions: [
                  if (!_isEditing)
                    IconButton(
                      icon: Icon(Icons.edit_rounded, color: AppColors.accentBlue),
                      onPressed: () => setState(() => _isEditing = true),
                    ),
                ],
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Avatar avec gradient
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentBlue.withOpacity(0.4),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              user.initials,
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Email (non modifiable)
                        _buildInfoCard(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user.email,
                        ),
                        const SizedBox(height: 16),

                        // Username
                        CustomTextField(
                          controller: _usernameController,
                          label: 'Nom d\'utilisateur',
                          prefixIcon: Icons.alternate_email_rounded,
                          enabled: _isEditing,
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

                        // Full Name
                        CustomTextField(
                          controller: _fullNameController,
                          label: 'Nom complet',
                          prefixIcon: Icons.badge_outlined,
                          enabled: _isEditing,
                        ),
                        const SizedBox(height: 32),

                        // Boutons d'action
                        if (_isEditing) ...[
                          CustomButton(
                            text: 'Enregistrer',
                            onPressed: _isLoading ? null : _handleUpdateProfile,
                            isLoading: _isLoading,
                          ),
                          const SizedBox(height: 12),
                          _buildOutlinedButton(
                            text: 'Annuler',
                            icon: Icons.close_rounded,
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                                _usernameController.text = user.username;
                                _fullNameController.text = user.fullName ?? '';
                              });
                            },
                          ),
                        ] else ...[
                          _buildOutlinedButton(
                            text: 'Changer le mot de passe',
                            icon: Icons.lock_reset,
                            onPressed: _handleChangePassword,
                            color: AppColors.accentBlue,
                          ),
                          const SizedBox(height: 12),
                          _buildOutlinedButton(
                            text: 'Se déconnecter',
                            icon: Icons.logout_rounded,
                            onPressed: _handleLogout,
                            color: AppColors.error,
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Info compte
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardDark.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 8),
                              Text(
                                'Membre depuis ${_formatDate(user.createdAt)}',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.accentBlue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    final buttonColor = color ?? AppColors.textSecondary;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: buttonColor,
        side: BorderSide(color: buttonColor, width: 1.5),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}