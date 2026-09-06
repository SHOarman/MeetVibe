import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';

class Createaccount extends StatelessWidget {
  const Createaccount({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(Authcontroller());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    "assets/image/image 4.png",
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    "Create Account",
                    style: AppTextStyle.poppins(
                      size: 20,
                      weight: FontWeight.w600,
                      color: Appcolors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Email Field
                CustomTextfild(
                  controller: authController.emailController,
                  labelText: "Email",
                  hintText: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Name Field
                CustomTextfild(
                  controller: authController.nameController,
                  labelText: "Full name",
                  hintText: "Enter your name",
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),

                CustomTextfild(
                  controller: authController.passwordController,
                  labelText: "Password",
                  hintText: "••••••••••",
                  isPassword: true,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        authController.acceptTerms.value = !authController.acceptTerms.value;
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() => Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: authController.acceptTerms.value
                                  ? Appcolors.pramary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: authController.acceptTerms.value
                                    ? Appcolors.pramary
                                    : const Color(0xFFD1D5DB),
                                width: 1.5,
                              ),
                            ),
                            child: authController.acceptTerms.value
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          )),
                          const SizedBox(width: 8),
                          RichText(
                            text: TextSpan(
                              text: "I accept the ",
                              style: AppTextStyle.poppins(
                                size: 14,
                                weight: FontWeight.w500,
                                color: const Color(0xFF4B5563),
                              ),
                              children: [
                                TextSpan(
                                  text: "Terms and Conditions",
                                  style: AppTextStyle.poppins(
                                    size: 14,
                                    weight: FontWeight.w600,
                                    color: Appcolors.pramary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 34),

                Obx(() => CustomButton(
                  text: "Continue",
                  isLoading: authController.isLoading.value,
                  onTap: () async {
                    if (authController.isLoading.value) return;

                    if (!authController.acceptTerms.value) {
                      Get.snackbar('Error', 'Please accept Terms and Conditions');
                      return;
                    }
                    if (authController.emailController.text.isEmpty || 
                        authController.nameController.text.isEmpty || 
                        authController.passwordController.text.isEmpty) {
                      Get.snackbar('Error', 'Please fill all required fields');
                      return;
                    }
                    
                    final success = await authController.register(
                      email: authController.emailController.text,
                      name: authController.nameController.text,
                      password: authController.passwordController.text,
                    );
                    if (success) {
                      // Move to the verify email OTP page
                      Get.toNamed(AppRoutes.verifyEmail);
                    }
                  }
                )),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppTextStyle.poppins(
                        size: 14,
                        weight: FontWeight.w500,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.login),
                      child: Text(
                        "Log in",
                        style: AppTextStyle.poppins(
                          size: 14,
                          weight: FontWeight.w600,
                          color: Appcolors.pramary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
