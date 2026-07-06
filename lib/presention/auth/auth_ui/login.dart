import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
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
                  "Log in ",
                  style: AppTextStyle.poppins(
                    size: 18,
                    weight: FontWeight.w600,
                    color: Appcolors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const CustomTextfild(
                keyboardType: TextInputType.emailAddress,
                labelText: "Email",
                hintText: "name@example.com",
              ),
              const SizedBox(height: 20),

              const CustomTextfild(
                labelText: "Password",
                hintText: "••••••••••",
                isPassword: true,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _rememberMe = !_rememberMe;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _rememberMe
                                ? Appcolors.pramary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _rememberMe
                                  ? Appcolors.pramary
                                  : const Color(0xFFD1D5DB),
                              width: 1.5,
                            ),
                          ),
                          child: _rememberMe
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
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

              CustomButton(text: "Continue", onTap: () {}),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: .center,
                children: [
                  Text(
                    "Don’t have an account yet?",
                    style: AppTextStyle.inter(
                      size: 14,
                      weight: FontWeight.w600,
                      color: Appcolors.black,
                    ),
                  ),
                  SizedBox(width: 6),
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
