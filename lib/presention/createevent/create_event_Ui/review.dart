import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/home/home_widget/nearbycard.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/presention/createevent/create_event_controller/create_controller.dart';
import 'package:intl/intl.dart';

class ReviewStep extends StatelessWidget {
  final VoidCallback? onEditTap;
  final VoidCallback? onPublishTap;

  const ReviewStep({super.key, this.onEditTap, this.onPublishTap});

  @override
  Widget build(BuildContext context) {
    final createController = Get.isRegistered<CreateController>() ? Get.find<CreateController>() : Get.put(CreateController());
    
    // Formatting
    String dateRange = "";
    if (createController.startDate.value != null) {
      dateRange = DateFormat('dd MMM yyyy').format(createController.startDate.value!);
    }
    String timeRange = "";
    if (createController.startTime.value != null && createController.endTime.value != null) {
      timeRange = "${createController.startTime.value!.format(context)} - ${createController.endTime.value!.format(context)}";
    }

    String venueStr = createController.venueType.value == 'OFFLINE' 
        ? (createController.venueNameController.text.isNotEmpty ? "${createController.venueNameController.text}, ${createController.addressController.text}" : createController.addressController.text)
        : createController.onlineLinkController.text;

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
            Obx(() {
               return NearbyEventCard(
                  title: createController.titleController.text.isNotEmpty ? createController.titleController.text : 'Event Title',
                  categoryName: createController.category.value.isNotEmpty ? createController.category.value : 'Category',
                  categoryColor: const Color(0xFFF97316),
                  attendeeCount: int.tryParse(createController.capacityController.text) ?? 0,
                  location: venueStr.isNotEmpty ? venueStr : 'Location',
                  dateTime: dateRange.isNotEmpty ? dateRange : 'Date & Time',
                  imageFile: createController.coverImage.value,
                  imagePath: null,
                  onJoinTap: () {}, // Prevent navigation during preview
              );
            }),

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
              createController.agendaController.text.isNotEmpty ? createController.agendaController.text : "No description provided.",
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
                  dateRange.isNotEmpty ? dateRange : "No date selected",
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
                  timeRange.isNotEmpty ? timeRange : "No time selected",
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
                Expanded(
                  child: Text(
                    venueStr.isNotEmpty ? venueStr : "No location selected",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
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
