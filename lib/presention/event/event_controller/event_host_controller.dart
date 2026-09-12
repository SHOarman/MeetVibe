import 'dart:convert';
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
             final sentRes = await GetConnect().get("${Apiservices.baseUrl}/connection/sent", headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'});
             final connRes = await GetConnect().get("${Apiservices.baseUrl}/connection", headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'});
             
             List pending = [];
             if (pendingRes.statusCode == 200) pending.addAll(pendingRes.body?['data']?['requests'] ?? []);
             if (sentRes.statusCode == 200) pending.addAll(sentRes.body?['data']?['requests'] ?? []);
             
             List allConns = [];
             if (connRes.statusCode == 200) allConns = connRes.body?['data']?['connections'] ?? [];
             
             // Helper function to extract all possible IDs from a connection/request object
             List<String> extractIds(dynamic obj) {
                List<String> ids = [];
                final keys = ['requester', 'receiver', 'sender', 'user', 'friend', 'requesterId', 'receiverId', 'senderId', 'userId'];
                for (var k in keys) {
                  if (obj[k] != null) {
                     if (obj[k] is Map) {
                        final cid = obj[k]['id'] ?? obj[k]['_id'];
                        if (cid != null) ids.add(cid.toString());
                     } else if (obj[k] is String) {
                        ids.add(obj[k].toString());
                     }
                  }
                }
                if (obj['users'] != null && obj['users'] is List) {
                   for (var u in obj['users']) {
                      if (u is Map) {
                        final cid = u['id'] ?? u['_id'];
                        if (cid != null) ids.add(cid.toString());
                      }
                   }
                }
                return ids;
             }

             for (var p in allParticipants) {
                final uid = (p['user']?['id'] ?? p['user']?['_id'])?.toString();
                if (uid == null) continue;
                
                // Check if in pending
                for (var req in pending) {
                   if (extractIds(req).contains(uid)) {
                      p['connectionStatus'] = 'PENDING';
                      if (p['user'] != null && p['user'] is Map) p['user']['connectionStatus'] = 'PENDING';
                      break;
                   }
                }
                
                // Check if already connected
                for (var c in allConns) {
                   if (extractIds(c).contains(uid)) {
                      p['connectionStatus'] = 'CONNECTED';
                      if (p['user'] != null && p['user'] is Map) p['user']['connectionStatus'] = 'CONNECTED';
                      break;
                   }
                }
             }

             // Also check for the host!
             if (hostData.isNotEmpty) {
                final hostUid = (hostData['id'] ?? hostData['_id'])?.toString();
                if (hostUid != null) {
                   for (var req in pending) {
                      if (extractIds(req).contains(hostUid)) {
                         hostData['connectionStatus'] = 'PENDING';
                         break;
                      }
                   }
                   for (var c in allConns) {
                      if (extractIds(c).contains(hostUid)) {
                         hostData['connectionStatus'] = 'CONNECTED';
                         break;
                      }
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
        jsonEncode({
          "participantId": participantId,
          "action": action // e.g. "APPROVED"
        }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
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
