import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';
import 'package:meetvibe/core/route/app_routes.dart';

class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  
  // Profile Data
  final RxString name = ''.obs;
  final RxString username = ''.obs;
  final RxString email = ''.obs;
  final RxString dateOfBirth = ''.obs;
  final RxString gender = 'Male'.obs;
  final RxString address = ''.obs;
  final RxnString image = RxnString(null);
  final RxString localImage = ''.obs; // local fallback
  final RxBool isVerified = false.obs;
  final RxString userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  Future<void> fetchProfileData({bool isRetry = false}) async {
    try {
      if (!isRetry) isLoading.value = true;
      
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      localImage.value = prefs.getString('local_profile_image') ?? '';

      final response = await GetConnect().get(
        Apiservices.userProfile,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      print("Profile API Status: ${response.statusCode}");
      print("Profile API Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null && data['user'] != null) {
          final user = data['user'];
          
          name.value = user['name'] ?? '';
          email.value = user['email'] ?? '';
          
          userId.value = user['id'] ?? user['_id'] ?? '';
          prefs.setString('userId', userId.value); // save for easy access
          
          username.value = user['username'] ?? (email.value.isNotEmpty ? '@${email.value.split('@').first}' : '');
          dateOfBirth.value = user['dateOfBirth'] ?? '';
          gender.value = user['gender'] ?? 'Male';
          address.value = user['address'] ?? '';
          
          image.value = user['image'];

          isVerified.value = user['verificationStatus'] == 'VERIFIED';
        }
      } else if (response.statusCode == 401 && !isRetry) {
        // Token expired, attempt to refresh
        print("Profile GET 401: Attempting token refresh...");
        final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());
        final refreshed = await authController.refreshTokenAPI();
        
        if (refreshed) {
           // Retry fetching profile seamlessly
           await fetchProfileData(isRetry: true);
        } else {
           Get.snackbar('Session Expired', 'Please login again.');
           Get.offAllNamed(AppRoutes.login);
        }
      } else if (response.statusCode == null && !isRetry) {
        // Handle cold start network/tunnel failures gracefully with an auto-retry
        print("Profile GET Network Error (null status): Retrying in 2s...");
        await Future.delayed(const Duration(seconds: 2));
        await fetchProfileData(isRetry: true);
      } else {
        Get.snackbar(
          'Error', 
          'Failed to connect to server. Details: ${response.statusCode ?? 'Network issue'}', 
          snackPosition: SnackPosition.BOTTOM
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Error: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (!isRetry) isLoading.value = false;
    }
  }

  Future<bool> updateProfile(String newName, String? newImage, {
    String? localImagePath, 
    String? username, 
    String? dateOfBirth, 
    String? gender, 
    String? address
  }) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (localImagePath != null && localImagePath.isNotEmpty) {
        await prefs.setString('local_profile_image', localImagePath);
        localImage.value = localImagePath;
      }

      final Map<String, dynamic> body = {
        "name": newName,
      };

      if (username != null && username.isNotEmpty) body["username"] = username;
      if (dateOfBirth != null && dateOfBirth.isNotEmpty) body["dateOfBirth"] = dateOfBirth;
      if (gender != null && gender.isNotEmpty) body["gender"] = gender;
      if (address != null && address.isNotEmpty) body["address"] = address;

      dynamic requestBody;
      Map<String, String> requestHeaders = {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      if (localImagePath != null && localImagePath.isNotEmpty && !localImagePath.startsWith('http')) {
        try {
          File file = File(localImagePath);
          List<int> imageBytes = await file.readAsBytes();
          String base64Image = base64Encode(imageBytes);
          String ext = localImagePath.split('.').last.toLowerCase();
          if (ext != 'png' && ext != 'gif' && ext != 'webp') ext = 'jpeg';
          
          String dataUri = 'data:image/$ext;base64,$base64Image';
          body["image"] = dataUri;
          body["profileImage"] = dataUri;
        } catch (e) {
          print("Error converting image to base64: $e");
        }
      } else {
        final currentImage = newImage ?? image.value;
        if (currentImage != null && currentImage.trim().isNotEmpty) {
          if (!body.containsKey("image")) body["image"] = currentImage;
          if (!body.containsKey("profileImage")) body["profileImage"] = currentImage;
        }
      }
      
      requestBody = body;
      requestHeaders['Content-Type'] = 'application/json';

      // --- Debug Print Request Body --- 
      print("====== UPDATE PROFILE REQUEST ======");
      print("Endpoint: ${Apiservices.userProfile}");
      
      final Map<String, dynamic> debugBody = Map.from(body);
      if (debugBody['image'] != null && debugBody['image'].toString().length > 100) {
        debugBody['image'] = "${debugBody['image'].toString().substring(0, 50)}... [BASE64 TRUNCATED]";
      }
      if (debugBody['profileImage'] != null && debugBody['profileImage'].toString().length > 100) {
        debugBody['profileImage'] = "${debugBody['profileImage'].toString().substring(0, 50)}... [BASE64 TRUNCATED]";
      }
      print("Body:\\n${const JsonEncoder.withIndent('  ').convert(debugBody)}");
      print("====================================");

      final getConnect = GetConnect();
      getConnect.timeout = const Duration(seconds: 30);

      final response = await getConnect.put(
        Apiservices.userProfile,
        requestBody,
        headers: requestHeaders,
      );

      print("====== UPDATE PROFILE RESPONSE ======");
      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");
      print("=====================================");

      if (response.statusCode == 200) {
        // Fetch fresh data immediately to reflect on all UIs
        await fetchProfileData();
        return true;
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'Failed to update profile');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserLocation(double lat, double lng, {bool setAsHome = true, bool isRetry = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token == null) return;

      final String url = Apiservices.baseUrl.endsWith('/')
          ? '${Apiservices.baseUrl}user/location'
          : '${Apiservices.baseUrl}/user/location';

      print("Updating backend user location: $lat, $lng");
      final response = await GetConnect().put(
        url,
        {
          "lat": lat,
          "lng": lng,
          "setAsHome": setAsHome
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );

      print("Location Update API Status: ${response.statusCode}");
      print("Location Update API Body: ${response.body}");

      if (response.statusCode == 401 && !isRetry) {
        print("Location Update 401: Refreshing token...");
        final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());
        final refreshed = await authController.refreshTokenAPI();
        if (refreshed) {
           await updateUserLocation(lat, lng, setAsHome: setAsHome, isRetry: true);
        }
      }
    } catch (e) {
      print("Location Update Error: $e");
    }
  }
}
