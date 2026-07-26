import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/home/home_widget/nearbycard.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class ReviewStep extends StatelessWidget {
  final VoidCallback? onEditTap;
  final VoidCallback? onPublishTap;

  const ReviewStep({super.key, this.onEditTap, this.onPublishTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Review & Publish",
              style: AppTextStyle.poppins(
                size: 18,
                weight: FontWeight.bold,
                color: Appcolors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Review your event details before publishing",
              style: AppTextStyle.poppins(
                size: 13,
                weight: FontWeight.normal,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Event Preview",
              style: AppTextStyle.poppins(
                size: 16,
                weight: FontWeight.w600,
                color: const Color(0xff2A2A2A),
              ),
            ),

            const SizedBox(height: 24),
            NearbyEventCard(
              title: 'Weekend Hike & Camping',
              categoryName: 'Adventure',
              categoryColor: const Color(0xFFF97316),
              attendeeCount: 32,
              location: 'Sajek Valley',
              dateTime: '05 July - 8:00 AM',
              imagePath: 'assets/image/image 6 (1).png',
              onJoinTap: () => Get.toNamed(AppRoutes.eventdetels),
            ),

            const SizedBox(height: 24),

            Text(
              "About This Event",
              style: AppTextStyle.poppins(
                size: 17,
                weight: FontWeight.w600,
                color: const Color(0xff2A2A2A),
              ),
            ),
            const SizedBox(height: 10),

            Text(
              "Experience an unforgettable weekend in Sajek Valley! Enjoy breathtaking views and thrilling outdoor adventures while connecting with fellow nature enthusiasts. Join us for hiking, campfire stories, and lasting memories!",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: Color(0x1A000000), height: 1),
            const SizedBox(height: 16),

            Text(
              "Event Details",
              style: AppTextStyle.poppins(
                size: 17,
                weight: FontWeight.w600,
                color: const Color(0xff2A2A2A),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 12),
                Text(
                  "Sunday, 05 July 2026",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Time Detail Row
            Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 12),
                Text(
                  "7:00 AM - 8:00 AM",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Location Detail Row
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 12),
                Text(
                  "Sajek Valley, Bangladesh",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(color: Color(0x1A000000), height: 1),
            const SizedBox(height: 24),

            // Edit Details Button
            OutlinedButton(
              onPressed: onEditTap,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFEC6D43), width: 1.5),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFFEC6D43),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Edit Details",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFEC6D43),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Publish Event Button
            GestureDetector(
              onTap: onPublishTap,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEC6D43), Color(0xFFFFB670)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Publish Event",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
