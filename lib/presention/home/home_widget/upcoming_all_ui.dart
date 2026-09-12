import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/home/home_widget/nearbycard.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

import 'package:meetvibe/presention/home/home_controller/home_controller.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';

class UpcomingAllUi extends StatelessWidget {
  const UpcomingAllUi({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeCtrl = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final int crossAxisCount = isTablet ? 3 : 2;
    final double childAspectRatio = isTablet ? 0.76 : 0.63;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0C0A09)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Upcoming Events',
          style: AppTextStyle.poppins(
            size: 20,
            weight: FontWeight.bold,
            color: const Color(0xFF0C0A09),
          ),
        ),
      ),
      body: Obx(() {
        if (homeCtrl.isLoadingUpcoming.value && homeCtrl.upcomingEvents.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (homeCtrl.upcomingEvents.isEmpty) {
          return const Center(child: Text("No upcoming events found", style: TextStyle(color: Colors.grey)));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: homeCtrl.upcomingEvents.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 16.0,
          ),
          itemBuilder: (context, index) {
            final event = homeCtrl.upcomingEvents[index];
            final String coverSource = (event['coverImage'] != null && event['coverImage'].toString().isNotEmpty) 
                                       ? Apiservices.fixImageUrl(event['coverImage']) 
                                       : '';

            int countFromDict = 0;
            if (event['_count'] != null && event['_count'] is Map) {
              countFromDict = event['_count']['participants'] ?? 0;
            }
            
            final int joinedCount = countFromDict > 0 ? countFromDict :
                (event['participations'] as List?)?.length ?? 
                int.tryParse(event['participantCount']?.toString() ?? '') ?? 
                int.tryParse(event['participantsCount']?.toString() ?? '') ?? 
                int.tryParse(event['capacity']?.toString() ?? '') ?? 0;

            return NearbyEventCard(
              title: event['title'] ?? 'No Title',
              categoryName: event['category'] ?? 'Uncategorized',
              categoryColor: const Color(0xFF2563EB),
              attendeeCount: joinedCount,
              location: event['venueType']?.toString().toUpperCase() == 'ONLINE' ? 'Online' : (event['venueName'] ?? 'Online / TBA'),
              dateTime: homeCtrl.getFormattedDate(event['startDate']),
              imagePath: coverSource,
              onJoinTap: () => Get.toNamed(AppRoutes.eventdetels, arguments: event),
            );
          },
        );
      }),
    );
  }
}
