import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/bounding_box.dart';

/// Widget moderne pour afficher l'image avec détections
class DetectionOverlay extends StatelessWidget {
  final String imagePath;
  final List<BoundingBox> detections;

  const DetectionOverlay({
    super.key,
    required this.imagePath,
    required this.detections,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),

            // Dark overlay subtil
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),

            // Bounding boxes
            CustomPaint(
              painter: _ModernDetectionPainter(detections: detections),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernDetectionPainter extends CustomPainter {
  final List<BoundingBox> detections;

  _ModernDetectionPainter({required this.detections});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < detections.length; i++) {
      final box = detections[i];

      final left = box.x * size.width;
      final top = box.y * size.height;
      final right = (box.x + box.width) * size.width;
      final bottom = (box.y + box.height) * size.height;

      final rect = Rect.fromLTRB(left, top, right, bottom);
      final color = _getColorForConfidence(box.confidence);

      // Background semi-transparent
      final bgPaint = Paint()
        ..color = color.withOpacity(0.1)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(12)),
        bgPaint,
      );

      // Bordure moderne avec coins accentués
      final borderPaint = Paint()
        ..color = color
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(12)),
        borderPaint,
      );

      // Coins accentués (design moderne)
      final cornerPaint = Paint()
        ..color = color
        ..strokeWidth = 5.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      const cornerLength = 20.0;

      // Coin supérieur gauche
      canvas.drawLine(Offset(left, top + cornerLength), Offset(left, top), cornerPaint);
      canvas.drawLine(Offset(left, top), Offset(left + cornerLength, top), cornerPaint);

      // Coin supérieur droit
      canvas.drawLine(Offset(right - cornerLength, top), Offset(right, top), cornerPaint);
      canvas.drawLine(Offset(right, top), Offset(right, top + cornerLength), cornerPaint);

      // Coin inférieur gauche
      canvas.drawLine(Offset(left, bottom - cornerLength), Offset(left, bottom), cornerPaint);
      canvas.drawLine(Offset(left, bottom), Offset(left + cornerLength, bottom), cornerPaint);

      // Coin inférieur droit
      canvas.drawLine(Offset(right - cornerLength, bottom), Offset(right, bottom), cornerPaint);
      canvas.drawLine(Offset(right, bottom), Offset(right, bottom - cornerLength), cornerPaint);

      // Label avec gradient
      final labelWidth = 85.0;
      final labelHeight = 32.0;
      final labelRect = Rect.fromLTWH(
        left,
        top - labelHeight - 8,
        labelWidth,
        labelHeight,
      );

      final labelGradient = LinearGradient(
        colors: [color, color.withOpacity(0.8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

      final labelPaint = Paint()
        ..shader = labelGradient.createShader(labelRect)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, const Radius.circular(10)),
        labelPaint,
      );

      // Shadow pour le label
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          labelRect.translate(0, 2),
          const Radius.circular(10),
        ),
        Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      // Texte de confiance
      final textPainter = TextPainter(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.verified_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: ' ${(box.confidence * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          left + (labelWidth - textPainter.width) / 2,
          top - labelHeight - 2,
        ),
      );

      // Badge de numéro moderne
      final badgeSize = 28.0;
      final badgeCenter = Offset(left + 14, top + 14);

      // Ombre du badge
      canvas.drawCircle(
        badgeCenter.translate(0, 2),
        badgeSize / 2,
        Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      // Badge background
      canvas.drawCircle(
        badgeCenter,
        badgeSize / 2,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );

      // Badge border
      canvas.drawCircle(
        badgeCenter,
        badgeSize / 2,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );

      // Numéro dans le badge
      final numberPainter = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      numberPainter.layout();
      numberPainter.paint(
        canvas,
        Offset(
          badgeCenter.dx - numberPainter.width / 2,
          badgeCenter.dy - numberPainter.height / 2,
        ),
      );
    }
  }

  Color _getColorForConfidence(double confidence) {
    if (confidence >= 0.8) {
      return AppColors.success;
    } else if (confidence >= 0.6) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }

  @override
  bool shouldRepaint(covariant _ModernDetectionPainter oldDelegate) {
    return oldDelegate.detections != detections;
  }
}