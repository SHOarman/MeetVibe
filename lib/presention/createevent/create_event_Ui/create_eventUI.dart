import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/customnavigator_button.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

import 'basic_Info.dart';
import 'dateTime.dart';
import 'location.dart';
import 'details.dart';
import 'review.dart';
import 'package:meetvibe/presention/createevent/create_event_controller/create_controller.dart';

class CreateEventui extends StatefulWidget {
  const CreateEventui({super.key});

  @override
  State<CreateEventui> createState() => _CreateEventuiState();
}

class _CreateEventuiState extends State<CreateEventui> {
  int _currentStep = 0;

  @override
  void dispose() {
    Get.delete<CreateController>();
    super.dispose();
  }

  final List<String> _stepTitles = [
    "Basic Info",
    "Date & Time",
    "Location",
    "Details",
    "Review",
  ];

  Widget _getStepWidget() {
    switch (_currentStep) {
      case 0:
        return const BasicInfoStep();
      case 1:
        return const DateTimeStep();
      case 2:
        return const LocationStep();
      case 3:
        return const DetailsStep();
      case 4:
        return ReviewStep(
          onEditTap: () {
            setState(() {
              _currentStep = 3;
            });
          },
          onPublishTap: _nextStep,
        );
      default:
        return const BasicInfoStep();
    }
  }

  void _nextStep() async {
    final createController = Get.isRegistered<CreateController>() ? Get.find<CreateController>() : Get.put(CreateController());
    
    if (_currentStep == 0) {
      final success = await createController.submitStep1();
      if (!success) return;
    } else if (_currentStep == 1) {
      final success = await createController.submitStep2();
      if (!success) return;
    } else if (_currentStep == 2) {
      final success = await createController.submitStep3();
      if (!success) return;
    } else if (_currentStep == 3) {
      final success = await createController.submitStep4();
      if (!success) return;
    } else if (_currentStep == 4) {
      final success = await createController.publishEvent();
      if (!success) return;
    }

    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    } else {
      _showSuccessDialog();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Get.back();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEC6D43).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFFEC6D43),
                    size: 64,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Congratulations!',
                  style: AppTextStyle.poppins(
                    size: 22,
                    weight: FontWeight.bold,
                    color: const Color(0xFF0C0A09),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your event has been successfully created and published.',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.inter(
                    size: 14,
                    weight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Get.offAllNamed(AppRoutes.homeui);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC6D43),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Back to Home',
                    style: AppTextStyle.inter(
                      size: 14,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title) {
    final bool isActive = _currentStep == stepIndex;
    final bool isCompleted = _currentStep > stepIndex;

    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1.5,
                  color: stepIndex == 0
                      ? Colors.transparent
                      : (isCompleted || isActive
                          ? const Color(0xFFEC6D43)
                          : const Color(0xFFD1D5DB)),
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive || isCompleted
                      ? const Color(0xFFEC6D43)
                      : Colors.white,
                  border: Border.all(
                    color: isActive || isCompleted
                        ? const Color(0xFFEC6D43)
                        : const Color(0xFFD1D5DB),
                    width: 2,
                  ),
                ),
                child: isActive
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : isCompleted
                        ? const Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            ),
                          )
                        : null,
              ),
              Expanded(
                child: Container(
                  height: 1.5,
                  color: stepIndex == _stepTitles.length - 1
                      ? Colors.transparent
                      : (isCompleted
                          ? const Color(0xFFEC6D43)
                          : const Color(0xFFD1D5DB)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: AppTextStyle.inter(
                size: 11,
                weight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive
                    ? const Color(0xFFEC6D43)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final createController = Get.isRegistered<CreateController>() ? Get.find<CreateController>() : Get.put(CreateController());
    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: CustomBottomNavBar(selectedIndex: -1),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 30,),
                  Text(
                    "Create Event",
                    style: AppTextStyle.poppins(
                      size: 22,
                      weight: FontWeight.bold,
                      color: Appcolors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Share something amazing with your community",
                    style: AppTextStyle.poppins(
                      size: 13,
                      weight: FontWeight.normal,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      _stepTitles.length,
                      (index) => _buildStepIndicator(index, _stepTitles[index]),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Color(0xFFE5E7EB)),
                ],
              ),
            ),

            Expanded(
              child: _getStepWidget(),
            ),

            if (_currentStep < 4)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    if (_currentStep > 0) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousStep,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFEC6D43)),
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Back",
                            style: AppTextStyle.inter(
                              size: 14,
                              weight: FontWeight.bold,
                              color: const Color(0xFFEC6D43),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      child: CustomButton(
                        text: _currentStep == 4 ? "Publish Event" : "Next",
                        onTap: _nextStep,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      Obx(() {
        if (createController.isLoading.value) {
          return Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFFEC6D43)),
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    ],
  ),
);
  }
}
