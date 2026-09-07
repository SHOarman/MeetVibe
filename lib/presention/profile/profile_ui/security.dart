import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/profile/profile_widget/customsecuriycard.dart';
import 'package:meetvibe/presention/profile/profile_widget/custommsg.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  bool _loginActivity = true;
  bool _emailPhoneVerification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
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
                        "Security",
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

              CustomSecurityCard(
                title: "Change Password",
                onTap: () {
                 Get.toNamed(AppRoutes.change_yourpassword);
                },
              ),

              CustomSecurityCard(
                title: "Login Activity",
                isSwitch: true,
                switchValue: _loginActivity,
                onSwitchChanged: (value) {
                  setState(() {
                    _loginActivity = value;
                  });
                },
              ),

              CustomSecurityCard(
                title: "Email & Phone verification",
                isSwitch: true,
                switchValue: _emailPhoneVerification,
                onSwitchChanged: (value) {
                  setState(() {
                    _emailPhoneVerification = value;
                  });
                },
              ),

              CustomSecurityCard(
                title: "Delete Account",
                textColor: const Color(0xFFFF5A4A),
                trailing: SvgPicture.asset(
                  "assets/icon/Frame (26).svg",
                  height: 20,
                  width: 20,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFFF5A4A),
                    BlendMode.srcIn,
                  ),
                ),
                onTap: () {
                  Get.dialog(
                    CustomMsgDialog(
                      title: "Delete Account",
                      buttonText: "Delete",
                      iconPath: "assets/icon/Frame (29).svg",
                      isDelete: true,
                      titleColor: const Color(0xFFFF5A4A),
                      onCancel: () => Get.back(),
                      onConfirm: () async {
                        Get.back(); // Close dialog
                        final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());
                        final success = await authController.deleteAccount();
                        if (success) {
                           Get.offAllNamed(AppRoutes.login);
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
