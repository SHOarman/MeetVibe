import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';

class Createnewpasswoard extends StatefulWidget {
  const Createnewpasswoard({super.key});

  @override
  State<Createnewpasswoard> createState() => _CreatenewpasswoardState();
}

class _CreatenewpasswoardState extends State<Createnewpasswoard> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToPolicy = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),


                  Center(
                    child: Image.asset(
                      "assets/image/image 4.png",
                      // height: 70,
                      // width: 70,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 32),
                  Text(
                    "Create new password",
                    style: AppTextStyle.poppins(
                      size: 18,
                      weight: FontWeight.w700,
                      color: Appcolors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your new password must be different from previous used passwords.",
                    style: AppTextStyle.inter(
                      size: 14,
                      weight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // New Password Input
                  CustomTextfild(
                    controller: _newPasswordController,
                    labelText: "New Password",
                    hintText: "••••••••••",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a new password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Confirm Password Input
                  CustomTextfild(
                    controller: _confirmPasswordController,
                    labelText: "Confirm Password",
                    hintText: "••••••••••",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (value != _newPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Checkbox "I agree to A Muslim Matchmaker's Privacy Policy."
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _agreeToPolicy = !_agreeToPolicy;
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(top: 2),
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: "I agree to A Muslim Matchmaker's ",
                              style: AppTextStyle.inter(
                                size: 13,
                                weight: FontWeight.w400,
                                color: const Color(0xFF6B7280),
                              ),
                              children: [
                                TextSpan(
                                  text: "Privacy Policy.",
                                  style: AppTextStyle.inter(
                                    size: 13,
                                    weight: FontWeight.w600,
                                    color: Appcolors.pramary2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Action Button
                  CustomButton(
                    text: "Forget Password",
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (!_agreeToPolicy) {
                          Get.snackbar(
                            "Required",
                            "Please agree to the Privacy Policy",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.withOpacity(0.8),
                            colorText: Colors.white,
                          );
                          return;
                        }

                        Get.toNamed(AppRoutes.verified);
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                  

                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "If you still need help, contact ",
                        style: AppTextStyle.inter(
                          size: 14,
                          weight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                        children: [
                          TextSpan(
                            text: "Support.",
                            style: AppTextStyle.inter(
                              size: 14,
                              weight: FontWeight.w600,
                              color: Appcolors.pramary2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

