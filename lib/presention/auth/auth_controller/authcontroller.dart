import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetvibe/presention/auth/auth_model/user_model.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authcontroller extends GetxController {
  final ImagePicker _picker = ImagePicker();

  final RxString imagePath = ''.obs;
  final RxString selfiePath = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString registeredEmail = ''.obs; // Stores email for OTP
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController forgotEmailController = TextEditingController();
  final TextEditingController resetPasswordController = TextEditingController();
  final RxString resetOtp = ''.obs;
  final RxBool acceptTerms = false.obs;
  final RxBool rememberMe = false.obs;

  @override
  void onClose() {
    // nameController.dispose();
    // emailController.dispose();
    // passwordController.dispose();
    // loginEmailController.dispose();
    // loginPasswordController.dispose();
    // forgotEmailController.dispose();
    // resetPasswordController.dispose();
    super.onClose();
  }

  // Token Management
  Future<void> saveTokens(String? accessToken, String? refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    if (accessToken != null) {
      await prefs.setString('accessToken', accessToken);
    }
    if (refreshToken != null) {
      await prefs.setString('refreshToken', refreshToken);
    }
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  Future<bool> extractAndSaveTokens(dynamic responseBody) async {
    try {
      if (responseBody != null && responseBody['data'] != null) {
        final data = responseBody['data'];
        String? access = data['accessToken'] ?? (data['tokens'] != null ? data['tokens']['accessToken'] : null);
        String? refresh = data['refreshToken'] ?? (data['tokens'] != null ? data['tokens']['refreshToken'] : null);
        
        if (access != null && refresh != null) {
          await saveTokens(access, refresh);
          return true;
        }
      }
    } catch (e) {
      print("Error extracting tokens: $e");
    }
    return false;
  }

  // Refresh Token API Call
  Future<bool> refreshTokenAPI() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rToken = prefs.getString('refreshToken');
      
      if (rToken == null) return false;

      final response = await GetConnect().post(
        Apiservices.authRefresh,
        {"refreshToken": rToken},
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
      );

      if (response.statusCode == 200) {
        await extractAndSaveTokens(response.body);
        return true;
      } else {
        await clearTokens(); // Token invalid or expired
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        imagePath.value = pickedFile.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> pickSelfie(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        selfiePath.value = pickedFile.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture selfie: $e');
    }
  }

  void clearImage() {
    imagePath.value = '';
  }

  void clearSelfie() {
    selfiePath.value = '';
  }

  // Registration API Call
  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      isLoading.value = true;
      
      final payload = {
        "email": email.trim(),
        "password": password,
        "name": name.trim(),
      };

      print('----- SENDING REGISTER REQUEST -----');
      print('URL: ${Apiservices.authRegister}');
      print('PAYLOAD: $payload');
      print('------------------------------------');

      final response = await GetConnect().post(
        Apiservices.authRegister,
        jsonEncode(payload),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }
      );

      print('Register API Response Status: ${response.statusCode}');
      print('Register API Response Body: ${response.body}');

      if (response.statusCode == 201) {
        registeredEmail.value = email.trim();
        Get.snackbar('Success', 'User registered successfully. OTP sent to email.');
        return true;
      } else {
        String errorMsg = 'Validation error or email already in use.';
        if (response.body != null) {
          if (response.body is Map) {
            errorMsg = response.body['message'] ?? response.body['error'] ?? response.body.toString();
          } else {
            errorMsg = response.body.toString();
          }
        } else if (response.hasError) {
           errorMsg = 'Network Error: ${response.statusText ?? "Could not reach server (CORS?)"}';
        }
        
        Get.snackbar('Error', errorMsg, duration: const Duration(seconds: 5));
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Login API Call
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      final response = await GetConnect().post(
        Apiservices.authLogin,
        {
          "email": email.trim(),
          "password": password,
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }
      );

      print('Login Status: ${response.statusCode}');
      print('Login Body: ${response.body}');

      if (response.statusCode == 200) {
        registeredEmail.value = email.trim(); // store email in case OTP verification is needed next
        await extractAndSaveTokens(response.body);
        Get.snackbar('Success', 'Logged in successfully.');
        return true;
      } else {
        String errorMsg = 'Invalid email or password.';
        if (response.body != null) {
          if (response.body is Map) {
            errorMsg = response.body['message'] ?? response.body['error'] ?? response.body.toString();
          } else {
            errorMsg = response.body.toString();
          }
        }
        Get.snackbar('Error', errorMsg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP API Call
  Future<bool> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      isLoading.value = true;
      final response = await GetConnect().post(
        Apiservices.authVerifyOtp,
        {
          "email": email.trim(),
          "otp": otp.trim(),
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }
      );

      if (response.statusCode == 200) {
        await extractAndSaveTokens(response.body);
        Get.snackbar('Success', 'Email verified successfully. You are now logged in.');
        return true;
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'Invalid or expired OTP.');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP API Call
  Future<bool> resendOtp({
    required String email,
  }) async {
    try {
      isLoading.value = true;
      final response = await GetConnect().post(
        Apiservices.authResendOtp,
        {
          "email": email.trim(),
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'New OTP has been sent.');
        return true;
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'User not found.');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot Password API Call
  Future<bool> forgotPassword({required String email}) async {
    try {
      isLoading.value = true;
      final response = await GetConnect().post(
        Apiservices.authForgotPassword,
        {"email": email.trim()},
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
      );

      if (response.statusCode == 200) {
        registeredEmail.value = email.trim();
        Get.snackbar('Success', 'Password reset OTP sent.');
        return true;
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'Failed to send OTP.');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Reset Password API Call
  Future<bool> resetPassword({required String email, required String otp, required String password}) async {
    try {
      isLoading.value = true;
      final response = await GetConnect().post(
        Apiservices.authResetPassword,
        {
          "email": email.trim(),
          "otp": otp.trim(),
          "password": password
        },
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password has been reset successfully.');
        return true;
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'Invalid OTP or validation failure.');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Verify Identity API Call (Stripe)
  Future<String?> verifyIdentity() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final getConnect = GetConnect();
      getConnect.timeout = const Duration(seconds: 30); // Increased timeout to 30 seconds

      print('----- SENDING VERIFY IDENTITY REQUEST -----');
      print('URL: ${Apiservices.userVerifyIdentity}');
      
      final response = await getConnect.post(
        Apiservices.userVerifyIdentity,
        {},
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      print('Verify Identity Status: ${response.statusCode}');
      print('Verify Identity Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = response.body;
        if (responseData is Map && responseData['data'] != null && responseData['data']['url'] != null) {
          return responseData['data']['url'] as String;
        } else if (responseData is Map && responseData['url'] != null) {
          return responseData['url'] as String; // fallback just in case
        } else {
          Get.snackbar('Error', 'Verification URL missing in response.');
          return null;
        }
      } else {
        Get.snackbar('Error', 'Failed to initialize Stripe verification: ${response.statusText ?? response.body}');
        return null;
      }
    } catch (e) {
      print('Verify Identity Exception: $e'); // Printing to console
      Get.snackbar('Error', 'Exception: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Mock Verify Identity API Call (Development Mode)
  Future<bool> mockVerifyIdentity() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final getConnect = GetConnect();
      getConnect.timeout = const Duration(seconds: 30);

      print('----- SENDING MOCK VERIFY IDENTITY REQUEST -----');
      print('URL: ${Apiservices.userMockVerifyIdentity}');
      
      final response = await getConnect.post(
        Apiservices.userMockVerifyIdentity,
        {},
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      print('Mock Verify Identity Status: ${response.statusCode}');
      print('Mock Verify Identity Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Identity verified successfully (Mock mode).');
        return true;
      } else {
        Get.snackbar('Error', 'Failed to verify identity: ${response.body?['message'] ?? response.statusText}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Logout API Call
  Future<bool> logout() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final response = await GetConnect().post(
        Apiservices.authLogout,
        {},
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await clearTokens();
        Get.snackbar('Success', 'Logged out successfully.');
        return true;
      } else {
        Get.snackbar('Error', 'Logout failed: ${response.body?['message'] ?? response.statusText}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Logout Exception: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete Account API Call
  Future<bool> deleteAccount({String reason = "No longer needed"}) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final getConnect = GetConnect();
      final response = await getConnect.request(
        Apiservices.userAccountDelete,
        'DELETE',
        body: {"reason": reason},
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await clearTokens();
        Get.snackbar('Success', 'Account deleted successfully.');
        return true;
      } else {
        Get.snackbar('Error', 'Failed to delete account: ${response.body?['message'] ?? response.statusText}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Delete Account Exception: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}