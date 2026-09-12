import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meetvibe/presention/message/message_model/chat_message_model.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';

class GroupChatController extends GetxController {
  final TextEditingController inputController = TextEditingController();
  var isLoading = false.obs;
  var messages = <ChatMessageModel>[].obs;
  var participants = <dynamic>[].obs;
  
  String get baseUrl => Apiservices.baseUrl.endsWith('/') ? Apiservices.baseUrl.substring(0, Apiservices.baseUrl.length - 1) : Apiservices.baseUrl;

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  Future<void> fetchGroupChat(String eventId, String token) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('$baseUrl/chat/group/$eventId'),
        headers: {'Authorization': 'Bearer $token', 'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Parse messages safety
        var list = data['data']?['messages'] ?? data['messages'] ?? [];
        messages.value = (list as List).map((e) => ChatMessageModel.fromJson(e)).toList();

        // Parse participants safety
        final participantsList = data['data']?['participants'] ?? data['participants'] ?? [];
        participants.value = participantsList;
      } else {
        print('Group Chat API error: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load group chat: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Send Message locally and push to REST
  Future<void> sendGroupMessage(String eventId, String messageText, String token) async {
    if (messageText.trim().isEmpty) return;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/group/$eventId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'message': messageText}),
      );

      if (response.statusCode == 201) {
        // Fetch to refresh list, or can append locally if desired
        await fetchGroupChat(eventId, token);
      } else {
        print('Send group message failed: ${response.body}');
        Get.snackbar('Error', 'Message could not be sent');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e');
    }
  }
}
