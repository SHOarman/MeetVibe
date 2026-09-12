import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/presention/message/message_controller/msgcontroller.dart';
import 'package:meetvibe/presention/event/event_controller/event_host_controller.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meetvibe/presention/profile/profile_controller/profile_controller.dart' as prof;
import 'package:meetvibe/presention/message/message_controller/group_chat_controller.dart';

class MsgInbox extends StatelessWidget {
  const MsgInbox({super.key});

  void _showParticipantsSheet(BuildContext context, String eventId) {
    final eventHostController = Get.isRegistered<EventHostController>() 
        ? Get.find<EventHostController>() 
        : Get.put(EventHostController());
    final msgController = Get.find<MsgController>();
    final profileController = Get.isRegistered<prof.ProfileController>() ? Get.find<prof.ProfileController>() : Get.put(prof.ProfileController());

    eventHostController.getEventParticipants(eventId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 15),
                Text("Send Connection Request", style: AppTextStyle.outfit(size: 16, weight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 10),
                Expanded(
                  child: Obx(() {
                    if (eventHostController.isLoadingPending.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    final currentUserId = profileController.userId.value;
                    final hostData = eventHostController.hostData;
                    final hostId = hostData['id'] ?? hostData['_id'] ?? '';
                    
                    List<dynamic> allMembers = List.from(eventHostController.allParticipants);
                    bool hostExists = allMembers.any((p) {
                      final u = p['user'] ?? {};
                      return (u['id'] ?? u['_id']) == hostId;
                    });
                    
                    if (!hostExists && hostId.isNotEmpty) {
                       allMembers.insert(0, {
                         'user': hostData,
                         'isHost': true,
                       });
                    }
                    
                    for (var p in allMembers) {
                       final u = p['user'] ?? {};
                       if ((u['id'] ?? u['_id']) == hostId) {
                           p['isHost'] = true;
                       }
                    }

                    final participants = allMembers
                        .where((p) => (p['user']?['id'] ?? p['user']?['_id']) != currentUserId)
                        .toList();

                    if (participants.isEmpty) {
                      return const Center(child: Text("No other members available."));
                    }
                    return ListView.separated(
                      controller: scrollController,
                      itemCount: participants.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final participant = participants[index];
                        // Safely extract the target user object
                        var user = participant;
                        if (participant['user'] != null && participant['user'] is Map) {
                           user = participant['user'];
                        }
                        
                        final String userId = (user['id'] ?? user['_id'] ?? participant['userId'] ?? participant['receiverId'] ?? participant['id'] ?? participant['_id'] ?? '').toString();
                        final String userName = (user['name'] ?? participant['name'] ?? 'Unknown User').toString();
                        final image = user['image'] ?? user['profileImage'];
                        final bool isHost = participant['isHost'] == true;
                        
                        // We use a local state builder for the button to immediately reflect "Request Sent" after tap
                        return StatefulBuilder(
                          builder: (context, setState) {
                            String connStatus = participant['connectionStatus'] ?? user['connectionStatus'] ?? 'NONE';
                            bool isLoadingRequest = false;
                            String? errorStatus;

                            Widget buildActionButton() {
                              if (errorStatus != null) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(6)),
                                  child: Text(errorStatus!, style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                                );
                              }
                              
                              if (connStatus == 'CONNECTED' || connStatus == 'ACCEPTED' || connStatus == 'ADDED') {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
                                  child: const Text("Connected", style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold)),
                                );
                              } else if (connStatus == 'PENDING') {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
                                  child: const Text("Pending", style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold)),
                                );
                              }

                              return TextButton(
                                onPressed: isLoadingRequest ? null : () async {
                                  setState(() => isLoadingRequest = true);
                                  try {
                                    final prefs = await SharedPreferences.getInstance();
                                    final token = prefs.getString('accessToken');
                                    final payload = {
                                      "receiverId": userId,
                                      "requestMessage": "Hey! Let's connect!"
                                    };
                                    print("--- SENDING CONNECTION REQUEST ---");
                                    print("URL: ${Apiservices.connectionRequest}");
                                    print("Payload: $payload");

                                    final response = await GetConnect().post(
                                      Apiservices.connectionRequest,
                                      payload,
                                      headers: {
                                        'Accept': 'application/json',
                                        if (token != null) 'Authorization': 'Bearer $token',
                                      }
                                    );

                                    print("--- CONNECTION REQUEST RESPONSE ---");
                                    print("Code: ${response.statusCode}");
                                    print("Body: ${response.body}");
                                    if (response.statusCode == 200 || response.statusCode == 201) {
                                      setState(() => connStatus = 'PENDING');
                                      if (participant['user'] != null && participant['user'] is Map) {
                                         participant['user']['connectionStatus'] = 'PENDING';
                                      }
                                      Get.snackbar("Success", "Request sent to $userName!", backgroundColor: Colors.green, colorText: Colors.white);
                                    } else {
                                      final errorMsg = response.body?['message']?.toString() ?? "Could not send request.";
                                      if (errorMsg.toUpperCase().contains('PENDING')) {
                                        setState(() => connStatus = 'PENDING');
                                      } else if (errorMsg.toUpperCase().contains('ACCEPTED') || errorMsg.toUpperCase().contains('CONNECTED')) {
                                        setState(() => connStatus = 'CONNECTED');
                                      } else {
                                        setState(() => errorStatus = errorMsg);
                                        Future.delayed(const Duration(seconds: 2), () {
                                           if (context.mounted) setState(() => errorStatus = null);
                                        });
                                      }
                                    }
                                  } catch (e) {
                                    setState(() => errorStatus = "Network Error");
                                    Future.delayed(const Duration(seconds: 2), () {
                                       if (context.mounted) setState(() => errorStatus = null);
                                    });
                                  } finally {
                                    if (context.mounted) setState(() => isLoadingRequest = false);
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFEC6D43),
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  minimumSize: const Size(60, 30),
                                ),
                                child: isLoadingRequest 
                                   ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                   : const Text("Send Connect", style: TextStyle(color: Colors.white, fontSize: 12)),
                              );
                            }

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ClipOval(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  color: Colors.grey.shade300,
                                  child: image != null && image.isNotEmpty 
                                      ? Image.network(
                                          Apiservices.fixImageUrl(image),
                                          fit: BoxFit.cover,
                                          errorBuilder: (ctx, err, tr) => Image.asset('assets/image/Avatar (1).png', fit: BoxFit.cover),
                                        )
                                      : Image.asset('assets/image/Avatar (1).png', fit: BoxFit.cover),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Flexible(child: Text(userName, style: AppTextStyle.outfit(size: 14, weight: FontWeight.w600, color: Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                  if (isHost) ...[
                                     const SizedBox(width: 6),
                                     Container(
                                       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                       decoration: BoxDecoration(color: const Color(0xFFEC6D43).withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                                       child: const Text("Host", style: TextStyle(color: Color(0xFFEC6D43), fontSize: 10, fontWeight: FontWeight.bold)),
                                     )
                                  ]
                                ],
                              ),
                              trailing: buildActionButton(),
                            );
                          }
                        );
                      },
                    );
                  }),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const peachBg = Color(0xFFFFF9F5);
    const orangeCol = Color(0xFFEC6D43);
    
    final groupController = Get.isRegistered<GroupChatController>() ? Get.find<GroupChatController>() : Get.put(GroupChatController());
    final profController = Get.isRegistered<prof.ProfileController>() ? Get.find<prof.ProfileController>() : Get.put(prof.ProfileController());
    final eventHost = Get.isRegistered<EventHostController>() ? Get.find<EventHostController>() : Get.put(EventHostController());

    final args = Get.arguments as Map<String, dynamic>?;
    final String eventId = args?['eventId'] ?? '';
    final String title = args?['title'] ?? 'Event Chat';
    final int capacity = args?['capacity'] ?? 0;

    // Fetch initial chat and participants when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (eventId.isNotEmpty && groupController.messages.isEmpty && !groupController.isLoading.value) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('accessToken') ?? '';
        groupController.fetchGroupChat(eventId, token);
        eventHost.getEventParticipants(eventId);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0C0A09)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0C0A09),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "$capacity members",
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (eventId.isNotEmpty) {
                    _showParticipantsSheet(context, eventId);
                  }
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0x1D000000)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.grid_view_rounded,
                    color: orangeCol,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Bubbles List
          Expanded(
            child: Obx(() {
              if (groupController.isLoading.value && groupController.messages.isEmpty) {
                 return const Center(child: CircularProgressIndicator());
              }
              if (groupController.messages.isEmpty) {
                 return const Center(child: Text("No messages yet. Be the first to say hi!"));
              }
              
              return ListView.builder(
                reverse: true, // Display latest at bottom by reversing list
                padding: const EdgeInsets.all(16.0),
                itemCount: groupController.messages.length,
                itemBuilder: (context, index) {
                  // We reverse the index since ListView is reversed
                  final msg = groupController.messages[groupController.messages.length - 1 - index];
                  final bool isOutgoing = msg.senderId == profController.userId.value;
                  
                  final hostId = eventHost.hostData['id'] ?? eventHost.hostData['_id'] ?? '';
                  final bool isEventHost = msg.senderId.isNotEmpty && msg.senderId == hostId;

                  final timeStr = "${msg.createdAt.hour.toString().padLeft(2, '0')}:${msg.createdAt.minute.toString().padLeft(2, '0')}";
                  final avatarSource = msg.senderAvatar.isNotEmpty ? Apiservices.fixImageUrl(msg.senderAvatar) : null;

                  if (isOutgoing) {
                    // Outgoing Message (Micheal Gough)
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 32),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: peachBg,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                border: Border.all(color: const Color(0xFFFCE8E6), width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            msg.senderName,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF0C0A09),
                                            ),
                                          ),
                                          if (isEventHost) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFEC6D43).withOpacity(0.15),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                "Host",
                                                style: TextStyle(color: Color(0xFFEC6D43), fontSize: 9, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      Text(
                                        timeStr,
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: const Color(0xFF9CA3AF),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    msg.content,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      height: 1.4,
                                      color: const Color(0xFF374151),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: avatarSource != null ? NetworkImage(avatarSource) as ImageProvider : const AssetImage('assets/image/Avatar (2).png'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Incoming Message (Bonnie Green)
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: avatarSource != null ? NetworkImage(avatarSource) as ImageProvider : const AssetImage('assets/image/Avatar (1).png'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: peachBg,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                border: Border.all(color: const Color(0xFFFCE8E6), width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            msg.senderName,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF0C0A09),
                                            ),
                                          ),
                                          if (isEventHost) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFEC6D43).withOpacity(0.15),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                "Host",
                                                style: TextStyle(color: Color(0xFFEC6D43), fontSize: 9, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      Text(
                                        timeStr,
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: const Color(0xFF9CA3AF),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    msg.content,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      height: 1.4,
                                      color: const Color(0xFF374151),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 32),
                        ],
                      ),
                    );
                  }
                },
              );
            }),
          ),

          // Bottom Input Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.add,
                            color: orangeCol,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: groupController.inputController,
                              decoration: InputDecoration(
                                hintText: "Write message...",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF9CA3AF),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              style: GoogleFonts.poppins(fontSize: 13),
                              onSubmitted: (_) async {
                                final prefs = await SharedPreferences.getInstance();
                                final token = prefs.getString('accessToken') ?? '';
                                final text = groupController.inputController.text;
                                groupController.inputController.clear();
                                groupController.sendGroupMessage(eventId, text, token);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('accessToken') ?? '';
                      final text = groupController.inputController.text;
                      groupController.inputController.clear();
                      groupController.sendGroupMessage(eventId, text, token);
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.send_rounded,
                        color: orangeCol,
                        size: 20,
                      ),
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
