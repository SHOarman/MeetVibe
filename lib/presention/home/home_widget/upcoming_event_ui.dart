import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/home/home_widget/upcomingevent.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class UpcomingEventUi extends StatelessWidget {
  const UpcomingEventUi({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock events list for presentation
    final List<Map<String, dynamic>> upcomingEvents = [
      {
        'day': '05',
        'month': 'Jun',
        'title': 'Teach Talk',
        'attendeeCount': 68,
        'location': 'Zoom Office, Dhaka',
        'distance': '2.1 km away',
        'imagePath': 'assets/image/image 3.png',
      },
      {
        'day': '08',
        'month': 'Jun',
        'title': 'Morning Yoga Session',
        'attendeeCount': 35,
        'location': 'Hatirjhil Park',
        'distance': '3.4 km away',
        'imagePath': 'assets/image/image 4.png',
      },
      {
        'day': '12',
        'month': 'Jun',
        'title': 'Design Sprint',
        'attendeeCount': 24,
        'location': 'Wari, Dhaka',
        'distance': '1.8 km away',
        'imagePath': 'assets/image/image 6.png',
      },
      {
        'day': '15',
        'month': 'Jun',
        'title': 'Coffee Meetup',
        'attendeeCount': 12,
        'location': 'Dhanmondi, Dhaka',
        'distance': '0.9 km away',
        'imagePath': 'assets/image/homer.png',
      },
    ];

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
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: upcomingEvents.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.67, // Aspect ratio to fit UpcomingEventCard layout perfectly
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 16.0,
        ),
        itemBuilder: (context, index) {
          final event = upcomingEvents[index];
          return UpcomingEventCard(
            day: event['day'],
            month: event['month'],
            title: event['title'],
            attendeeCount: event['attendeeCount'],
            location: event['location'],
            distance: event['distance'],
            imagePath: event['imagePath'],
            onJoinTap: () => Get.toNamed(AppRoutes.eventdetels),
          );
        },
      ),
    );
  }
}
