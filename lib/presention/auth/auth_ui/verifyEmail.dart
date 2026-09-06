import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';

class Verifyemail extends StatefulWidget {
  const Verifyemail({super.key});

  @override
  State<Verifyemail> createState() => _VerifyemailState();
}

class _VerifyemailState extends State<Verifyemail> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    "assets/image/image 4.png",
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Verify your email address",
                  style: AppTextStyle.poppins(
                    size: 18,
                    weight: FontWeight.w700,
                    color: Appcolors.black,
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: AppTextStyle.inter(
                      size: 14,
                      weight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                    children: [
                      const TextSpan(
                        text: "We emailed you a six-digit code to ",
                      ),
                      TextSpan(
                        text: Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>().registeredEmail.value : "your email",
                        style: AppTextStyle.inter(
                          size: 14,
                          weight: FontWeight.w700,
                          color: Appcolors.black,
                        ),
                      ),
                      const TextSpan(
                        text:
                            ". Enter the code below to confirm your email address.",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // OTP Code Inputs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 46,
                      height: 54,
                      child: TextFormField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        onChanged: (value) => _onOtpChanged(index, value),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.poppins(
                          size: 20,
                          weight: FontWeight.w700,
                          color: Appcolors.pramary,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: const Color(
                            0xFFFAF9F9,
                          ), // subtle off-white background
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFF38D2A), // orange border
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xffEC6D43),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),

                Text(
                  "Please keep this window open while you check your inbox.",
                  style: AppTextStyle.inter(
                    size: 14,
                    weight: FontWeight.w400,
                    color: const Color(0xFF2D292E),
                  ),
                ),
                const SizedBox(height: 32),

                Obx(() => CustomButton(
                  text: "Verify",
                  isLoading: authController.isLoading.value,
                  onTap: () async {
                    String otp = _controllers.map((c) => c.text).join();
                    if (otp.length < 6) {
                      Get.snackbar('Error', 'Please enter a valid 6-digit OTP code.');
                      return;
                    }
                    
                    final email = authController.registeredEmail.value;
                    
                    if (email.isEmpty) {
                      Get.snackbar('Error', 'No email found to verify.');
                      return;
                    }
                    
                    final isForgotPassword = Get.arguments != null && Get.arguments['isForgotPassword'] == true;
                    
                    if (isForgotPassword) {
                      authController.resetOtp.value = otp;
                      Get.toNamed(AppRoutes.createNewPassword);
                      return;
                    }
                    
                    final success = await authController.verifyOtp(email: email, otp: otp);

                    if (success) {
                      // Move to the next step, e.g., identity verification or success 
                      // Depending on if this is forgot password or registration:
                      Get.toNamed(AppRoutes.identityVerification);
                    }
                  },
                )),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    final email = authController.registeredEmail.value;
                    if (email.isNotEmpty) {
                      final isForgotPassword = Get.arguments != null && Get.arguments['isForgotPassword'] == true;
                      if (isForgotPassword) {
                        authController.forgotPassword(email: email);
                      } else {
                        authController.resendOtp(email: email);
                      }
                    } else {
                      Get.snackbar('Error', 'No email found to resend OTP.');
                    }
                  },
                  child: Center(
                    child: Text(
                      "Resend Code",
                      style: AppTextStyle.poppins(
                        size: 14,
                        weight: FontWeight.w600,
                        color: Appcolors.pramary,
                      ),
                    ),
                  ),
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
