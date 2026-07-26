import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetvibe/presention/auth/auth_model/user_model.dart';

class Authcontroller extends GetxController {
  final ImagePicker _picker = ImagePicker();

  final RxString imagePath = ''.obs;
  final RxString selfiePath = ''.obs;
  final RxBool isLoading = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

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

  // Registration Mock Call
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
    String? dateOfBirth,
    String? gender,
    String? occupation,
    String? fitnessGoal,
  }) async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
      Get.snackbar('Success', 'Account created successfully (Mock)!');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}