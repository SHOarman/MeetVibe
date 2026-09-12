import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:meetvibe/global_widget/custombutton.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportProblemController extends GetxController {
  var isLoading = false.obs;

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  
  var selectedCategory = "ACCOUNT".obs;
  final List<String> categories = ["ACCOUNT", "PAYMENT", "EVENT", "BUG", "OTHER"];

  Future<void> submitReport() async {
    final sub = subjectController.text.trim();
    final desc = descriptionController.text.trim();

    if (sub.isEmpty || desc.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        Get.snackbar("Error", "Not logged in");
        return;
      }

      final response = await GetConnect().post(
        Apiservices.settingsReportProblem,
        jsonEncode({
          "category": selectedCategory.value,
          "subject": sub,
          "description": desc
        }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Problem reported successfully", backgroundColor: Colors.green, colorText: Colors.white);
        Get.back();
      } else {
        Get.snackbar("Error", response.body?['message'] ?? "Failed to report problem", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Network error occurred", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    subjectController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}

class ReportProblemUi extends StatelessWidget {
  const ReportProblemUi({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportProblemController controller = Get.put(ReportProblemController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          "Report a Problem",
          style: AppTextStyle.outfit(
            size: 24,
            weight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category",
              style: AppTextStyle.outfit(size: 16, weight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.selectedCategory.value,
                  isExpanded: true,
                  items: controller.categories.map((String cat) {
                    return DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat, style: AppTextStyle.outfit(size: 14, weight: FontWeight.w400)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) controller.selectedCategory.value = val;
                  },
                ),
              ),
            )),
            const SizedBox(height: 20),
            
            CustomTextfild(
              hintText: "Enter subject (e.g., Checkout crashed)",
              labelText: "Subject",
              controller: controller.subjectController,
            ),
            const SizedBox(height: 20),

            Text(
              "Description",
              style: AppTextStyle.outfit(size: 16, weight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Describe the issue you're facing...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEC6D43)),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFEC6D43)));
              }
              return CustomButton(text: "Submit", onTap: () => controller.submitReport());
            }),
          ],
        ),
      ),
    );
  }
}
