import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class ProfileSecation extends StatelessWidget {
  const ProfileSecation({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: const DecorationImage(
              image: AssetImage('assets/image/59039 1.png'),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Good Evening',
                style: AppTextStyle.poppins(
                  size: 16,
                  weight: FontWeight.w400,
                  color: Color(0xff0C0A09),
                ),
              ),
              Text(
                'Mugdho!',
                style: AppTextStyle.poppins(
                  size: 20,
                  weight: FontWeight.bold,
                  gradient: LinearGradient(
                    colors: [Color(0xffEC6D43), Color(0xffFFB670)],
                  ),
                ),
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
  }
}
