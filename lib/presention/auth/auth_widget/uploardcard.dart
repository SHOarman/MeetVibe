import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';
import '../auth_controller/authcontroller.dart';

class UploadCard extends StatelessWidget {
  const UploadCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Authcontroller controller = Get.find<Authcontroller>();

    const commonGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xffEC6D43),
        Color(0xffFFB670),
      ],
    );

    return Obx(() {
      final hasImage = controller.imagePath.value.isNotEmpty;

      return GestureDetector(
        onTap: () => _showSourceSelectionSheet(context, controller),
        child: Container(
          width: 370,
          height: 151,
          decoration: BoxDecoration(
            color: const Color(0xffF9FAFB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomPaint(
            painter: DashedGradientBorderPainter(
              gradient: commonGradient,
              strokeWidth: 2,
              borderRadius: 8,
              dashWidth: 5,
              dashSpace: 5,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: hasImage
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        kIsWeb
                            ? Image.network(
                                controller.imagePath.value,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(controller.imagePath.value),
                                fit: BoxFit.cover,
                              ),
                        Container(
                          color: Colors.black.withValues(alpha: 0.4),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white24,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                                  onPressed: () {
                                    controller.clearImage();
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Tap to change image",
                                style: AppTextStyle.inter(
                                  size: 14,
                                  weight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => commonGradient.createShader(bounds),
                            child: const Icon(
                              Icons.file_upload_outlined,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Click to upload",
                            style: AppTextStyle.inter(
                              size: 16,
                              weight: FontWeight.w600,
                              color: const Color(0xffEC6D43),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Make sure all details are visible and not blurry",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.inter(
                              size: 12,
                              weight: FontWeight.w400,
                              color: Colors.grey[600]!,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      );
    });
  }

  void _showSourceSelectionSheet(BuildContext context, Authcontroller controller) {
    const commonGradient = LinearGradient(
      colors: [Color(0xffEC6D43), Color(0xffFFB670)],
    );

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                "Upload Government ID",
                style: AppTextStyle.inter(
                  size: 18,
                  weight: FontWeight.w600,
                  color: Appcolors.black,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFF3E8),
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) => commonGradient.createShader(bounds),
                    child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                  ),
                ),
                title: Text(
                  "Take a Photo",
                  style: AppTextStyle.inter(size: 15, weight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFF3E8),
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) => commonGradient.createShader(bounds),
                    child: const Icon(Icons.photo_library_outlined, color: Colors.white),
                  ),
                ),
                title: Text(
                  "Choose from Gallery",
                  style: AppTextStyle.inter(size: 15, weight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class DashedGradientBorderPainter extends CustomPainter {
  final LinearGradient gradient;
  final double strokeWidth;
  final double borderRadius;
  final double dashWidth;
  final double dashSpace;

  DashedGradientBorderPainter({
    required this.gradient,
    this.strokeWidth = 2.0,
    this.borderRadius = 8.0,
    this.dashWidth = 5.0,
    this.dashSpace = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(rect);

    final RRect rrect = RRect.fromRectAndRadius(
      rect.deflate(strokeWidth / 2),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = _buildDashedPath(path, dashWidth, dashSpace);

    canvas.drawPath(dashedPath, paint);
  }

  Path _buildDashedPath(Path source, double dashWidth, double dashSpace) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = draw ? dashWidth : dashSpace;
        if (distance + len >= metric.length) {
          if (draw) {
            dest.addPath(
              metric.extractPath(distance, metric.length),
              Offset.zero,
            );
          }
          break;
        }
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant DashedGradientBorderPainter oldDelegate) {
    return oldDelegate.gradient != gradient ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}
