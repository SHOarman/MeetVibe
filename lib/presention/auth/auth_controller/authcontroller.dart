import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Authcontroller extends GetxController {
  final ImagePicker _picker = ImagePicker();
  
  final RxString imagePath = ''.obs;
  final RxString selfiePath = ''.obs;

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
}