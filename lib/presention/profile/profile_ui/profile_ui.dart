import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/customnavigator_button.dart';
import 'package:meetvibe/presention/profile/profile_widget/profilecard.dart';
import 'package:meetvibe/presention/profile/profile_widget/custommsg.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class ProfileUi extends StatelessWidget {
  const ProfileUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Profile",
                    style: AppTextStyle.poppins(
                      size: 20,
                      weight: FontWeight.w700,
                      color: const Color(0xff2D292E),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'assets/icon/Frame (11).svg',
                      width: 28,
                      height: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              //===============================profile================================================
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    "assets/image/59039 1 (1).png",
                    height: 120,
                    width: 120,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.person, size: 50),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    top: 30,
                    child: Text(
                      "Mugdho",
                      style: AppTextStyle.poppins(
                        size: 24,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 260,
                    child: SvgPicture.asset(
                      "assets/icon/Vector (4).svg",
                      height: 20,
                      width: 20,
                    ),
                  ),

                  Positioned(
                    top: 65,
                    left: 130,
                    child: Text(
                      "@mugdho_23",
                      style: AppTextStyle.poppins(
                        size: 14,
                        weight: FontWeight.w400,
                        color: const Color(0xff323232),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    left: 130,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icon/Vector (5).svg",
                          height: 12,
                          width: 12,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Dhaka, Bangladesh",
                          style: AppTextStyle.poppins(
                            size: 13,
                            weight: FontWeight.w400,
                            color: const Color(0xff7E7E7E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              //===================profile card===================================================
              ProfileCard(
                title: "Edit Profile",
                iconPath: "assets/icon/Frame.svg",
                onTap: () {
                  Get.toNamed(AppRoutes.editprofile);
                },
              ),
              ProfileCard(
                title: "Verification",
                iconPath: "assets/icon/Frame (1).svg",
                onTap: () {
                  Get.toNamed(AppRoutes.identityVerification);
                },
              ),
              ProfileCard(
                title: "Subscription",
                iconPath: "assets/icon/Frame (2).svg",
                onTap: () {


                },
              ),
              ProfileCard(
                title: "Security",
                iconPath: "assets/icon/Frame (3).svg",
                onTap: () {
                  Get.toNamed(AppRoutes.security);
                },
              ),
              ProfileCard(
                title: "Support & Help",
                iconPath: "assets/icon/Frame (4).svg",
                onTap: () {
                  Get.toNamed(AppRoutes.support_help);
                },
              ),
              ProfileCard(
                title: "Logout",
                iconPath: "assets/icon/Frame (5).svg",
                onTap: () {
                  Get.dialog(
                    CustomMsgDialog(
                      title: "Logout from the app",
                      buttonText: "Logout",
                      iconPath: "assets/icon/Frame (27).svg",
                      onCancel: () => Get.back(),
                      onConfirm: () {

                        Get.back();
                      },
                    ),
                  );
                },
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
