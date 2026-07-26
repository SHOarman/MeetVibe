import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/message/message_widget/event_message_card.dart';
import 'package:meetvibe/presention/message/message_widget/message_tile.dart';

class EventsMessage extends StatelessWidget {
  const EventsMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              EventMessageCard(
                title: "Live Music Festival",
                imagePath: "assets/image/image 9.png",
                attendeeCount: 124,
                unreadCount: 5,
                onTap: () => Get.toNamed(AppRoutes.msgInbox),
              ),
              EventMessageCard(
                title: "Weekend Hike & Camping",
                imagePath: "assets/image/unsplash_dDlYGoYJqBw.png",
                attendeeCount: 32,
                unreadCount: 2,
                onTap: () => Get.toNamed(AppRoutes.msgInbox),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            CustomMessageTile(
              name: "Coffee Networking meetup",
              avatar: "assets/image/Avatar.png",
              lastMessage: "Sarah: see you there",
              time: "yesterday",
              isOnline: true,
              unreadCount: 2,
              onTap: () => Get.toNamed(AppRoutes.msgInbox),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFF3F3F3),
            ),
            CustomMessageTile(
              name: "Startup Founders Meetup",
              avatar: "assets/image/Avatar (4).png",
              lastMessage: "Voice message",
              time: "2d",
              isOnline: true,
              isVoice: true,
              onTap: () => Get.toNamed(AppRoutes.msgInbox),
            ),
          ],
        ),
      ],
    );
  }
}
