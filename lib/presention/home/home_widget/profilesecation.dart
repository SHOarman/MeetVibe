import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/presention/profile/profile_controller/profile_controller.dart';

class ProfileSecation extends StatelessWidget {
  const ProfileSecation({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.isRegistered<ProfileController>() ? Get.find<ProfileController>() : Get.put(ProfileController());

    return Obx(() {
      final imageUrl = profileController.image.value;
      final localImage = profileController.localImage.value;
      final rawName =   profileController.name.value;
      final name = "${rawName.split(" ").first}!";

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
            ),
            clipBehavior: Clip.hardEdge,
            child: localImage.isNotEmpty
                ? Image.file(
                    File(localImage),
                    fit: BoxFit.cover,
                  )
                : imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                    )
                  : Image.asset(
                      'assets/image/59039 1.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getGreeting(),
                  style: AppTextStyle.poppins(
                    size: 16,
                    weight: FontWeight.w400,
                    color: const Color(0xff0C0A09),
                  ),
                ),
                Text(
                  name,
                  style: AppTextStyle.poppins(
                    size: 20,
                    weight: FontWeight.bold,
                    gradient: const LinearGradient(
                      colors: [Color(0xffEC6D43), Color(0xffFFB670)],
                    ),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.notifcation);
            },
            child: SvgPicture.asset(
              'assets/icon/Frame (11).svg',
              width: 28,
              height: 28,
            ),
          ),
        ],
      );
    });
  }
}
