import 'package:flutter/material.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/presention/createevent/create_event_widget/venue_onlineoroffline.dart';
import 'package:meetvibe/presention/createevent/create_event_widget/mapcreate.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

import 'package:get/get.dart';
import 'package:meetvibe/presention/createevent/create_event_controller/create_controller.dart';

class LocationStep extends StatelessWidget {
  const LocationStep({super.key});

  @override
  Widget build(BuildContext context) {
    final createController = Get.isRegistered<CreateController>() ? Get.find<CreateController>() : Get.put(CreateController());
    
    return Obx(() {
      final isOffline = createController.venueType.value == 'OFFLINE';
      
      return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location",
              style: AppTextStyle.poppins(
                size: 18,
                weight: FontWeight.bold,
                color: const Color(0xff2A2A2A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Where is your event?",
              style: AppTextStyle.poppins(
                size: 13,
                weight: FontWeight.normal,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            VenueOnlineOrOfflineSelector(
              isVenueSelected: isOffline,
              onChanged: (value) {
                createController.venueType.value = value ? 'OFFLINE' : 'ONLINE';
              },
            ),
            const SizedBox(height: 24),

            if (isOffline) ...[
              CustomTextfild(
                controller: createController.venueNameController,
                labelText: "Venue Name",
                hintText: "e.g. Stadium"
              ),
              const SizedBox(height: 10),
              CustomTextfild(
                controller: createController.addressController,
                labelText: "Full Address",
                hintText: "ex. Road 27, Dhanmondi, Dhaka 1209, Bangladesh",
              ),
              const SizedBox(height: 30),
              Text(
                "Show on Map",
                style: AppTextStyle.poppins(
                  size: 15,
                  weight: FontWeight.w800,
                  color: const Color(0xff0C0A09),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Map Picker Simulator
                  createController.mapLat.value = 23.7937;
                  createController.mapLng.value = 90.4066;
                  Get.snackbar(
                    'Location Picked', 
                    'Simulated picking location: Lat: 23.7937, Lng: 90.4066',
                    backgroundColor: Colors.white,
                  );
                },
                child: const MapCreateWidget(),
              ),
            ] else ...[
              CustomTextfild(
                controller: createController.onlineLinkController,
                labelText: "Online Meeting Link",
                hintText: "e.g. https://zoom.us/j/123456789 (Zoom/Google Meet)",
              ),
            ],
          ],
        ),
      ),
    );
    });
  }
}
