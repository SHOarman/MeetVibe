import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';

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
  final String id;
  final String name;
  final String meetupName;
  final int mutualConnections;
  final String timeAgo;
  final String avatarPath;

  ConnectionRequest({
    required this.id,
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

  @override
  void onInit() {
    super.onInit();
    fetchPendingConnections();
  }

  Future<void> fetchPendingConnections() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token == null) return;
      
      final String url = "${Apiservices.baseUrl}/connection/pending".replaceAll(RegExp(r'/{2,}'), '/').replaceFirst(':/', '://'); 
      // replaceAll is just to prevent double slashes before api

      final response = await GetConnect().get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null && data['requests'] != null) {
          final List requests = data['requests'];
          connectionRequests.clear();
          for (var req in requests) {
             final user = req['requester'] ?? req['user'] ?? req['from'] ?? {};
             final String image = user['image'] ?? user['profileImage'] ?? '';
             
             connectionRequests.add(
               ConnectionRequest(
                 id: req['id'] ?? req['_id'] ?? '',
                 name: user['name'] ?? user['username'] ?? 'Unknown User',
                 meetupName: "Vibe Connection", // Dynamic value based on API if present
                 mutualConnections: 0,
                 timeAgo: "Recently", 
                 avatarPath: image.isNotEmpty ? Apiservices.fixImageUrl(image) : 'assets/image/Avatar (1).png',
               )
             );
          }
        }
      }
    } catch (e) {
      print("Error fetching connection requests: $e");
    }
  }

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
  final RxList<ConnectionRequest> connectionRequests = <ConnectionRequest>[].obs;

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

  Future<void> respondToRequest(ConnectionRequest request, String action) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token == null) return;

      final response = await GetConnect().post(
        Apiservices.connectionRespond,
        {
          "connectionId": request.id,
          "action": action
        },
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        connectionRequests.remove(request);
        Get.snackbar(
          action == 'ACCEPTED' ? "Request Accepted" : "Request Ignored",
          action == 'ACCEPTED' ? "You are now connected with ${request.name}" : "Ignored connection request from ${request.name}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: action == 'ACCEPTED' ? const Color(0xFF10B981) : const Color(0xFF374151),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar("Error", response.body?['message'] ?? "Action failed", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Network connection failed", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void acceptRequest(ConnectionRequest request) {
    respondToRequest(request, "ACCEPTED");
  }

  void ignoreRequest(ConnectionRequest request) {
    respondToRequest(request, "REJECTED");
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
