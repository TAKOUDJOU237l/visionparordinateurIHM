import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/detection_provider.dart';

/// Page de capture d'image avec la caméra - Design moderne
class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({super.key});

  @override
  ConsumerState<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isProcessing = false;
  FlashMode _currentFlashMode = FlashMode.off;
  int _currentCameraIndex = 0;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    
    // Animation de pulsation pour le bouton capture
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isEmpty) {
        _showError(AppConstants.errorCameraNotAvailable);
        return;
      }

      if (_currentCameraIndex >= _cameras!.length) {
        _currentCameraIndex = 0;
      }

      _controller = CameraController(
        _cameras![_currentCameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      _showError('Erreur d\'initialisation: $e');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) {
      _showError('Aucune autre caméra disponible');
      return;
    }

    setState(() => _isInitialized = false);
    await _controller?.dispose();
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras!.length;
    await _initializeCamera();

    final cameraType = _cameras![_currentCameraIndex].lensDirection == 
        CameraLensDirection.front ? 'avant' : 'arrière';
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text('Caméra $cameraType activée'),
            ],
          ),
          duration: const Duration(milliseconds: 1200),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.accentBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isProcessing) {
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final image = await _controller!.takePicture();

      if (mounted) {
        await ref.read(detectionNotifierProvider.notifier).detectPersons(image.path);
        final state = ref.read(detectionNotifierProvider);

        if (state is DetectionSuccess) {
          if (mounted) {
            context.pushReplacement(
              AppRoutes.result,
              extra: {'result': state.result},
            );
          }
        } else if (state is DetectionError) {
          _showError(state.message);
        }
      }
    } catch (e) {
      _showError(AppConstants.errorImageProcessing);
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isProcessing = true);

    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        setState(() => _isProcessing = false);
        return;
      }

      if (mounted) {
        await ref.read(detectionNotifierProvider.notifier).detectPersons(image.path);
        final state = ref.read(detectionNotifierProvider);

        if (state is DetectionSuccess) {
          if (mounted) {
            context.pushReplacement(
              AppRoutes.result,
              extra: {'result': state.result},
            );
          }
        } else if (state is DetectionError) {
          _showError(state.message);
        }
      }
    } catch (e) {
      _showError(AppConstants.errorImageProcessing);
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;

    if (_cameras![_currentCameraIndex].lensDirection == CameraLensDirection.front) {
      _showError('Flash non disponible sur caméra avant');
      return;
    }

    try {
      final newMode = _currentFlashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
      await _controller!.setFlashMode(newMode);
      setState(() => _currentFlashMode = newMode);
    } catch (e) {
      _showError('Erreur du flash: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  bool get _isBackCamera => 
    _cameras != null && 
    _currentCameraIndex < _cameras!.length && 
    _cameras![_currentCameraIndex].lensDirection == CameraLensDirection.back;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      body: Stack(
        children: [
          // Camera Preview avec coins arrondis
          if (_isInitialized && _controller != null)
            Positioned.fill(
              child: ClipRRect(
                child: CameraPreview(_controller!),
              ),
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      color: AppColors.accentBlue,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Initialisation...',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Gradient overlay subtil en haut
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryNavy.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Gradient overlay subtil en bas
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.primaryNavy.withOpacity(0.9),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Controls
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const Spacer(),
                if (_isInitialized) _buildCameraIndicator(),
                const SizedBox(height: 24),
                _buildBottomControls(),
                const SizedBox(height: 40),
              ],
            ),
          ),

          // Processing Overlay avec animation moderne
          if (_isProcessing)
            Container(
              color: AppColors.primaryNavy.withOpacity(0.95),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            color: AppColors.accentBlue,
                            strokeWidth: 4,
                          ),
                        ),
                        Icon(
                          Icons.psychology,
                          color: AppColors.accentBlue,
                          size: 40,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Analyse en cours',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Détection des personnes...',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Back Button moderne
          _TopBarButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => context.pop(),
          ),

          const Spacer(),

          // Switch Camera
          if (_cameras != null && _cameras!.length > 1) ...[
            _TopBarButton(
              icon: Icons.flip_camera_ios_rounded,
              onTap: _switchCamera,
              isActive: true,
            ),
            const SizedBox(width: 12),
          ],

          // Flash Toggle
          _TopBarButton(
            icon: _currentFlashMode == FlashMode.off
                ? Icons.flash_off_rounded
                : Icons.flash_on_rounded,
            onTap: _isBackCamera ? _toggleFlash : null,
            isActive: _currentFlashMode != FlashMode.off,
            isDisabled: !_isBackCamera,
          ),
        ],
      ),
    );
  }

  Widget _buildCameraIndicator() {
    final isBackCamera = _isBackCamera;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.accentBlue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.accentBlue.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.accentBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isBackCamera ? Icons.camera_rear_rounded : Icons.camera_front_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            isBackCamera ? 'Vue arrière' : 'Vue avant',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gallery Button
          _BottomActionButton(
            icon: Icons.photo_library_rounded,
            label: 'Galerie',
            onTap: _pickFromGallery,
          ),

          // Capture Button avec animation
          ScaleTransition(
            scale: _pulseAnimation,
            child: GestureDetector(
              onTap: _takePicture,
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accentBlue,
                      AppColors.accentBlueDark,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentBlue.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Spacer pour symétrie
          const SizedBox(width: 80),
        ],
      ),
    );
  }
}

/// Bouton de la barre supérieure
class _TopBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isActive;
  final bool isDisabled;

  const _TopBarButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive 
                ? AppColors.accentBlue.withOpacity(0.2)
                : AppColors.whiteOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive 
                  ? AppColors.accentBlue.withOpacity(0.4)
                  : Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Icon(
            icon,
            color: isDisabled
                ? AppColors.textSecondary.withOpacity(0.3)
                : (isActive ? AppColors.accentBlue : Colors.white),
            size: 22,
          ),
        ),
      ),
    );
  }
}

/// Bouton d'action du bas
class _BottomActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomActionButton({
    required this.icon,
    required this.label,
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
          width: 80,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.whiteOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}