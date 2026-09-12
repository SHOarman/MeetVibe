import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meetvibe/presention/profile/profile_controller/profile_controller.dart' as prof;
import 'package:meetvibe/presention/message/message_controller/single_chat_controller.dart';

class SingleMsgInbox extends StatefulWidget {
  const SingleMsgInbox({super.key});

  @override
  State<SingleMsgInbox> createState() => _SingleMsgInboxState();
}

class _SingleMsgInboxState extends State<SingleMsgInbox> {
  final TextEditingController inputController = TextEditingController();
  late String targetUserId;
  late String title;
  late String avatarUrl;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    targetUserId = args?['targetUserId'] ?? '';
    title = args?['title'] ?? 'Chat';
    avatarUrl = args?['avatarUrl'] ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (targetUserId.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('accessToken') ?? '';
        final chatCtrl = Get.isRegistered<SingleChatController>() ? Get.find<SingleChatController>() : Get.put(SingleChatController());
        chatCtrl.fetchPrivateChat(targetUserId, token);
      }
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  // One-to-one chat doesn't need the participants sheet

  @override
  Widget build(BuildContext context) {
    const peachBg = Color(0xFFFFF9F5);
    const orangeCol = Color(0xFFEC6D43);
    
    final chatController = Get.isRegistered<SingleChatController>() ? Get.find<SingleChatController>() : Get.put(SingleChatController());
    final profController = Get.isRegistered<prof.ProfileController>() ? Get.find<prof.ProfileController>() : Get.put(prof.ProfileController());

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
            if (avatarUrl.isNotEmpty) ...[
              CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage(avatarUrl),
                onBackgroundImageError: (error, stackTrace) {},
              ),
              const SizedBox(height: 6),
            ],
            Text(
              "Private Message",
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        actions: [],
      ),
      body: Column(
        children: [
          // Chat Bubbles List
          Expanded(
            child: Obx(() {
              if (chatController.isLoading.value && chatController.messages.isEmpty) {
                 return const Center(child: CircularProgressIndicator());
              }
              if (chatController.messages.isEmpty) {
                 return const Center(child: Text("No messages yet. Be the first to say hi!"));
              }
              
              return ListView.builder(
                reverse: true, // Display latest at bottom by reversing list
                padding: const EdgeInsets.all(16.0),
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  // If list is descending (newest first), use it directly. If ascending (oldest first), reverse it.
                  // Most of our chat lists were ascending, so we reverse it to place newest at index 0 (bottom).
                  final reversedMessages = chatController.messages.reversed.toList();
                  final msg = reversedMessages[index];
                  final bool isOutgoing = msg.senderId == profController.userId.value;
                  
                  final bool isEventHost = false;

                  // Format time to 12-hour format e.g., 10:30 AM
                  int hour = msg.createdAt.hour;
                  String ampm = hour >= 12 ? 'PM' : 'AM';
                  if (hour > 12) hour -= 12;
                  if (hour == 0) hour = 12;
                  final timeStr = "${hour.toString()}:${msg.createdAt.minute.toString().padLeft(2, '0')} $ampm";
                  
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
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          msg.content,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            height: 1.4,
                                            color: const Color(0xFF374151),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        timeStr,
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: const Color(0xFF9CA3AF),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.done_all,
                                        size: 14,
                                        color: msg.isRead ? orangeCol : const Color(0xFF9CA3AF),
                                      ),
                                    ],
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
                            onBackgroundImageError: (error, stackTrace) {},
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
                            onBackgroundImageError: (error, stackTrace) {},
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
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          msg.content,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            height: 1.4,
                                            color: const Color(0xFF374151),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        timeStr,
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: const Color(0xFF9CA3AF),
                                        ),
                                      ),
                                    ],
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
                              controller: inputController,
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
                                  final text = inputController.text;
                                  if (text.trim().isNotEmpty) {
                                     inputController.clear();
                                     chatController.sendPrivateMessage(targetUserId, text, token);
                                  }
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
                      final text = inputController.text;
                      if (text.trim().isNotEmpty) {
                        inputController.clear();
                        chatController.sendPrivateMessage(targetUserId, text, token);
                      }
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
