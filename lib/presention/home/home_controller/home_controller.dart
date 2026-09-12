import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meetvibe/presention/profile/profile_controller/profile_controller.dart' as meet;
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';

class HomeController extends GetxController {
  final RxBool isLoadingNearby = false.obs;
  final RxBool isLoadingUpcoming = false.obs;
  final RxBool isLoadingMyEvents = false.obs;
  final RxBool isLoadingJoinedEvents = false.obs;

  final RxBool isLoadingPopular = false.obs;

  final RxList<dynamic> nearbyEvents = <dynamic>[].obs;
  final RxList<dynamic> upcomingEvents = <dynamic>[].obs;
  final RxList<dynamic> myEvents = <dynamic>[].obs;
  final RxList<dynamic> joinedEvents = <dynamic>[].obs;
  final RxList<dynamic> popularEvents = <dynamic>[].obs;
  final RxList<dynamic> dynamicCategories = <dynamic>[].obs;
  final RxSet<String> joinedEventIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNearbyEvents();
    fetchUpcomingEvents();
    fetchMyEvents();
    fetchJoinedEvents();
    fetchPopularEvents();
    fetchCategories();
  }

  Future<void> fetchJoinedEvents({bool isRetry = false}) async {
    try {
      if (!isRetry) isLoadingJoinedEvents.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token == null) return;

      final getConnect = GetConnect();
      getConnect.timeout = const Duration(seconds: 30);
      final response = await getConnect.get(
        '${Apiservices.baseUrl}/event/joined?when=all',
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
      } else if (response.statusCode == 401 && !isRetry) {
        final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());
        final refreshed = await authController.refreshTokenAPI();
        if (refreshed) {
           await fetchJoinedEvents(isRetry: true);
        }
      } else if (response.statusCode == null && !isRetry) {
        print("Joined Events GET Network Error (null status): Retrying in 2s...");
        await Future.delayed(const Duration(seconds: 2));
        await fetchJoinedEvents(isRetry: true);
      }
    } catch (e) {
      print('Error fetching joined events: $e');
    } finally {
      if (!isRetry) isLoadingJoinedEvents.value = false;
    }
  }

  Future<void> fetchNearbyEvents({bool isRetry = false}) async {
    print("====== FETCH NEARBY EVENTS CALLED ======");
    try {
      if (!isRetry) isLoadingNearby.value = true;
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
              
              // Automatically update backend so the profile reflects the current location
              try {
                final profileController = Get.isRegistered<meet.ProfileController>() 
                    ? Get.find<meet.ProfileController>() 
                    : Get.put(meet.ProfileController());
                // We run this async so it doesn't block the nearby events load
                profileController.updateUserLocation(position.latitude, position.longitude, setAsHome: true);
              } catch (e) {
                print("Failed calling ProfileController: $e");
              }

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

      final getConnect = GetConnect();
      getConnect.timeout = const Duration(seconds: 30);
      final response = await getConnect.get(
        apiUrl,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null && data['nearby'] != null) {
          nearbyEvents.value = List.from(data['nearby']);
        }
      } else if (response.statusCode == 401 && !isRetry) {
        final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());
        final refreshed = await authController.refreshTokenAPI();
        if (refreshed) {
           await fetchNearbyEvents(isRetry: true);
        }
      } else if (response.statusCode == null && !isRetry) {
        print("Nearby Events GET Network Error (null status): Retrying in 2s...");
        await Future.delayed(const Duration(seconds: 2));
        await fetchNearbyEvents(isRetry: true);
      }
    } catch (e) {
      print('Error fetching nearby events: $e');
    } finally {
      if (!isRetry) isLoadingNearby.value = false;
    }
  }

  Future<void> fetchUpcomingEvents({bool isRetry = false}) async {
    try {
      if (!isRetry) isLoadingUpcoming.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      String apiUrl = "${Apiservices.eventUpcoming}?limit=10";
      
      try {
        Position? position = await Geolocator.getLastKnownPosition();
        if (position != null) {
          apiUrl = "${Apiservices.eventUpcoming}?lat=${position.latitude}&lng=${position.longitude}&limit=10";
        }
      } catch (e) {
        // Location might fail, ignore
      }

      final getConnect = GetConnect();
      getConnect.timeout = const Duration(seconds: 30);
      final response = await getConnect.get(
        apiUrl,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null && data['events'] != null) {
          upcomingEvents.value = List.from(data['events']);
        } else if (data != null && data is List) {
          upcomingEvents.value = List.from(data);
        } else if (data != null && data['upcoming'] != null) {
          upcomingEvents.value = List.from(data['upcoming']);
        } else if (response.body != null && response.body['events'] != null) {
          upcomingEvents.value = List.from(response.body['events']);
        } else {
          upcomingEvents.value = List.from(response.body ?? []);
        }
      } else if (response.statusCode == 401 && !isRetry) {
        final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());
        final refreshed = await authController.refreshTokenAPI();
        if (refreshed) {
           await fetchUpcomingEvents(isRetry: true);
        }
      } else if (response.statusCode == null && !isRetry) {
        print("Upcoming Events GET Network Error (null status): Retrying in 2s...");
        await Future.delayed(const Duration(seconds: 2));
        await fetchUpcomingEvents(isRetry: true);
      }
    } catch (e) {
      print('Error fetching upcoming events: $e');
    } finally {
      if (!isRetry) isLoadingUpcoming.value = false;
    }
  }

  Future<void> fetchPopularEvents({bool isRetry = false}) async {
    try {
      if (!isRetry) isLoadingPopular.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      String apiUrl = "${Apiservices.eventPopular}?limit=10";
      
      try {
        Position? position = await Geolocator.getLastKnownPosition();
        if (position != null) {
          apiUrl = "${Apiservices.eventPopular}?lat=${position.latitude}&lng=${position.longitude}&limit=10";
        }
      } catch (e) {
        // Location might fail, ignore
      }

      final getConnect = GetConnect();
      getConnect.timeout = const Duration(seconds: 30);
      final response = await getConnect.get(
        apiUrl,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null && data['events'] != null) {
          popularEvents.value = List.from(data['events']);
        } else if (data != null && data is List) {
          popularEvents.value = List.from(data);
        } else if (response.body != null && response.body['events'] != null) {
           popularEvents.value = List.from(response.body['events']);
        } else {
           popularEvents.value = List.from(response.body ?? []);
        }
      } else if (response.statusCode == 401 && !isRetry) {
        final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());
        final refreshed = await authController.refreshTokenAPI();
        if (refreshed) {
           await fetchPopularEvents(isRetry: true);
        }
      } else if (response.statusCode == null && !isRetry) {
        print("Popular Events GET Network Error (null status): Retrying in 2s...");
        await Future.delayed(const Duration(seconds: 2));
        await fetchPopularEvents(isRetry: true);
      }
    } catch (e) {
      print('Error fetching popular events: $e');
    } finally {
      if (!isRetry) isLoadingPopular.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await GetConnect().get(Apiservices.eventCategories);
      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null && data['categories'] != null) {
           dynamicCategories.value = List.from(data['categories']);
        }
      }
    } catch (e) {
      print('Fetch categories error: $e');
    }
  }

  Future<void> fetchMyEvents({bool isRetry = false}) async {
    try {
      if (!isRetry) isLoadingMyEvents.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final getConnect = GetConnect();
      getConnect.timeout = const Duration(seconds: 30);
      final response = await getConnect.get(
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
      } else if (response.statusCode == 401 && !isRetry) {
        final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());
        final refreshed = await authController.refreshTokenAPI();
        if (refreshed) {
           await fetchMyEvents(isRetry: true);
        }
      } else if (response.statusCode == null && !isRetry) {
        print("My Events GET Network Error (null status): Retrying in 2s...");
        await Future.delayed(const Duration(seconds: 2));
        await fetchMyEvents(isRetry: true);
      }
    } catch (e) {
      print('Error fetching my events: $e');
    } finally {
      if (!isRetry) isLoadingMyEvents.value = false;
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

