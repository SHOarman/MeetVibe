import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessage {
  final String senderName;
  final String time;
  final String content;
  final String avatarPath;
  final bool isOutgoing;

  ChatMessage({
    required this.senderName,
    required this.time,
    required this.content,
    required this.avatarPath,
    this.isOutgoing = false,
  });
}

class ConnectionRequest {
  final String name;
  final String meetupName;
  final int mutualConnections;
  final String timeAgo;
  final String avatarPath;

  ConnectionRequest({
    required this.name,
    required this.meetupName,
    required this.mutualConnections,
    required this.timeAgo,
    required this.avatarPath,
  });
}

class MsgController extends GetxController {
  // Tab Management
  final RxInt selectedTabIndex = 0.obs;

  // Active Chats Lists (All)
  final RxList<Map<String, dynamic>> allChats = <Map<String, dynamic>>[
    {
      'name': 'Roberta Casas',
      'avatar': 'assets/image/Avatar.png',
      'lastMessage': 'Typing...',
      'time': '14:23',
      'isOnline': true,
      'isTyping': true,
      'unreadCount': 0,
      'hasAttachment': false,
    },
    {
      'name': 'Leslie Livingston',
      'avatar': 'assets/image/Avatar (1).png',
      'lastMessage': 'Yes, we can do this! 🔥',
      'time': '18:05',
      'isOnline': false,
      'isTyping': false,
      'unreadCount': 0,
      'hasAttachment': false,
    },
    {
      'name': 'Micheal Gough',
      'avatar': 'assets/image/Avatar (2).png',
      'lastMessage': 'Nvm, I will grab all in maxi...',
      'time': '07:45',
      'isOnline': true,
      'isTyping': false,
      'unreadCount': 0,
      'hasAttachment': false,
    },
    {
      'name': 'Bonnie Green',
      'avatar': 'assets/image/Avatar (3).png',
      'lastMessage': 'Photo',
      'time': '3h',
      'isOnline': false,
      'isTyping': false,
      'unreadCount': 0,
      'hasAttachment': true,
    },
    {
      'name': 'Lana Byrd',
      'avatar': 'assets/image/Avatar (4).png',
      'lastMessage': 'Awesome, let\'s go!',
      'time': '5h',
      'isOnline': true,
      'isTyping': false,
      'unreadCount': 0,
      'hasAttachment': false,
    },
    {
      'name': 'Helene Engels',
      'avatar': 'assets/image/Ellipse 13 (1).png',
      'lastMessage': 'Yes, we can do this! 🔥',
      'time': '8h',
      'isOnline': false,
      'isTyping': false,
      'unreadCount': 0,
      'hasAttachment': false,
    },
    {
      'name': 'Karen Nelson',
      'avatar': 'assets/image/Ellipse 14 (1).png',
      'lastMessage': 'Nvm, I will grab all in maxi...',
      'time': 'yesterday',
      'isOnline': true,
      'isTyping': false,
      'unreadCount': 2,
      'hasAttachment': false,
    },
  ].obs;

  // Active Chats Lists (Primary)
  final RxList<Map<String, dynamic>> primaryChats = <Map<String, dynamic>>[
    {
      'name': 'Roberta Casas',
      'avatar': 'assets/image/Avatar.png',
      'lastMessage': 'Typing...',
      'time': '14:23',
      'isOnline': true,
      'isTyping': true,
      'unreadCount': 0,
      'hasAttachment': false,
    },
    {
      'name': 'Lana Byrd',
      'avatar': 'assets/image/Avatar (4).png',
      'lastMessage': 'Awesome, let\'s go!',
      'time': '5h',
      'isOnline': true,
      'isTyping': false,
      'unreadCount': 0,
      'hasAttachment': false,
    },
    {
      'name': 'Karen Nelson',
      'avatar': 'assets/image/Ellipse 14 (1).png',
      'lastMessage': 'Nvm, I will grab all in maxi...',
      'time': 'yesterday',
      'isOnline': true,
      'isTyping': false,
      'unreadCount': 2,
      'hasAttachment': false,
    },
    {
      'name': 'Robert Brown',
      'avatar': 'assets/image/Ellipse 15 (1).png',
      'lastMessage': 'Nvm, I will grab all in maxi...',
      'time': '1 week',
      'isOnline': true,
      'isTyping': false,
      'unreadCount': 0,
      'hasAttachment': false,
    },
  ].obs;

  // Connection Requests
  final RxList<ConnectionRequest> connectionRequests = <ConnectionRequest>[
    ConnectionRequest(
      name: "Helene Engels",
      meetupName: "Coffee Networking Meetup",
      mutualConnections: 3,
      timeAgo: "8h",
      avatarPath: "assets/image/Avatar (2).png",
    ),
    ConnectionRequest(
      name: "Alex Mercer",
      meetupName: "Tech Startup Summit",
      mutualConnections: 5,
      timeAgo: "12h",
      avatarPath: "assets/image/Avatar (1).png",
    ),
    ConnectionRequest(
      name: "Sophia Vance",
      meetupName: "Design Portfolio Review",
      mutualConnections: 2,
      timeAgo: "1d",
      avatarPath: "assets/image/Avatar (3).png",
    ),
  ].obs;

  // Inbox Chat Messages (Coffee Networking Meetup)
  final RxList<ChatMessage> inboxMessages = <ChatMessage>[
    ChatMessage(
      senderName: "Bonnie Green",
      time: "11:46",
      content: "Hello there,\n\nWe need to have a meeting to discuss the latest changes to be able to launch the product, please confirm when you are available.\n\nThank you",
      avatarPath: "assets/image/Avatar (3).png",
    ),
    ChatMessage(
      senderName: "Micheal Gough",
      time: "11:46",
      content: "I will immediately send you a calendar where you will see the times when I would be available for a call.",
      avatarPath: "assets/image/Avatar (2).png",
      isOutgoing: true,
    ),
  ].obs;

  // Text controller for inbox input
  final TextEditingController inputController = TextEditingController();

  void acceptRequest(ConnectionRequest request) {
    connectionRequests.remove(request);
    Get.snackbar(
      "Request Accepted",
      "You are now connected with ${request.name}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
    );
  }

  void ignoreRequest(ConnectionRequest request) {
    connectionRequests.remove(request);
    Get.snackbar(
      "Request Ignored",
      "Ignored connection request from ${request.name}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF374151),
      colorText: Colors.white,
    );
  }

  void sendInboxMessage() {
    final text = inputController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    inboxMessages.add(
      ChatMessage(
        senderName: "Micheal Gough",
        time: timeStr,
        content: text,
        avatarPath: "assets/image/Avatar (2).png",
        isOutgoing: true,
      ),
    );

    inputController.clear();
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
}
