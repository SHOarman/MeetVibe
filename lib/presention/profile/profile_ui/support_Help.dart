import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/profile/profile_widget/customsecuriycard.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class Support_help extends StatelessWidget {
  const Support_help({super.key});

  Widget _buildBullet() {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Color(0xFF1F2937),
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              SizedBox(
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 1,
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Support & Help",
                        style: AppTextStyle.outfit(
                          size: 24,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              CustomSecurityCard(
                title: "FAQs",
                prefix: _buildBullet(),
                showTrailing: false,
                onTap: () {
                 Get.toNamed(AppRoutes.faqs);
                },
              ),
              CustomSecurityCard(
                title: "Report a Problem",
                prefix: _buildBullet(),
                showTrailing: false,
                onTap: () {
                  Get.toNamed(AppRoutes.reportProblem);
                },
              ),
              CustomSecurityCard(
                title: "Privacy Policy",
                prefix: _buildBullet(),
                showTrailing: false,
                onTap: () {
                  Get.toNamed(AppRoutes.privacyPolicy);
                },
              ),
              CustomSecurityCard(
                title: "Terms & Conditions",
                prefix: _buildBullet(),
                showTrailing: false,
                onTap: () {
                  Get.toNamed(AppRoutes.terms);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
