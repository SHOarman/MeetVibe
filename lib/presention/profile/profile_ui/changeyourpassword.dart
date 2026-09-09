import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';

class Changeyourpassword extends StatefulWidget {
  const Changeyourpassword({super.key});

  @override
  State<Changeyourpassword> createState() => _ChangeyourpasswordState();
}

class _ChangeyourpasswordState extends State<Changeyourpassword> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final Authcontroller authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void onSave() async {
    final current = currentPasswordController.text;
    final newPass = newPasswordController.text;
    final confirm = confirmPasswordController.text;

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      Get.snackbar('Error', 'All fields are required', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (newPass != confirm) {
      Get.snackbar('Error', 'New passwords do not match', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final success = await authController.changePassword(current, newPass);
    if (success) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 60,),
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
                        "Change Password",
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

              CustomTextfild(
                hintText: "********",
                labelText: "Current Password",
                controller: currentPasswordController,
              ),
              const SizedBox(height: 10,),
              CustomTextfild(
                hintText: "********",
                labelText: "New Password",
                controller: newPasswordController,
              ),
              const SizedBox(height: 10,),
              CustomTextfild(
                hintText: "********",
                labelText: "Confirm Password",
                controller: confirmPasswordController,
              ),
              
              const SizedBox(height: 100,),
              Obx(() => authController.isLoading.value 
                  ? const CircularProgressIndicator(color: Color(0xFFEC6D43))
                  : CustomButton(text: "Save", onTap: onSave)),
            ],
          ),
        ),
      ),
    );
  }
}
