import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final RxBool isLoadingNearby = false.obs;
  final RxBool isLoadingUpcoming = false.obs;
  final RxBool isLoadingMyEvents = false.obs;

  final RxList<dynamic> nearbyEvents = <dynamic>[].obs;
  final RxList<dynamic> upcomingEvents = <dynamic>[].obs;
  final RxList<dynamic> myEvents = <dynamic>[].obs;
  final RxList<dynamic> joinedEvents = <dynamic>[].obs;
  final RxSet<String> joinedEventIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNearbyEvents();
    fetchUpcomingEvents();
    fetchMyEvents();
    fetchJoinedEvents();
  }

  Future<void> fetchJoinedEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token == null) return;

      final response = await GetConnect().get(
        '${Apiservices.baseUrl}event/joined?when=all',
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null && data['events'] != null) {
          joinedEvents.value = List.from(data['events']);
          joinedEventIds.clear();
          for (var e in joinedEvents) {
            joinedEventIds.add(e['id'] ?? e['_id'] ?? '');
          }
        }
      }
    } catch (e) {
      print('Error fetching joined events: $e');
    }
  }

  Future<void> fetchNearbyEvents() async {
    print("====== FETCH NEARBY EVENTS CALLED ======");
    try {
      isLoadingNearby.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      String apiUrl = Apiservices.eventSuggestions;
      apiUrl = "$apiUrl?radiusKm=25&includeOnline=true"; // default if location fails
      
      try {
        print("--- Checking Location Services ---");
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        print("Location Service Enabled: $serviceEnabled");
        
        if (!serviceEnabled) {
          print("ERROR: Please turn on GPS/Location on your device.");
        } else {
          LocationPermission permission = await Geolocator.checkPermission();
          print("Current Permission: $permission");
          
          if (permission == LocationPermission.denied) {
            print("Requesting Permission...");
            permission = await Geolocator.requestPermission();
            print("New Permission: $permission");
          }
          
          if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
            print("Getting current position...");
            Position? position = await Geolocator.getLastKnownPosition();
            
            if (position == null) {
               print("No last known position, fetching fresh (Timeout: 5s)...");
               position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.medium,
                  timeLimit: const Duration(seconds: 5)
               ).catchError((e) {
                 print("Timeout getting location: $e");
                 return null;
               });
            }

            if (position != null) {
              print("========= DEVICE LOCATION =========");
              print("Latitude : ${position.latitude}");
              print("Longitude: ${position.longitude}");
              print("===================================");
              apiUrl = "${Apiservices.eventSuggestions}?lat=${position.latitude}&lng=${position.longitude}&radiusKm=25&includeOnline=true";
              print("Fetching Nearby Events with URL: $apiUrl");
            } else {
              print("ERROR: Could not fetch location data.");
            }
          } else {
            print("ERROR: Permission not granted ($permission).");
          }
        }
      } catch (e) {
        print("Geolocator error exception: $e");
      }

      final response = await GetConnect().get(
        apiUrl,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null && data['events'] != null) {
          nearbyEvents.value = List.from(data['events']);
        }
      }
    } catch (e) {
      print('Error fetching nearby events: $e');
    } finally {
      isLoadingNearby.value = false;
    }
  }

  Future<void> fetchUpcomingEvents() async {
    try {
      isLoadingUpcoming.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final response = await GetConnect().get(
        Apiservices.eventList,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null && data['events'] != null) {
          upcomingEvents.value = List.from(data['events']);
        }
      }
    } catch (e) {
      print('Error fetching upcoming events: $e');
    } finally {
      isLoadingUpcoming.value = false;
    }
  }

  Future<void> fetchMyEvents() async {
    try {
      isLoadingMyEvents.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final response = await GetConnect().get(
        Apiservices.eventMine,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null && data['events'] != null) {
          myEvents.value = List.from(data['events']);
        }
      }
    } catch (e) {
      print('Error fetching my events: $e');
    } finally {
      isLoadingMyEvents.value = false;
    }
  }

  Future<bool> deleteEvent(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) return false;

      final response = await GetConnect().delete(
        Apiservices.eventDelete(id),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // We expect 200 based on Swagger
      if (response.statusCode == 200 || response.statusCode == 204) {
        myEvents.removeWhere((e) => (e['id'] ?? e['_id']) == id);
        nearbyEvents.removeWhere((e) => (e['id'] ?? e['_id']) == id);
        upcomingEvents.removeWhere((e) => (e['id'] ?? e['_id']) == id);
        return true;
      } else {
        print("Error deleting event: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Delete Event Error: $e");
      return false;
    }
  }

  // --- Date Formatting Helpers ---
  String getFormattedDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return 'Date TBA';
    try {
      final date = DateTime.parse(isoDate);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} - ${date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour)}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}';
    } catch (e) {
      return isoDate.split('T').first;
    }
  }

  String getDay(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '00';
    try {
      final date = DateTime.parse(isoDate);
      return date.day.toString().padLeft(2, '0');
    } catch (e) {
      return '00';
    }
  }

  String getMonth(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return 'TBA';
    try {
      final date = DateTime.parse(isoDate);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return months[date.month - 1];
    } catch (e) {
      return 'TBA';
    }
  }
}

