import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import '../auth_widget/uploardcard.dart';
import '../auth_controller/authcontroller.dart';

class Uploadgovernmentid extends StatelessWidget {
  const Uploadgovernmentid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Authcontroller());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Appcolors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Upload Government ID",
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
                    "Upload a clear photo of your valid\n government ID.",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.inter(
                      size: 16,
                      weight: FontWeight.w500,
                      color: Appcolors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const UploadCard(),
                const SizedBox(height: 20),
                Text(
                  "Supported: JPG, PNG",
                  style: AppTextStyle.inter(
                    size: 14,
                    weight: FontWeight.w500,
                    color: Colors.grey[600]!,
                  ),
                ),
                const SizedBox(height: 80),
                Obx(() {
                  final isImageSelected = controller.imagePath.value.isNotEmpty;
                  return CustomButton(
                    text: "Continue",
                    onTap: isImageSelected
                        ? () {
                      Get.toNamed(AppRoutes.selfieVerification);
                            Get.snackbar(
                              'Success',
                              'ID uploaded successfully!',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        : () {
                            Get.snackbar(
                              'Info',
                              'Please upload your government ID first',
                              snackPosition: SnackPosition.BOTTOM,
                            );
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
}
