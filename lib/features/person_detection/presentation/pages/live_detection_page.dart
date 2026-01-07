import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/dependency_injection.dart';
import '../../../../core/services/tflite_service.dart';
import '../../data/models/bounding_box_model.dart';

/// Live Detection avec design moderne et fluide
class LiveDetectionPage extends ConsumerStatefulWidget {
  const LiveDetectionPage({super.key});

  @override
  ConsumerState<LiveDetectionPage> createState() => _LiveDetectionPageState();
}

class _LiveDetectionPageState extends ConsumerState<LiveDetectionPage>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isDetecting = false;
  bool _isLiveMode = false;
  
  List<BoundingBoxModel> _currentDetections = [];
  int _personCount = 0;
  double _averageConfidence = 0.0;
  
  late TFLiteService _tfliteService;
  Timer? _detectionTimer;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _tfliteService = getIt<TFLiteService>();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _initializeCamera();
  }

  @override
  void dispose() {
    _detectionTimer?.cancel();
    _cameraController?.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isEmpty) {
        _showError('Aucune caméra disponible');
        return;
      }

      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      _showError('Erreur d\'initialisation: $e');
    }
  }

  void _toggleLiveMode() {
    setState(() => _isLiveMode = !_isLiveMode);

    if (_isLiveMode) {
      _startLiveDetection();
    } else {
      _stopLiveDetection();
    }
  }

  void _startLiveDetection() {
    _detectionTimer = Timer.periodic(
      const Duration(milliseconds: 1500),
      (_) => _detectFrame(),
    );
  }

  void _stopLiveDetection() {
    _detectionTimer?.cancel();
    setState(() {
      _currentDetections = [];
      _personCount = 0;
      _averageConfidence = 0.0;
    });
  }

  Future<void> _detectFrame() async {
    if (_isDetecting || _cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() => _isDetecting = true);

    try {
      final XFile image = await _cameraController!.takePicture();

      final detections = await _tfliteService.detectPersons(
        imagePath: image.path,
        minConfidence: 0.5,
      );

      final avgConf = detections.isEmpty
          ? 0.0
          : detections.map((d) => d.confidence).reduce((a, b) => a + b) / detections.length;

      if (mounted) {
        setState(() {
          _currentDetections = detections;
          _personCount = detections.length;
          _averageConfidence = avgConf;
        });
      }

      try {
        await File(image.path).delete();
      } catch (_) {}

    } catch (e) {
      print('Erreur de détection: $e');
    } finally {
      if (mounted) {
        setState(() => _isDetecting = false);
      }
    }
  }

  Future<void> _saveCurrentCount() async {
    if (_personCount == 0) {
      _showError('Aucune personne détectée');
      return;
    }

    try {
      final XFile image = await _cameraController!.takePicture();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text('$_personCount personne(s) enregistrée(s)'),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      _showError('Erreur d\'enregistrement: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera Preview
          if (_isInitialized && _cameraController != null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            Container(
              color: AppColors.primaryNavy,
              child: Center(
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
                      'Initialisation de la caméra...',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Bounding boxes overlay
          if (_isLiveMode && _currentDetections.isNotEmpty)
            Positioned.fill(
              child: CustomPaint(
                painter: _ModernBoundingBoxPainter(
                  detections: _currentDetections,
                  imageSize: _cameraController != null
                      ? Size(
                          _cameraController!.value.previewSize!.height,
                          _cameraController!.value.previewSize!.width,
                        )
                      : Size.zero,
                ),
              ),
            ),

          // Gradient overlays
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
                    AppColors.primaryNavy.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.primaryNavy.withOpacity(0.95),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // UI Controls
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const Spacer(),
                if (_isLiveMode) _buildLiveCounter(),
                const SizedBox(height: 30),
                _buildBottomControls(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _stopLiveDetection();
                context.pop();
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.whiteOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          const Spacer(),

          // Status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: _isLiveMode
                  ? AppColors.accentBlue.withOpacity(0.2)
                  : AppColors.whiteOpacity(0.15),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: _isLiveMode
                    ? AppColors.accentBlue.withOpacity(0.5)
                    : Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _isLiveMode ? AppColors.accentBlue : AppColors.textSecondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _isLiveMode ? 'EN DIRECT' : 'PAUSE',
                  style: TextStyle(
                    color: _isLiveMode ? AppColors.accentBlue : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveCounter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentBlue.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_rounded,
                color: Colors.white,
                size: 36,
              ),
              const SizedBox(width: 16),
              Text(
                _personCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Confiance: ${(_averageConfidence * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Save button
          if (_isLiveMode && _personCount > 0) ...[
            _ModernControlButton(
              icon: Icons.bookmark_add_rounded,
              label: 'Sauver',
              onTap: _saveCurrentCount,
              color: AppColors.success,
            ),
            const SizedBox(width: 24),
          ],

          // Main control button
          ScaleTransition(
            scale: _isLiveMode ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
            child: GestureDetector(
              onTap: _toggleLiveMode,
              child: Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _isLiveMode
                      ? const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                        )
                      : AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: (_isLiveMode ? AppColors.error : AppColors.accentBlue)
                          .withOpacity(0.5),
                      blurRadius: 25,
                      spreadRadius: 3,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    Icon(
                      _isLiveMode ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (!(_isLiveMode && _personCount > 0))
            const SizedBox(width: 100),
        ],
      ),
    );
  }
}

class _ModernControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ModernControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
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

class _ModernBoundingBoxPainter extends CustomPainter {
  final List<BoundingBoxModel> detections;
  final Size imageSize;

  _ModernBoundingBoxPainter({
    required this.detections,
    required this.imageSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (imageSize.width == 0 || imageSize.height == 0) return;

    for (final detection in detections) {
      final left = detection.x * size.width;
      final top = detection.y * size.height;
      final width = detection.width * size.width;
      final height = detection.height * size.height;

      final rect = Rect.fromLTWH(left, top, width, height);

      // Bordure
      final paint = Paint()
        ..color = AppColors.accentBlue
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        paint,
      );

      // Label background
      final labelPaint = Paint()
        ..color = AppColors.accentBlue
        ..style = PaintingStyle.fill;

      final labelRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top - 30, 70, 28),
        const Radius.circular(8),
      );

      canvas.drawRRect(labelRect, labelPaint);

      // Label text
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${(detection.confidence * 100).toStringAsFixed(0)}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(left + 10, top - 24));
    }
  }

  @override
  bool shouldRepaint(covariant _ModernBoundingBoxPainter oldDelegate) {
    return oldDelegate.detections != detections;
  }
}