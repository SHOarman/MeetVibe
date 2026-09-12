import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80),

              Center(child: Image.asset("assets/image/image 4.png")),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Log in",
                  style: AppTextStyle.poppins(
                    size: 18,
                    weight: FontWeight.w600,
                    color: Appcolors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              CustomTextfild(
                controller: authController.loginEmailController,
                keyboardType: TextInputType.emailAddress,
                labelText: "Email",
                hintText: "name@example.com",
              ),
              const SizedBox(height: 20),

              CustomTextfild(
                controller: authController.loginPasswordController,
                labelText: "Password",
                hintText: "••••••••••",
                isPassword: true,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      authController.rememberMe.value = !authController.rememberMe.value;
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() => Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: authController.rememberMe.value
                                ? Appcolors.pramary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: authController.rememberMe.value
                                  ? Appcolors.pramary
                                  : const Color(0xFFD1D5DB),
                              width: 1.5,
                            ),
                          ),
                          child: authController.rememberMe.value
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        )),
                        const SizedBox(width: 8),
                        Text(
                          "Remember me",
                          style: AppTextStyle.poppins(
                            size: 14,
                            weight: FontWeight.w500,
                            color: const Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.forgetPassword);
                    },
                    child: Text(
                      "Forgot password?",
                      style: AppTextStyle.poppins(
                        size: 14,
                        weight: FontWeight.w600,
                        color: Appcolors.pramary,
                      ),
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

                  if (authController.loginEmailController.text.isEmpty || 
                      authController.loginPasswordController.text.isEmpty) {
                    Get.snackbar('Error', 'Please fill all required fields');
                    return;
                  }
                  
                  final success = await authController.login(
                    email: authController.loginEmailController.text,
                    password: authController.loginPasswordController.text,
                  );
                  if (success) {
                    Get.offAllNamed(AppRoutes.homeui);
                  }
                }
              )),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account yet?",
                    style: AppTextStyle.inter(
                      size: 14,
                      weight: FontWeight.w600,
                      color: Appcolors.black,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.createAccount);
                    },
                    child: Text(
                      "Sign up",
                      style: AppTextStyle.inter(
                        size: 14,
                        weight: FontWeight.w600,
                        color: Appcolors.pramary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
