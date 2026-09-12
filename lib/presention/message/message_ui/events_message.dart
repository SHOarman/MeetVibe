import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/home/home_controller/home_controller.dart';
import 'package:meetvibe/presention/message/message_widget/event_message_card.dart';
import 'package:meetvibe/presention/message/message_widget/message_tile.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:meetvibe/presention/message/message_controller/single_chat_controller.dart';
import 'package:meetvibe/presention/profile/profile_controller/profile_controller.dart';

class EventsMessage extends StatelessWidget {
  final bool showCards;
  const EventsMessage({super.key, this.showCards = true});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final singleChatCtrl = Get.isRegistered<SingleChatController>() ? Get.find<SingleChatController>() : Get.put(SingleChatController());
          final joinedEventsRaw = homeController.joinedEvents;
          final myEventsRaw = homeController.myEvents;
          final conversationsRaw = singleChatCtrl.conversations; // React to this too!
          
          final Map<String, dynamic> uniqueEvents = {};
          for (var e in myEventsRaw) {
             final id = e['id'] ?? e['_id'];
             if (id != null) uniqueEvents[id.toString()] = e;
          }
          for (var e in joinedEventsRaw) {
             final id = e['id'] ?? e['_id'];
             if (id != null) uniqueEvents[id.toString()] = e;
          }
          final dynamicEvents = uniqueEvents.values.toList();
          
          if (homeController.isLoadingJoinedEvents.value && dynamicEvents.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          
          if (dynamicEvents.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("You haven't joined or created any events yet."),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showCards) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: dynamicEvents.map((event) {
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

                      return EventMessageCard(
                        title: title,
                        imagePath: image,
                        attendeeCount: joinedCount,
                        unreadCount: 0,
                        onTap: () {
                          Get.toNamed(AppRoutes.msgInbox, arguments: {
                            'eventId': eventId,
                            'title': title,
                            'capacity': joinedCount,
                            'venueType': event['venueType'],
                            'onlineLink': event['onlineLink'],
                            'startDate': event['startDate'],
                            'startTime': event['startTime'],
                            'endDate': event['endDate'],
                            'endTime': event['endTime'],
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                if (showCards) const SizedBox(height: 24),
              ],
              // Vertical list for events group chats
              ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dynamicEvents.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF3F3F3),
                ),
                itemBuilder: (context, index) {
                  final event = dynamicEvents[index];
                  final eventId = event['id'] ?? event['_id'] ?? '';
                  final title = event['title'] ?? 'Unknown Event';
                  final imageRaw = event['coverImage'] ?? (event['media'] != null && (event['media'] as List).isNotEmpty ? (event['media'] as List)[0] : null);
                  final image = imageRaw != null && imageRaw.toString().isNotEmpty 
                      ? Apiservices.fixImageUrl(imageRaw.toString()) 
                      : 'assets/image/image 9.png';
                  
                  final int joinedCount = (event['_count'] != null ? event['_count']['participants'] : null) ??
                      (event['participations'] as List?)?.length ?? 0;
                      
                  String lastMsgText = "Group Chat Started";
                  String lastMsgTime = "Now";
                  bool isRead = false;
                  int unreadCount = 0;
                  bool isFromMe = false;

                  final singleChatCtrl = Get.isRegistered<SingleChatController>() ? Get.find<SingleChatController>() : Get.put(SingleChatController());
                  final profileCtrl = Get.isRegistered<ProfileController>() ? Get.find<ProfileController>() : Get.put(ProfileController());

                  try {
                    print("--- CONVERSATION DEBUG START ---");
                    for (var c in singleChatCtrl.conversations) {
                       print(c.toString());
                    }
                    print("--- CONVERSATION DEBUG END ---");

                    Map<String, dynamic>? activeConv;
                    for (var conv in singleChatCtrl.conversations) {
                       if (conv != null && conv is Map) {
                          if (conv['eventId']?.toString() == eventId ||
                              conv['event']?['id']?.toString() == eventId ||
                              conv['event']?['_id']?.toString() == eventId ||
                              conv['group']?['id']?.toString() == eventId ||
                              conv['_id']?.toString() == eventId ||
                              conv['id']?.toString() == eventId) {
                             activeConv = conv as Map<String, dynamic>;
                             break;
                          }
                       }
                    }

                    if (activeConv != null) {
                       unreadCount = int.tryParse(activeConv['unreadCount']?.toString() ?? '0') ?? 0;
                       if (activeConv['lastMessage'] != null && activeConv['lastMessage'] is Map) {
                         final lm = activeConv['lastMessage'];
                         lastMsgText = lm['content'] ?? lm['message'] ?? lastMsgText;
                         isRead = lm['isRead'] == true || lm['isRead'] == 'true';
                         isFromMe = (lm['senderId']?.toString() == profileCtrl.userId.value) || 
                                    (lm['sender']?.toString() == profileCtrl.userId.value);

                         if (lm['createdAt'] != null) {
                            try {
                                DateTime dt = DateTime.parse(lm['createdAt']).toLocal();
                                int h = dt.hour;
                                String a = h >= 12 ? 'PM' : 'AM';
                                if(h>12) h-=12; if(h==0)h=12;
                                lastMsgTime = "$h:${dt.minute.toString().padLeft(2,'0')} $a";
                            } catch(_) {}
                         }
                       }
                    }
                  } catch (e) {}
                  
                  return CustomMessageTile(
                    name: title,
                    avatar: image,
                    lastMessage: lastMsgText,
                    time: lastMsgTime,
                    isOnline: false,
                    isTyping: false,
                    unreadCount: unreadCount,
                    hasAttachment: false,
                    isLastMessageFromMe: isFromMe,
                    isLastMessageRead: isRead,
                    onTap: () {
                      Get.toNamed(AppRoutes.msgInbox, arguments: {
                        'eventId': eventId,
                        'title': title,
                        'capacity': joinedCount,
                        'venueType': event['venueType'],
                        'onlineLink': event['onlineLink'],
                        'startDate': event['startDate'],
                        'startTime': event['startTime'],
                        'endDate': event['endDate'],
                        'endTime': event['endTime'],
                      });
                    },
                  );
                },
              ),
            ],
          );
        }),
      ],
    );
  }
}
