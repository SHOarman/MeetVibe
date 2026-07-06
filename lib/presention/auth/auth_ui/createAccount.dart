import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';

class Createaccount extends StatefulWidget {
  const Createaccount({super.key});

  @override
  State<Createaccount> createState() => _CreateaccountState();
}

class _CreateaccountState extends State<Createaccount> {
  bool _acceptTerms = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

                // Name Field
                const CustomTextfild(
                  labelText: "Email",
                  hintText: "Enter your email",
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),

                // Email Field
                const CustomTextfild(
                  labelText: "Full name",
                  hintText: "Enter your name",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                const CustomTextfild(
                  labelText: "Password",
                  hintText: "••••••••••",
                  isPassword: true,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _acceptTerms = !_acceptTerms;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _acceptTerms
                                  ? Appcolors.pramary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _acceptTerms
                                    ? Appcolors.pramary
                                    : const Color(0xFFD1D5DB),
                                width: 1.5,
                              ),
                            ),
                            child: _acceptTerms
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

                CustomButton(text: "Continue", onTap: () {}),
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
