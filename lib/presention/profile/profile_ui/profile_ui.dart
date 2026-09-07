import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/customnavigator_button.dart';
import 'package:meetvibe/presention/profile/profile_widget/profilecard.dart';
import 'package:meetvibe/presention/profile/profile_widget/custommsg.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/presention/profile/profile_controller/profile_controller.dart';
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';

class ProfileUi extends StatelessWidget {
  const ProfileUi({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.isRegistered<ProfileController>() ? Get.find<ProfileController>() : Get.put(ProfileController());

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
              Obx(() {
                 if (profileController.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                 }

                 final imageUrl = profileController.image.value;
                 final localImage = profileController.localImage.value;
                 final isVerified = profileController.isVerified.value;
                 final name = profileController.name.value.isEmpty ? "Loading..." : profileController.name.value;
                 final username = profileController.username.value.isEmpty ? "..." : profileController.username.value;

                 return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: localImage.isNotEmpty
                        ? Image.file(
                            File(localImage),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : imageUrl != null && imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.person, size: 50),
                              ),
                            )
                          : Image.asset(
                              "assets/image/59039 1 (1).png",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.person, size: 50),
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  style: AppTextStyle.poppins(
                                    size: 24,
                                    weight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isVerified) ...[
                                const SizedBox(width: 4),
                                SvgPicture.asset(
                                  "assets/icon/Vector (4).svg",
                                  height: 20,
                                  width: 20,
                                ),
                              ]
                            ],
                          ),
                          if (username.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              username,
                              style: AppTextStyle.poppins(
                                size: 14,
                                weight: FontWeight.w400,
                                color: const Color(0xff323232),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              }),

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
                  Get.toNamed(AppRoutes.subscription);
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
                      onConfirm: () async {
                        Get.back(); // Close dialog
                        final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());
                        final success = await authController.logout();
                        if (success) {
                           Get.offAllNamed(AppRoutes.login);
                        }
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
