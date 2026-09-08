import 'package:get/get.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventHostController extends GetxController {
  final RxBool isLoadingPending = false.obs;
  final RxBool isReviewing = false.obs;
  final RxBool isFinalizing = false.obs;

  final RxList<dynamic> pendingParticipants = <dynamic>[].obs;

  // 1. Get Pending Payments for Event
  Future<void> getPendingPayments(String eventId) async {
    try {
      isLoadingPending.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) return;

      final response = await GetConnect().get(
        Apiservices.participationPendingPayments(eventId),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null && data is List) {
           pendingParticipants.value = data;
        } else if (response.body is List) {
           pendingParticipants.value = response.body;
        } else {
           pendingParticipants.clear();
        }
      } else {
        print("Failed to get pending payments: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching pending payments: $e");
    } finally {
      isLoadingPending.value = false;
    }
  }

  // 2. Host Review Offline Payment
  Future<bool> reviewPayment(String participantId, String action) async {
    try {
      isReviewing.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) return false;

      final response = await GetConnect().post(
        Apiservices.participationReview,
        {
          "participantId": participantId,
          "action": action // e.g. "APPROVED"
        },
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        // successfully reviewed
        pendingParticipants.removeWhere((p) => p['id'] == participantId || p['_id'] == participantId);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error reviewing payment: $e");
      return false;
    } finally {
      isReviewing.value = false;
    }
  }

  // 3. Finalize Attendance & Release Escrow
  // attendance format: [{"userId": "string", "attended": true}]
  Future<bool> finalizeAttendance(String eventId, List<Map<String, dynamic>> attendance) async {
    try {
      isFinalizing.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) return false;

      final response = await GetConnect().post(
        Apiservices.participationFinalize(eventId),
        {
          "attendance": attendance
        },
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Finalize error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error finalizing attendance: $e");
      return false;
    } finally {
      isFinalizing.value = false;
    }
  }
}
