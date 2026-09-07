import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';
import 'package:meetvibe/core/route/app_routes.dart';

class CreateController extends GetxController {
  final RxBool isLoading = false.obs;

  // Step 1 Fields
  final RxString eventId = ''.obs;
  final TextEditingController titleController = TextEditingController();
  final RxString category = ''.obs;
  final RxString eventType = 'PRIVATE'.obs; // e.g., PRIVATE, PUBLIC
  final TextEditingController capacityController = TextEditingController();
  final RxBool isFree = true.obs;
  final TextEditingController priceController = TextEditingController();
  final RxBool isDepositModel = false.obs;
  final TextEditingController refundPenaltyRateController = TextEditingController();

  final Rx<File?> coverImage = Rx<File?>(null);

  // Step 2 Fields
  final Rxn<DateTime> startDate = Rxn<DateTime>(null);
  final Rxn<TimeOfDay> startTime = Rxn<TimeOfDay>(null);
  final Rxn<DateTime> endDate = Rxn<DateTime>(null);
  final Rxn<TimeOfDay> endTime = Rxn<TimeOfDay>(null);

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController timezoneController = TextEditingController();

  // Step 3 Fields
  final RxString venueType = 'OFFLINE'.obs; // 'OFFLINE' or 'ONLINE'
  final TextEditingController venueNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final RxDouble mapLat = 23.7937.obs;
  final RxDouble mapLng = 90.4066.obs;
  final TextEditingController onlineLinkController = TextEditingController();

  // Step 4 Fields
  final TextEditingController agendaController = TextEditingController();
  final TextEditingController whatToBringController = TextEditingController();
  final RxList<String> tags = <String>[].obs;
  final RxString visibility = 'PUBLIC'.obs;

  final ImagePicker _picker = ImagePicker();

