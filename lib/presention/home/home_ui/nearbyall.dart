import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/home/home_widget/nearbycard.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class Nearbyall extends StatelessWidget {
  const Nearbyall({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> nearbyEvents = [
      {
        'title': 'Live Music Festival',
        'categoryName': 'Music',
        'categoryColor': const Color(0xFF6B46C1),
        'attendeeCount': 124,
        'location': 'Gulsan lake park',
        'dateTime': '02 July - 6:00 PM',
        'imagePath': 'assets/image/image 6 (4).png',
      },
      {
        'title': 'Weekend Hike & Camping',
        'categoryName': 'Adventure',
        'categoryColor': const Color(0xFFF97316),
        'attendeeCount': 32,
        'location': 'Sajek Valley',
        'dateTime': '05 July - 8:00 AM',
        'imagePath': 'assets/image/image 6 (1).png',
      },
      {
        'title': 'Tech Expo 2026',
        'categoryName': 'Tech',
        'categoryColor': const Color(0xFF2563EB),
        'attendeeCount': 85,
        'location': 'Zoom Office, Dhaka',
        'dateTime': '10 July - 10:00 AM',
        'imagePath': 'assets/image/image 6 (1).png',
      },
      {
        'title': 'Morning Yoga Session',
        'categoryName': 'Fitness',
        'categoryColor': const Color(0xFF10B981),
        'attendeeCount': 35,
        'location': 'Hatirjhil Park',
        'dateTime': '08 June - 8:00 AM',
        'imagePath': 'assets/image/image 6 (4).png',
      },
    ];

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
          'Nearby Events',
          style: AppTextStyle.poppins(
            size: 20,
            weight: FontWeight.bold,
            color: const Color(0xFF0C0A09),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: nearbyEvents.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 16.0,
        ),
        itemBuilder: (context, index) {
          final event = nearbyEvents[index];
          return NearbyEventCard(
            title: event['title'],
            categoryName: event['categoryName'],
            categoryColor: event['categoryColor'],
            attendeeCount: event['attendeeCount'],
            location: event['location'],
            dateTime: event['dateTime'],
            imagePath: event['imagePath'],
            onJoinTap: () => Get.toNamed(AppRoutes.eventdetels),
          );
        },
      ),
    );
  }
}
