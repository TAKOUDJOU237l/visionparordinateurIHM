import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Bouton moderne avec animations et gradient
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSecondary;
  final IconData? icon;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.icon,
    this.width,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSecondary) {
      return _buildSecondaryButton();
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: widget.onPressed != null && !widget.isLoading
            ? _handleTapDown
            : null,
        onTapUp: widget.onPressed != null && !widget.isLoading
            ? _handleTapUp
            : null,
        onTapCancel: _handleTapCancel,
        onTap: widget.onPressed != null && !widget.isLoading
            ? widget.onPressed
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width ?? double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
          decoration: BoxDecoration(
            gradient: widget.onPressed != null && !widget.isLoading
                ? AppColors.primaryGradient
                : LinearGradient(
                    colors: [
                      AppColors.divider,
                      AppColors.divider,
                    ],
                  ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: widget.onPressed != null && !widget.isLoading && !_isPressed
                ? [
                    BoxShadow(
                      color: AppColors.accentBlue.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: widget.onPressed != null && !widget.isLoading
            ? _handleTapDown
            : null,
        onTapUp: widget.onPressed != null && !widget.isLoading
            ? _handleTapUp
            : null,
        onTapCancel: _handleTapCancel,
        onTap: widget.onPressed != null && !widget.isLoading
            ? widget.onPressed
            : null,
        child: Container(
          width: widget.width ?? double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.onPressed != null && !widget.isLoading
                  ? AppColors.accentBlue
                  : AppColors.divider,
              width: 2,
            ),
          ),
          child: _buildContent(isSecondary: true),
        ),
      ),
    );
  }

  Widget _buildContent({bool isSecondary = false}) {
    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              isSecondary ? AppColors.accentBlue : Colors.white,
            ),
          ),
        ),
      );
    }

    final contentColor = isSecondary
        ? (widget.onPressed != null ? AppColors.accentBlue : AppColors.textSecondary)
        : Colors.white;

    if (widget.icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.icon,
            size: 22,
            color: contentColor,
          ),
          const SizedBox(width: 12),
          Text(
            widget.text,
            style: TextStyle(
              color: contentColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      );
    }

    return Center(
      child: Text(
        widget.text,
        style: TextStyle(
          color: contentColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Petit bouton iconique
class IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;

  const IconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 4),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: (color ?? AppColors.accentBlue).withOpacity(0.15),
            borderRadius: BorderRadius.circular(size / 4),
            border: Border.all(
              color: (color ?? AppColors.accentBlue).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Icon(
            icon,
            color: color ?? AppColors.accentBlue,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}

/// Bouton flottant moderne
class FloatingActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  const FloatingActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  @override
  State<FloatingActionButton> createState() => _FloatingActionButtonState();
}

class _FloatingActionButtonState extends State<FloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onPressed,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.accentBlue.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              Icon(
                widget.icon,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}