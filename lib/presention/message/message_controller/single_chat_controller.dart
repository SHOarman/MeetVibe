import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meetvibe/presention/message/message_model/chat_message_model.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleChatController extends GetxController {
  var isLoading = false.obs;
  var messages = <ChatMessageModel>[].obs;
  
  // List of conversation objects for Primary/All tags
  var conversations = <dynamic>[].obs;
  
  // List of connections for Primary message tab
  var myConnections = <dynamic>[].obs;

  String get baseUrl => Apiservices.baseUrl.endsWith('/') ? Apiservices.baseUrl.substring(0, Apiservices.baseUrl.length - 1) : Apiservices.baseUrl;

  // Conversations history list
  Future<void> fetchConversations(String token) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('$baseUrl/chat/conversations'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final convList = data['data']?['conversations'] ?? data['conversations'] ?? [];
        conversations.value = convList;
      } else {
        print('Conversation API error: ${response.statusCode}');
      }
    } catch (e) {
      print('Conversation lookup error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Connections history list
  Future<void> fetchConnections(String token) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('$baseUrl/connection'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final connList = data['data']?['connections'] ?? data['connections'] ?? [];
        myConnections.value = connList;
      } else {
        print('Connection API error: ${response.statusCode}');
      }
    } catch (e) {
      print('Connection lookup error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Private History for a specific user
  Future<void> fetchPrivateChat(String targetUserId, String token) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('$baseUrl/chat/private/$targetUserId'),
        headers: {'Authorization': 'Bearer $token', 'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var list = data['data']?['messages'] ?? data['messages'] ?? [];
        messages.value = (list as List).map((e) => ChatMessageModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Single chat history error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Send single private message
  Future<void> sendPrivateMessage(String targetUserId, String messageText, String token) async {
    if (messageText.trim().isEmpty) return;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/private/$targetUserId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'message': messageText}),
      );

      if (response.statusCode == 201) {
        await fetchPrivateChat(targetUserId, token);
        await fetchConversations(token);
      } else {
        print('Send private msg failed: ${response.body}');
        Get.snackbar('Error', 'Private message sending failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Networking Error: $e');
    }
  }
}
