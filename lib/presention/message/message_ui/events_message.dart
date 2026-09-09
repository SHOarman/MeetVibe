import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/home/home_controller/home_controller.dart';
import 'package:meetvibe/presention/message/message_widget/event_message_card.dart';
import 'package:meetvibe/presention/message/message_widget/message_tile.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';

class EventsMessage extends StatelessWidget {
  const EventsMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Obx(() {
          final joinedEvents = homeController.joinedEvents;
          if (joinedEvents.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("You haven't joined any events yet."),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: joinedEvents.map((event) {
                final eventId = event['id'] ?? event['_id'] ?? '';
                final title = event['title'] ?? 'Unknown Event';
                final imageRaw = event['coverImage'] ?? (event['media'] != null && (event['media'] as List).isNotEmpty ? (event['media'] as List)[0] : null);
                final image = imageRaw != null && imageRaw.toString().isNotEmpty 
                    ? Apiservices.fixImageUrl(imageRaw.toString()) 
                    : 'assets/image/image 9.png';
                
                final int joinedCount = (event['_count'] != null ? event['_count']['participants'] : null) ??
                    (event['participations'] as List?)?.length ?? 
                    int.tryParse(event['participantCount']?.toString() ?? '') ?? 
                    int.tryParse(event['participantsCount']?.toString() ?? '') ?? 
                    int.tryParse(event['totalParticipants']?.toString() ?? '') ?? 0;
                    
                final capacity = event['capacity'] ?? 0;

                return EventMessageCard(
                  title: title,
                  imagePath: image,
                  attendeeCount: joinedCount,
                  unreadCount: 0,
                  onTap: () {
                    // Navigate to msgInbox with arguments
                    Get.toNamed(AppRoutes.msgInbox, arguments: {
                      'eventId': eventId,
                      'title': title,
                      'capacity': joinedCount,
                    });
                  },
                );
              }).toList(),
            ),
          );
        }),
        const SizedBox(height: 24),
      ],
    );
  }
}
