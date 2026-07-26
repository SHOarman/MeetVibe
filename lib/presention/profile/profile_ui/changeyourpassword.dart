import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class Changeyourpassword extends StatelessWidget {
  const Changeyourpassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              SizedBox(height: 60,),

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
                        "Change Passwoard",
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

              CustomTextfild(hintText: "********",labelText: "Current Passwoard",),
              SizedBox(height: 10,),
              CustomTextfild(hintText: "********",labelText: "New Passwoard",),
              SizedBox(height: 10,),

              CustomTextfild(hintText: "********",labelText: "Confirm Passwoard",),
              
              SizedBox(height: 100,),
              CustomButton(text: "Save", onTap: (){})


            ],
          ),
        ),
      ),
    );
  }
}
