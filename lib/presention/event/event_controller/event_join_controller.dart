import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../event_widget/payment_webview.dart';

class EventJoinController extends GetxController {
  final RxBool isJoining = false.obs;

  Future<bool> joinEvent(String eventId, {bool isFree = true}) async {
    try {
      isJoining.value = true;
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        Get.back();
        Get.snackbar("Error", "You must be logged in.", backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }

      final endpoint = isFree ? Apiservices.participationJoin : Apiservices.participationPayCheckout;
      print("========== JOIN EVENT INITIATED ==========");
      print("Endpoint: $endpoint");
      print("Event ID: $eventId | Is Free: $isFree");
      print("Token Snippet: ${token.substring(0, 10)}...");

      final response = await GetConnect().post(
        endpoint,
        {"eventId": eventId},
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Get.back(); // close the loading dialog
      
      print("========== JOIN EVENT RAW RESPONSE ==========");
      print("Status Code: ${response.statusCode}");
      print("Status Text: ${response.statusText}");
      print("Response Body: ${response.body}");
      print("=============================================");

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (!isFree) {
          // Handle Premium checkout URL
          final responseBody = response.body;
          String? checkoutUrl;
          String? sessionId;
          
          if (responseBody is Map) {
             if (responseBody['data'] != null) {
                checkoutUrl = responseBody['data']['url'] ?? responseBody['data']['checkoutUrl'];
                sessionId = responseBody['data']['sessionId'] ?? responseBody['data']['id'];
             }
             checkoutUrl ??= responseBody['url'] ?? responseBody['checkoutUrl'];
             sessionId ??= responseBody['sessionId'];
          }
          
          print("Extracted Session ID: $sessionId");

          if (checkoutUrl != null) {
             if (checkoutUrl.contains('localhost') || checkoutUrl.contains('127.0.0.1')) {
                checkoutUrl = checkoutUrl.replaceAll('localhost', '10.0.2.2').replaceAll('127.0.0.1', '10.0.2.2');
             }
             print("Checkout URL after patching: $checkoutUrl");
             
             final result = await Get.to(() => PaymentWebView(url: checkoutUrl!));
             
             if (result == true) {
                // Intercepted Success! Now call confirm-checkout API
                if (sessionId != null) {
                   print("========== PAYMENT CONFIRMATION ==========");
                   print("API URL: ${Apiservices.baseUrl}participation/confirm-checkout");
                   print("Payload: {\"sessionId\": \"$sessionId\"}");
                   
                   Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
                   final confirmResponse = await GetConnect().post(
                     "${Apiservices.baseUrl}participation/confirm-checkout",
                     {"sessionId": sessionId},
                     headers: {
                       'Accept': 'application/json',
                       'Authorization': 'Bearer $token',
                     },
                   );
                   Get.back(); // close dialog
                   
                   print("Confirm Response Status: ${confirmResponse.statusCode}");
                   print("Confirm Response Body: ${confirmResponse.body}");
                   print("==========================================");
                   
                   if (confirmResponse.statusCode == 200 || confirmResponse.statusCode == 201) {
                      Get.snackbar("Success", "Payment confirmed successfully!", backgroundColor: Colors.green, colorText: Colors.white);
                   } else {
                      Get.snackbar("Notice", "Payment might be incomplete.", backgroundColor: Colors.orange, colorText: Colors.white);
                   }
                } else {
                   print("ERROR: sessionId is null! Cannot confirm payment.");
                   Get.snackbar("Success", "Payment processed!", backgroundColor: Colors.green, colorText: Colors.white);
                }
             } else {
                print("WebView closed by user or failed (result: $result).");
                Get.snackbar("Notice", "Checkout was closed or failed.", backgroundColor: Colors.orange, colorText: Colors.white);
             }
          } else {
             print("ERROR: Checkout URL is null!");
             Get.snackbar("Notice", "Payment link not found.", backgroundColor: Colors.orange, colorText: Colors.white);
          }
        } else {
          // Success for Free event
          Get.snackbar("Success", "Successfully joined the event!", backgroundColor: Colors.green, colorText: Colors.white);
        }
        return true;
      } else {
        final message = response.body?['message'] ?? 'Failed to join event';
        Get.snackbar(
          "Notice", 
          message, 
          backgroundColor: Colors.orange, 
          colorText: Colors.white
        );
        print("Join error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar("Error", "Something went wrong", backgroundColor: Colors.red, colorText: Colors.white);
      print("Exception joining event: $e");
      return false;
    } finally {
      isJoining.value = false;
    }
  }
}
