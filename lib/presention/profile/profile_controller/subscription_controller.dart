import 'package:get/get.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';
import 'package:meetvibe/core/route/app_routes.dart';

class SubscriptionController extends GetxController {
  final RxBool isLoading = false.obs;
  
  // Subscription Data
  final RxBool isActive = false.obs;
  final RxnString expirationDate = RxnString(null);
  final RxnString statusDetails = RxnString(null);

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptionStatus();
  }

  Future<void> fetchSubscriptionStatus({bool isRetry = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) return;

      if (!isRetry) isLoading.value = true;

      final response = await GetConnect().get(
        Apiservices.subscriptionStatus,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );

      print("Subscription API Status: ${response.statusCode}");
      print("Subscription API Body: ${response.body}");

      if (response.statusCode == 200) {
        // Handle varying response structures robustly
        final responseData = response.body;
        final dataWrapper = responseData != null && responseData is Map ? responseData['data'] : null;

        final targetMap = (dataWrapper != null && dataWrapper is Map) ? dataWrapper : (responseData is Map ? responseData : {});

        isActive.value = targetMap['isActive'] == true || targetMap['status'] == 'active' || targetMap['status'] == 'ACTIVE';
        expirationDate.value = targetMap['expirationDate']?.toString() ?? targetMap['currentPeriodEnd']?.toString();
        statusDetails.value = targetMap['status']?.toString();
      } else if (response.statusCode == 401 && !isRetry) {
        print("Subscription GET 401: Attempting token refresh...");
        final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());
        final refreshed = await authController.refreshTokenAPI();
        
        if (refreshed) {
           await fetchSubscriptionStatus(isRetry: true);
        } else {
           Get.snackbar('Session Expired', 'Please login again.');
           Get.offAllNamed(AppRoutes.login);
        }
      } else if (response.statusCode == null && !isRetry) {
        print("Subscription GET Network Error: Retrying...");
        await Future.delayed(const Duration(seconds: 2));
        await fetchSubscriptionStatus(isRetry: true);
      } else {
        Get.snackbar(
          'Error', 
          'Failed to load subscription status.', 
          snackPosition: SnackPosition.BOTTOM
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Error: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (!isRetry) isLoading.value = false;
    }
  }
}