  final RxList<Map<String, dynamic>> dynamicCategories = <Map<String, dynamic>>[].obs;
  final RxList<String> dynamicEventTypes = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await GetConnect().get(Apiservices.eventCategories);
      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null) {
          if (data['categories'] != null) {
             dynamicCategories.value = List<Map<String, dynamic>>.from(data['categories']);
          }
          if (data['eventTypes'] != null) {
             dynamicEventTypes.value = List<String>.from(data['eventTypes']);
             if (dynamicEventTypes.isNotEmpty) {
               eventType.value = dynamicEventTypes.first; // update default
             }
          }
        }
      }
    } catch (e) {
      print('Fetch categories error: $e');
    }
  }

  Future<void> pickCoverImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (image != null) {
        coverImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<bool> submitStep1({bool isRetry = false}) async {
    if (coverImage.value == null) {
      Get.snackbar('Validation Error', 'Please select an event cover photo');
      return false;
    }
    if (titleController.text.trim().length < 3) {
      Get.snackbar('Validation Error', 'Title must be at least 3 characters');
      return false;
    }
    if (category.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select an event category');
      return false;
    }
    if (capacityController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Please enter event capacity');
      return false;
    }
    if (!isFree.value && priceController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Please enter a price for premium plan');
      return false;
    }

    try {
      if (!isRetry) isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      // Create FormData
      print('====== STEP 1 REQUEST ======');
      print('Endpoint: ${Apiservices.eventStep1}');
      
      final formData = FormData({
        if (eventId.value.isNotEmpty) "eventId": eventId.value,
        "title": titleController.text,
        "category": category.value,
        "eventType": eventType.value,
        "capacity": int.tryParse(capacityController.text) ?? 0,
        "isFree": isFree.value.toString(), // Multipart treats booleans better as string
        if (!isFree.value) "price": double.tryParse(priceController.text) ?? 0.0,
        "isDepositModel": isDepositModel.value.toString(),
        if (isDepositModel.value) "refundPenaltyRate": double.tryParse(refundPenaltyRateController.text) ?? 0.0,
      });

      print('Fields:\n${const JsonEncoder.withIndent('  ').convert(Map.fromEntries(formData.fields))}');

      if (coverImage.value != null) {
        String ext = coverImage.value!.path.split('.').last;
        if (ext.length > 5) ext = 'jpg'; // fallback if no extension found
        
        // Passing the File directly is usually handled better by GetConnect
        formData.files.add(MapEntry(
          "coverImage",
          MultipartFile(
            coverImage.value!,
            filename: 'cover_image.$ext',
            contentType: 'image/$ext',
          ),
        ));
        
        
        print('Attached coverImage with extension: $ext');
      }

      final getConnect = GetConnect();
      getConnect.timeout = const Duration(seconds: 30);
      
      final response = await getConnect.post(
        Apiservices.eventStep1,
        formData,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      print('====== STEP 1 RESPONSE ======');
      print('Status: ${response.statusCode}');
      print('Body:\n${const JsonEncoder.withIndent('  ').convert(response.body)}');
      print('==============================');
      
      if (response.statusCode == null || response.hasError == true && response.statusCode == null) {
        Get.snackbar('Error', 'Network error or timeout. Image might be too large.');
        return false;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body['data'];
        // Store eventId if it returns it, so subsequent updates or steps use it
        if (data != null && data['event'] != null && data['event']['id'] != null) {
          eventId.value = data['event']['id'];
        } else if (data != null && data['id'] != null) {
          eventId.value = data['id'];
        }
        
        Get.snackbar('Success', 'Basic info saved successfully');
        return true;
      } else if (response.statusCode == 401 && !isRetry) {
        print("Create Event 401: Attempting token refresh...");
        final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());
        final refreshed = await authController.refreshTokenAPI();
        
        if (refreshed) {
           return await submitStep1(isRetry: true);
        } else {
           Get.snackbar('Session Expired', 'Please login again.');
           Get.offAllNamed(AppRoutes.login);
           return false;
        }
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'Failed to save Step 1');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
      return false;
    } finally {
      if (!isRetry) isLoading.value = false;
    }
  }

  Future<bool> submitStep2({bool isRetry = false}) async {
    if (startDate.value == null) {
      Get.snackbar('Validation Error', 'Start Date is required');
      return false;
    }
    if (startTime.value == null) {
      Get.snackbar('Validation Error', 'Start Time is required');
      return false;
    }
    if (endDate.value == null) {
      Get.snackbar('Validation Error', 'End Date is required');
      return false;
    }
    if (endTime.value == null) {
      Get.snackbar('Validation Error', 'End Time is required');
      return false;
    }
    if (timezoneController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Time Zone is required');
      return false;
    }

    try {
      if (!isRetry) isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      String formatApiDate(DateTime d) => "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
      String formatApiTime(TimeOfDay t) => "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

      final body = {
        "eventId": eventId.value,
        "startDate": formatApiDate(startDate.value!),
        "startTime": formatApiTime(startTime.value!),
        "endDate": formatApiDate(endDate.value!),
        "endTime": formatApiTime(endTime.value!),
        "timezone": timezoneController.text.trim(),
      };

      print('====== STEP 2 REQUEST ======');
      print('Endpoint: ${Apiservices.eventStep2}');
      print('Body:\n${const JsonEncoder.withIndent('  ').convert(body)}');
      print('==============================');

      final getConnect = GetConnect();
      getConnect.timeout = const Duration(seconds: 30);
      
      final response = await getConnect.post(
        Apiservices.eventStep2,
        body,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      print('====== STEP 2 RESPONSE ======');
      print('Status: ${response.statusCode}');
      print('Body:\n${const JsonEncoder.withIndent('  ').convert(response.body)}');
      print('==============================');
      
      if (response.statusCode == null || response.hasError == true && response.statusCode == null) {
        Get.snackbar('Error', 'Network error or timeout.');
        return false;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Date & Time saved successfully');
        return true;
      } else if (response.statusCode == 401 && !isRetry) {
        print("Create Event Step 2 401: Attempting token refresh...");
        final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());
        final refreshed = await authController.refreshTokenAPI();
        
        if (refreshed) {
           return await submitStep2(isRetry: true);
        } else {
           Get.snackbar('Session Expired', 'Please login again.');
           Get.offAllNamed(AppRoutes.login);
           return false;
        }
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'Failed to save Step 2');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
      return false;
    } finally {
      if (!isRetry) isLoading.value = false;
    }
  }

  Future<bool> submitStep3({bool isRetry = false}) async {
    if (venueType.value == 'OFFLINE') {
      if (venueNameController.text.trim().isEmpty) {
        Get.snackbar('Validation Error', 'Venue Name is required');
        return false;
      }
      if (addressController.text.trim().isEmpty) {
        Get.snackbar('Validation Error', 'Address is required');
        return false;
      }
    } else {
      if (onlineLinkController.text.trim().isEmpty) {
        Get.snackbar('Validation Error', 'Online Link (Zoom etc.) is required');
        return false;
      }
    }

    try {
      if (!isRetry) isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final body = {
        "eventId": eventId.value,
        "venueType": venueType.value,
        "venueName": venueType.value == 'OFFLINE' ? venueNameController.text.trim() : null,
        "address": venueType.value == 'OFFLINE' ? addressController.text.trim() : null,
        "mapLat": venueType.value == 'OFFLINE' ? mapLat.value : null,
        "mapLng": venueType.value == 'OFFLINE' ? mapLng.value : null,
        "onlineLink": venueType.value == 'ONLINE' ? onlineLinkController.text.trim() : null,
      };

      print('====== STEP 3 REQUEST ======');
      print('Endpoint: ${Apiservices.eventStep3}');
      print('Body:\n${const JsonEncoder.withIndent('  ').convert(body)}');
      print('==============================');

      final getConnect = GetConnect();
      getConnect.timeout = const Duration(seconds: 30);
      
      final response = await getConnect.post(
        Apiservices.eventStep3,
        body,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      print('====== STEP 3 RESPONSE ======');
      print('Status: ${response.statusCode}');
      print('Body:\n${const JsonEncoder.withIndent('  ').convert(response.body)}');
      print('==============================');
      
      if (response.statusCode == null || response.hasError == true && response.statusCode == null) {
        Get.snackbar('Error', 'Network error or timeout.');
        return false;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Location saved successfully');
        return true;
      } else if (response.statusCode == 401 && !isRetry) {
        print("Create Event Step 3 401: Attempting token refresh...");
        final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());
        final refreshed = await authController.refreshTokenAPI();
        
        if (refreshed) {
           return await submitStep3(isRetry: true);
        } else {
           Get.snackbar('Session Expired', 'Please login again.');
           Get.offAllNamed(AppRoutes.login);
           return false;
        }
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'Failed to save Step 3');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
      return false;
    } finally {
      if (!isRetry) isLoading.value = false;
    }
  }

  Future<bool> submitStep4({bool isRetry = false}) async {
    if (agendaController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Agenda/Description is required');
      return false;
    }
    if (whatToBringController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'What to bring is required');
      return false;
    }

    try {
      if (!isRetry) isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final body = {
        "eventId": eventId.value,
        "agenda": agendaController.text.trim(),
        "whatToBring": whatToBringController.text.trim(),
        "tags": tags.toList(),
        "visibility": visibility.value,
      };

      print('====== STEP 4 REQUEST ======');
      print('Endpoint: ${Apiservices.eventStep4}');
      print('Body:\n${const JsonEncoder.withIndent('  ').convert(body)}');
      print('==============================');

      final getConnect = GetConnect();
      getConnect.timeout = const Duration(seconds: 30);
      
      final response = await getConnect.post(
        Apiservices.eventStep4,
        body,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      print('====== STEP 4 RESPONSE ======');
      print('Status: ${response.statusCode}');
      print('Body:\n${const JsonEncoder.withIndent('  ').convert(response.body)}');
      print('==============================');
      
      if (response.statusCode == null || response.hasError == true && response.statusCode == null) {
        Get.snackbar('Error', 'Network error or timeout.');
        return false;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Details saved successfully');
        return true;
      } else if (response.statusCode == 401 && !isRetry) {
        print("Create Event Step 4 401: Attempting token refresh...");
        final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());
        final refreshed = await authController.refreshTokenAPI();
        
        if (refreshed) {
           return await submitStep4(isRetry: true);
        } else {
           Get.snackbar('Session Expired', 'Please login again.');
           Get.offAllNamed(AppRoutes.login);
           return false;
        }
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'Failed to save Step 4');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
      return false;
    } finally {
      if (!isRetry) isLoading.value = false;
    }
  }

  Future<bool> publishEvent({bool isRetry = false}) async {
    if (eventId.value.isEmpty) {
      Get.snackbar('Error', 'Invalid Event ID. Please start over.');
      return false;
    }

    try {
      if (!isRetry) isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      print('====== PUBLISH EVENT REQUEST ======');
      print('Endpoint: ${Apiservices.eventPublish(eventId.value)}');
      print('==============================');

      final getConnect = GetConnect();
      getConnect.timeout = const Duration(seconds: 30);
      
      final response = await getConnect.post(
        Apiservices.eventPublish(eventId.value),
        {}, // Empty body
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      print('====== PUBLISH EVENT RESPONSE ======');
      print('Status: ${response.statusCode}');
      print('Body:\n${const JsonEncoder.withIndent('  ').convert(response.body)}');
      print('==============================');
      
      if (response.statusCode == null || response.hasError == true && response.statusCode == null) {
        Get.snackbar('Error', 'Network error or timeout.');
        return false;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401 && !isRetry) {
        print("Publish Event 401: Attempting token refresh...");
        final authController = Get.isRegistered<Authcontroller>() ? Get.find<Authcontroller>() : Get.put(Authcontroller());
        final refreshed = await authController.refreshTokenAPI();
        
        if (refreshed) {
           return await publishEvent(isRetry: true);
        } else {
           Get.snackbar('Session Expired', 'Please login again.');
           Get.offAllNamed(AppRoutes.login);
           return false;
        }
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'Failed to publish event');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
      return false;
    } finally {
      if (!isRetry) isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    capacityController.dispose();
    priceController.dispose();
    refundPenaltyRateController.dispose();
    
    startDateController.dispose();
    startTimeController.dispose();
    endDateController.dispose();
    endTimeController.dispose();
    timezoneController.dispose();
    
    venueNameController.dispose();
    addressController.dispose();
    onlineLinkController.dispose();
    
    agendaController.dispose();
    whatToBringController.dispose();
    
    super.onClose();
  }
}