import 'package:get/get.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventHostController extends GetxController {
  final RxBool isLoadingPending = false.obs;
  final RxBool isReviewing = false.obs;
  final RxBool isFinalizing = false.obs;

  final RxList<dynamic> allParticipants = <dynamic>[].obs;
  final RxMap<String, dynamic> hostData = <String, dynamic>{}.obs;

  // 1. Get All Participants for Event
  Future<void> getEventParticipants(String eventId) async {
    try {
      isLoadingPending.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) return;

      final response = await GetConnect().get(
        Apiservices.eventParticipants(eventId),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null && data['participants'] != null) {
           allParticipants.value = data['participants'];
           hostData.value = data['host'] ?? {};
           
           // Fetch and map connections dynamically so UI reflects it immediately
           try {
             final pendingRes = await GetConnect().get("${Apiservices.baseUrl}/connection/pending", headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'});
             final connRes = await GetConnect().get("${Apiservices.baseUrl}/connection", headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'});
             
             List pending = [];
             if (pendingRes.statusCode == 200) pending = pendingRes.body?['data']?['requests'] ?? [];
             
             List allConns = [];
             if (connRes.statusCode == 200) allConns = connRes.body?['data']?['connections'] ?? [];
             
             for (var p in allParticipants) {
                final uid = p['user']?['id'] ?? p['user']?['_id'];
                if (uid == null) continue;
                
                // Check if in pending
                for (var req in pending) {
                   final reqUid = req['requester']?['id'] ?? req['requester']?['_id'];
                   final recvUid = req['receiver']?['id'] ?? req['receiver']?['_id'];
                   if (reqUid == uid || recvUid == uid) {
                      p['connectionStatus'] = 'PENDING';
                   }
                }
                
                // Check if already connected
                for (var c in allConns) {
                   final reqUid = c['requester']?['id'] ?? c['requester']?['_id'];
                   final recvUid = c['receiver']?['id'] ?? c['receiver']?['_id'];
                   final users = c['users'] as List?;
                   bool inUsers = false;
                   if (users != null) {
                      inUsers = users.any((u) => (u['id'] ?? u['_id']) == uid);
                   }
                   if (reqUid == uid || recvUid == uid || inUsers || (c['user']?['id'] == uid)) {
                      p['connectionStatus'] = 'CONNECTED';
                   }
                }
             }
           } catch (e) {
             print("Error fetching connection statuses: $e");
           }
           allParticipants.refresh();
        } else {
           allParticipants.clear();
           hostData.value = {};
        }
      } else {
        print("Failed to get participants: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching participants: $e");
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
        // successfully reviewed, optionally we can re-fetch or just update local
        final index = allParticipants.indexWhere((p) => (p['id'] == participantId || p['_id'] == participantId));
        if (index != -1) {
          allParticipants[index]['status'] = action;
          allParticipants[index]['paymentStatus'] = action == 'APPROVED' ? 'HELD_IN_ESCROW' : allParticipants[index]['paymentStatus'];
          allParticipants.refresh();
        }
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
