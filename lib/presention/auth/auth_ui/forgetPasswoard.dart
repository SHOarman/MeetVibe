import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';

class Forgetpasswoard extends StatefulWidget {
  const Forgetpasswoard({super.key});

  @override
  State<Forgetpasswoard> createState() => _ForgetpasswoardState();
}

class _ForgetpasswoardState extends State<Forgetpasswoard> {
  bool _agreeToPolicy = false;
  final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 32),
                Text(
                  "Forget your password",
                  style: AppTextStyle.poppins(
                    size: 18,
                    weight: FontWeight.w700,
                    color: Appcolors.black,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: AppTextStyle.poppins(
                      size: 14,
                      weight: FontWeight.w400,
                      color: Appcolors.black,
                    ),
                    children: [
                      const TextSpan(
                        text:
                            "We’ll email you instructions to reset your password. If you don’t have access to your email anymore, you can try ",
                      ),
                      TextSpan(
                        text: "account recovery.",
                        style: AppTextStyle.poppins(
                          size: 14,
                          weight: FontWeight.w600,
                          color: Appcolors.pramary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextfild(
                  controller: authController.forgotEmailController,
                  labelText: "Email",
                  hintText: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                

                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _agreeToPolicy = !_agreeToPolicy;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _agreeToPolicy ? Appcolors.pramary : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _agreeToPolicy ? Appcolors.pramary : const Color(0xFFD1D5DB),
                                width: 1.5,
                              ),
                            ),
                            child: _agreeToPolicy
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          RichText(
                            text: TextSpan(
                              text: "I agree to MeetVibe’s ",
                              style: AppTextStyle.poppins(
                                size: 13,
                                weight: FontWeight.w500,
                                color: const Color(0xFF4B5563),
                              ),
                              children: [
                                TextSpan(
                                  text: "Privacy Policy.",
                                  style: AppTextStyle.poppins(
                                    size: 13,
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
                const SizedBox(height: 32),
                
                // Action Buttons Row
                Row(
                  children: [
                    Obx(() => CustomButton(
                      text: "Forget password",
                      width: 170,
                      height: 46,
                      isLoading: authController.isLoading.value,
                      onTap: () async {
                        if (authController.isLoading.value) return;
                        if (!_agreeToPolicy) {
                          Get.snackbar('Error', 'Please agree to the Privacy Policy');
                          return;
                        }
                        if (authController.forgotEmailController.text.isEmpty) {
                          Get.snackbar('Error', 'Please enter your email');
                          return;
                        }

                        final success = await authController.forgotPassword(
                          email: authController.forgotEmailController.text
                        );

                        if (success) {
                          Get.toNamed(AppRoutes.verifyEmail, arguments: {'isForgotPassword': true});
                        }
                      },
                    )),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        "Return to login",
                        style: AppTextStyle.poppins(
                          size: 15,
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
