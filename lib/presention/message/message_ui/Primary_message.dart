import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:meetvibe/presention/message/message_widget/message_tile.dart';

import 'package:meetvibe/presention/message/message_ui/single_msg_inbox.dart';
import 'package:meetvibe/presention/message/message_controller/single_chat_controller.dart';
import 'package:meetvibe/presention/profile/profile_controller/profile_controller.dart' as prof;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';

class PrimaryMessage extends StatelessWidget {
  const PrimaryMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final SingleChatController singleChatCtrl = Get.isRegistered<SingleChatController>() ? Get.find<SingleChatController>() : Get.put(SingleChatController());
    final profController = Get.isRegistered<prof.ProfileController>() ? Get.find<prof.ProfileController>() : Get.put(prof.ProfileController());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';
      if (token.isNotEmpty && singleChatCtrl.myConnections.isEmpty && !singleChatCtrl.isLoading.value) {
         singleChatCtrl.fetchConnections(token);
         singleChatCtrl.fetchConversations(token);
      }
    });

    return Obx(() {
      if (singleChatCtrl.isLoading.value && singleChatCtrl.myConnections.isEmpty) {
        return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
      }
      
      if (singleChatCtrl.myConnections.isEmpty) {
        return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No connections yet. Connect with event participants!")));
      }

      return ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: singleChatCtrl.myConnections.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFF3F3F3),
        ),
        itemBuilder: (context, index) {
          final conn = singleChatCtrl.myConnections[index];
          final String currentUserId = profController.userId.value;
          
          Map<String, dynamic> friendData = {};
          
          // Bulletproof extraction of friend data
          final possibleFriends = [
            conn['requester'], conn['receiver'], conn['sender'], conn['user'], conn['friend'],
            conn['requesterId'], conn['receiverId'], conn['senderId'], conn['userId'],
          ];

          for (var pf in possibleFriends) {
            if (pf != null && pf is Map) {
              final id = pf['id'] ?? pf['_id']?.toString();
              if (id != null && id.toString() != currentUserId) {
                friendData = pf as Map<String, dynamic>;
                break;
              }
            }
          }

          if (friendData.isEmpty && conn['users'] != null && conn['users'] is List) {
             final users = conn['users'] as List;
             friendData = users.firstWhere((u) => (u['id'] ?? u['_id']) != currentUserId, orElse: () => {});
          }

          String friendId = friendData['id'] ?? friendData['_id'] ?? '';
          
          // If we couldn't find an object, maybe it's just strings on the root object
          if (friendId.isEmpty) {
             final stringKeys = ['requesterId', 'receiverId', 'senderId', 'userId', 'requester', 'receiver'];
             for (var k in stringKeys) {
                if (conn[k] != null && conn[k] is String && conn[k] != currentUserId) {
                   friendId = conn[k];
                   break;
                }
             }
          }

          final friendName = friendData['name'] ?? friendData['username'] ?? 'Connected User';
          final friendImage = friendData['image'] ?? friendData['profileImage'] ?? '';
          final String avatarSource = friendImage.isNotEmpty ? Apiservices.fixImageUrl(friendImage) : '';

          String lastMsgStr = "Connected";
          String msgTime = "";
          
          // First check if there's an active conversation from /chat/conversations
          Map<String, dynamic>? activeConv;
          final currentConnId = (conn['id'] ?? conn['_id'])?.toString();
          
          for (var conv in singleChatCtrl.conversations) {
             if (conv != null && conv is Map) {
                // Primary check: match by connectionId
                if (currentConnId != null && conv['connectionId']?.toString() == currentConnId) {
                   activeConv = conv as Map<String, dynamic>;
                   break;
                }

                // Fallback check: match by friend ID
                final pt = conv['participant'] ?? conv['user'] ?? conv['friend'];
                if (pt != null && (pt['id'] ?? pt['_id']?.toString()) == friendId) {
                   activeConv = conv as Map<String, dynamic>;
                   break;
                }
                if (conv['users'] != null && conv['users'] is List) {
                   bool match = (conv['users'] as List).any((u) => (u['id'] ?? u['_id']?.toString()) == friendId);
                   if (match) {
                      activeConv = conv as Map<String, dynamic>;
                      break;
                   }
                }
             }
          }

          // Decide the source of the last message
          final dynamic sourceHasMessage = activeConv ?? conn;

          bool isFromMe = false;
          bool isRead = false;
          int parsedUnread = 0;

          if (sourceHasMessage != null && sourceHasMessage is Map) {
             parsedUnread = int.tryParse(sourceHasMessage['unreadCount']?.toString() ?? '0') ?? 0;
          }

          if (sourceHasMessage['lastMessage'] != null) {
            if (sourceHasMessage['lastMessage'] is Map) {
              final lastMsg = sourceHasMessage['lastMessage'];
              lastMsgStr = lastMsg['content'] ?? lastMsg['message'] ?? "Connected";
              isFromMe = (lastMsg['senderId']?.toString() == currentUserId) || (lastMsg['sender']?.toString() == currentUserId);
              isRead = lastMsg['isRead'] == true || lastMsg['isRead'] == 'true';
              
              if (lastMsg['createdAt'] != null) {
                  try {
                      DateTime dt = DateTime.parse(sourceHasMessage['lastMessage']['createdAt']).toLocal();
                      int h = dt.hour;
                      String a = h >= 12 ? 'PM' : 'AM';
                      if(h>12) h-=12; if(h==0)h=12;
                      msgTime = "$h:${dt.minute.toString().padLeft(2,'0')} $a";
                  } catch(e) {}
              }
            } else if (sourceHasMessage['lastMessage'] is String) {
              lastMsgStr = sourceHasMessage['lastMessage'];
            }
          } else if (sourceHasMessage['recentMessage'] != null) {
             if (sourceHasMessage['recentMessage'] is Map) {
                final recMsg = sourceHasMessage['recentMessage'];
                lastMsgStr = recMsg['content'] ?? recMsg['message'] ?? "Connected";
                isFromMe = (recMsg['senderId']?.toString() == currentUserId) || (recMsg['sender']?.toString() == currentUserId);
                isRead = recMsg['isRead'] == true || recMsg['isRead'] == 'true';
                
                if (recMsg['createdAt'] != null) {
                    try {
                        DateTime dt = DateTime.parse(sourceHasMessage['recentMessage']['createdAt']).toLocal();
                        int h = dt.hour;
                        String a = h >= 12 ? 'PM' : 'AM';
                        if(h>12) h-=12; if(h==0)h=12;
                        msgTime = "$h:${dt.minute.toString().padLeft(2,'0')} $a";
                    } catch(e) {}
                }
             }
          } else if (conn['requestMessage'] != null && conn['requestMessage'].toString().isNotEmpty) {
            lastMsgStr = conn['requestMessage'].toString();
          }

          return CustomMessageTile(
            name: friendName,
            avatar: avatarSource,
            lastMessage: lastMsgStr,
            time: msgTime,
            isOnline: false,
            isTyping: false,
            unreadCount: parsedUnread,
            isLastMessageFromMe: isFromMe,
            isLastMessageRead: isRead,
            hasAttachment: false,
            onTap: () {
               Get.to(() => const SingleMsgInbox(), arguments: {
                 'targetUserId': friendId,
                 'title': friendName,
                 'avatarUrl': avatarSource,
               });
            },
          );
        },
      );
    });
  }
}
