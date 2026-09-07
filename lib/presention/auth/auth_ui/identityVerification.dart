import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/presention/auth/auth_widget/verificationcard.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';
import 'package:url_launcher/url_launcher.dart';

class Identityverification extends StatelessWidget {
  const Identityverification({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensuring authController is available
    final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
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

              const SizedBox(height: 16),

              Center(
                child: Text(
                  "To ensure a safe community, we need to\n verify your identity.",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.inter(
                    size: 14,
                    weight: FontWeight.w500,
                    color: Appcolors.black,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              VerificationCard(
                title: 'Government ID',
                subtitle: 'Upload a valid ID',
                svgPath: 'assets/icon/Frame (7).svg',
                onTap: () {},
              ),
              const SizedBox(height: 10),
              VerificationCard(
                title: 'Selfie Verification',
                subtitle: 'Take a clear selfie',
                svgPath: 'assets/icon/Frame (8).svg',
                onTap: () {},
              ),
              const SizedBox(height: 10),
              VerificationCard(
                title: 'Age Verification',
                subtitle: 'You must be 18+ to continue',
                svgPath: 'assets/icon/Frame (9).svg',
                onTap: () {},
              ),

              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/icon/Frame (10).svg"),
                  Text(
                    "Your data is encrypted and securely stored",
                    style: AppTextStyle.poppins(
                      size: 10,
                      weight: FontWeight.w500,
                      color: Appcolors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              Obx(() => CustomButton(
                text: "Continue", 
                isLoading: authController.isLoading.value,
                onTap: () async {
                  final urlString = await authController.verifyIdentity();
                  if (urlString != null) {
                    final uri = Uri.parse(urlString);
                    try {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } catch (e) {
                      Get.snackbar('Error', 'Could not open URL: $e');
                    }
                  }
                }
              )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
