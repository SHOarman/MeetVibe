import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';

class Verified extends StatelessWidget {
  const Verified({super.key});

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

              Center(child: Image.asset("assets/image/Frame.png")),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Verified",
                  style: AppTextStyle.poppins(
                    size: 18,
                    weight: FontWeight.w600,
                    color: Appcolors.black,
                  ),
                ),
              ),

              SizedBox(height: 10),
              Center(
                child: Text(
                  "You have successfully verified your account.",
                  style: AppTextStyle.inter(
                    size: 15,
                    weight: FontWeight.w600,
                    color: Appcolors.black,
                  ),
                ),
              ),

              SizedBox(height: 60),

              CustomButton(
                text: "Login to your Account",
                onTap: () {
                  Get.toNamed(AppRoutes.identityVerification);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
