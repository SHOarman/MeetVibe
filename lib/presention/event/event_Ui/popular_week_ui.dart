import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/home/home_widget/upcomingevent.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/presention/home/home_controller/home_controller.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';

class PopularWeekUi extends StatelessWidget {
  const PopularWeekUi({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeCtrl = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final int crossAxisCount = isTablet ? 3 : 2;

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
          'Popular This Week',
          style: AppTextStyle.poppins(
            size: 20,
            weight: FontWeight.bold,
            color: const Color(0xFF0C0A09),
          ),
        ),
      ),
      body: Obx(() {
        if (homeCtrl.isLoadingPopular.value && homeCtrl.popularEvents.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (homeCtrl.popularEvents.isEmpty) {
          return const Center(child: Text("No popular events found", style: TextStyle(color: Colors.grey)));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: homeCtrl.popularEvents.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.67,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 16.0,
          ),
          itemBuilder: (context, index) {
            final event = homeCtrl.popularEvents[index];
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

            return UpcomingEventCard(
              day: homeCtrl.getDay(event['startDate']),
              month: homeCtrl.getFormattedDate(event['startDate']).split(' ').length > 1 ? homeCtrl.getFormattedDate(event['startDate']).split(' ')[1] : 'TBA',
              title: event['title'] ?? 'No Title',
              attendeeCount: joinedCount,
              location: event['venueType']?.toString().toUpperCase() == 'ONLINE' ? 'Online' : (event['venueName'] ?? event['address'] ?? 'Online/TBA'),
              distance: '',
              imagePath: coverSource.isNotEmpty ? coverSource : 'assets/image/image 6 (3).png',
              onJoinTap: () => Get.toNamed(AppRoutes.eventdetels, arguments: event),
            );
          },
        );
      }),
    );
  }
}
