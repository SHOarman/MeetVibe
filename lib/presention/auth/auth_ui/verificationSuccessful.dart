import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';

class Verificationsuccessful extends StatelessWidget {
  const Verificationsuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),

                      // Title
                      Text(
                        "Verification Successful!",
                        style: AppTextStyle.poppins(
                          size: 22,
                          weight: FontWeight.w700,
                          color: Appcolors.black,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        "Your identity has been verified successfully.",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.inter(
                          size: 15,
                          weight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 50),

                      // ID Shield Image
                      Image.asset(
                        "assets/image/image 13.png",
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 50),

                      // Checklist Items
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Column(
                          children: [
                            _buildChecklistItem("Identity Verified"),
                            const SizedBox(height: 16),
                            _buildChecklistItem("Age Verified"),
                            const SizedBox(height: 16),
                            _buildChecklistItem("Selfie Matched"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Continue Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomButton(
                text: "Continue",
                onTap: () {
                  Get.offAllNamed(AppRoutes.login);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle,
          color: Color(0xFF34D399), // Soft green color matching mockup
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTextStyle.inter(
            size: 15,
            weight: FontWeight.w500,
            color: const Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }
}
