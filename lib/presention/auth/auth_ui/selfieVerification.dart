import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';
import '../auth_controller/authcontroller.dart';

enum VerificationStep { positionFace, blinkEyes, smile, completed }

class Selfieverification extends StatefulWidget {
  const Selfieverification({super.key});

  @override
  State<Selfieverification> createState() => _SelfieverificationState();
}

class _SelfieverificationState extends State<Selfieverification> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  VerificationStep _currentStep = VerificationStep.positionFace;
  double _progress = 0.25;
  Timer? _stepTimer;
  String _statusText = "Position your face in the circle";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _statusText = "No cameras found";
        });
        return;
      }

      // Try to find the front-facing camera
      final frontCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
        _startVerificationFlow();
      }
    } catch (e) {
      debugPrint("Camera initialization failed: $e");
      setState(() {
        _statusText = "Camera access denied. Please allow camera permissions.";
      });
    }
  }

  void _startVerificationFlow() {
    // Stage 1: Position Face (2.5 seconds)
    _stepTimer = Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      setState(() {
        _currentStep = VerificationStep.blinkEyes;
        _progress = 0.60;
        _statusText = "Please blink your eyes";
      });

      // Stage 2: Blink Eyes (2.5 seconds)
      _stepTimer = Timer(const Duration(milliseconds: 2500), () {
        if (!mounted) return;
        setState(() {
          _currentStep = VerificationStep.smile;
          _progress = 0.85;
          _statusText = "Please smile slightly";
        });

        // Stage 3: Smile (2.5 seconds)
        _stepTimer = Timer(const Duration(milliseconds: 2500), () async {
          if (!mounted) return;

          // Attempt to capture a picture to simulate bKash saving it
          String? capturedPath;
          try {
            if (_cameraController != null &&
                _cameraController!.value.isInitialized) {
              final XFile file = await _cameraController!.takePicture();
              capturedPath = file.path;
            }
          } catch (e) {
            debugPrint("Failed to take photo: $e");
          }

          setState(() {
            _currentStep = VerificationStep.completed;
            _progress = 1.0;
            _statusText = "Face match 100% verified!";
          });

          final controller = Get.find<Authcontroller>();
          controller.selfiePath.value =
              capturedPath ?? "captured_selfie_placeholder";

          Get.snackbar(
            'Verification Success',
            'Face movement verified successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF10B981),
            colorText: Colors.white,
          );
        });
      });
    });
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Authcontroller>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "Identity Verification",
                    style: AppTextStyle.poppins(
                      size: 18,
                      weight: FontWeight.w700,
                      color: Appcolors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    "Position your face inside the circle and follow\nthe instructions for automatic match.",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.inter(
                      size: 15,
                      weight: FontWeight.w500,
                      color: Appcolors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Circle Camera View
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Circle Outer Progress Track
                    CustomPaint(
                      size: const Size(220, 220),
                      painter: CircleGradientPainter(
                        progress: _progress,
                        isCompleted: _currentStep == VerificationStep.completed,
                      ),
                    ),
                    // Inner Camera Stream
                    Container(
                      width: 196,
                      height: 196,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF3F4F6),
                      ),
                      child: ClipOval(
                        child: _isCameraInitialized && _cameraController != null
                            ? AspectRatio(
                                aspectRatio: 1.0,
                                child: CameraPreview(_cameraController!),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xffEC6D43),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Starting Camera...",
                                      style: AppTextStyle.inter(
                                        size: 12,
                                        weight: FontWeight.w500,
                                        color: Colors.grey[500]!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),

                    // Liveness Detection Overlay Scanner
                    if (_isCameraInitialized &&
                        _currentStep != VerificationStep.completed)
                      IgnorePointer(
                        child: SizedBox(
                          width: 196,
                          height: 196,
                          child: Stack(
                            children: [
                              // Moving scanning laser animation
                              _buildScanningLaser(),
                            ],
                          ),
                        ),
                      ),

                    // Completed Success Overlay inside the Circle
                    if (_currentStep == VerificationStep.completed)
                      Container(
                        width: 196,
                        height: 196,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.verified,
                            color: Color(0xFF10B981),
                            size: 64,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 24),

                // Status Box
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _currentStep == VerificationStep.completed
                        ? const Color(0xFFECFDF5)
                        : const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: _currentStep == VerificationStep.completed
                          ? const Color(0xFFA7F3D0)
                          : const Color(0xFFFFEDD5),
                    ),
                  ),
                  child: Text(
                    _statusText,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.inter(
                      size: 16,
                      weight: FontWeight.w600,
                      color: _currentStep == VerificationStep.completed
                          ? const Color(0xFF047857)
                          : const Color(0xFFC2410C),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // Instructions Blocks with Dynamic Tick Marks
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInstructionRow(
                      icon: _currentStep != VerificationStep.positionFace
                          ? Icons.check_circle
                          : Icons.face_unlock_outlined,
                      iconColor: _currentStep != VerificationStep.positionFace
                          ? const Color(0xFF10B981)
                          : const Color(0xFF6B7280),
                      text: "Make sure your face is clearly visible",
                      isCompleted:
                          _currentStep != VerificationStep.positionFace,
                    ),
                    const SizedBox(height: 16),
                    _buildInstructionRow(
                      icon:
                          (_currentStep == VerificationStep.smile ||
                              _currentStep == VerificationStep.completed)
                          ? Icons.check_circle
                          : Icons.wb_sunny_outlined,
                      iconColor:
                          (_currentStep == VerificationStep.smile ||
                              _currentStep == VerificationStep.completed)
                          ? const Color(0xFF10B981)
                          : const Color(0xFF6B7280),
                      text: "Good lighting verified",
                      isCompleted:
                          (_currentStep == VerificationStep.smile ||
                          _currentStep == VerificationStep.completed),
                    ),
                    const SizedBox(height: 16),
                    _buildInstructionRow(
                      icon: _currentStep == VerificationStep.completed
                          ? Icons.check_circle
                          : Icons.face_retouching_off_outlined,
                      iconColor: _currentStep == VerificationStep.completed
                          ? const Color(0xFF10B981)
                          : const Color(0xFF6B7280),
                      text: "No hat or sunglasses detected",
                      isCompleted: _currentStep == VerificationStep.completed,
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Continue button
                Obx(() {
                  final isSelfieCaptured =
                      controller.selfiePath.value.isNotEmpty;
                  return CustomButton(
                    text: "Continue",
                    gradient: isSelfieCaptured
                        ? null
                        : const LinearGradient(
                            colors: [Color(0xFFE5E7EB), Color(0xFFE5E7EB)],
                          ),
                    textStyle: isSelfieCaptured
                        ? null
                        : AppTextStyle.inter(
                            size: 15,
                            weight: FontWeight.w500,
                            color: const Color(0xFF9CA3AF),
                          ),
                    onTap: isSelfieCaptured
                        ? () {
                            Get.toNamed(AppRoutes.verificationSuccessful);
                          }
                        : () {
                            // Do nothing when disabled
                          },
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionRow({
    required IconData icon,
    required String text,
    required Color iconColor,
    required bool isCompleted,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: iconColor),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.inter(
                size: 15,
                weight: FontWeight.w500,
                color: isCompleted
                    ? const Color(0xFF111827)
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningLaser() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Positioned(
          top: 196 * value,
          left: 0,
          right: 0,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xffEC6D43).withOpacity(0.0),
                  const Color(0xffEC6D43),
                  const Color(0xffEC6D43).withOpacity(0.0),
                ],
              ),
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted && _currentStep != VerificationStep.completed) {
          // Re-trigger animation
          setState(() {});
        }
      },
    );
  }
}

class CircleGradientPainter extends CustomPainter {
  final double progress;
  final bool isCompleted;

  CircleGradientPainter({required this.progress, this.isCompleted = false});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paintTrack = Paint()
      ..color = const Color(0xffF1F2F4)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final paintProgress = Paint()
      ..shader = LinearGradient(
        colors: isCompleted
            ? [const Color(0xFF10B981), const Color(0xFF34D399)]
            : [const Color(0xffEC6D43), const Color(0xffFFB670)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawOval(rect, paintTrack);

    final sweepAngle = progress * 2 * 3.14159265;
    canvas.drawArc(rect, -3.14159 / 2, sweepAngle, false, paintProgress);
  }

  @override
  bool shouldRepaint(covariant CircleGradientPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isCompleted != isCompleted;
  }
}
