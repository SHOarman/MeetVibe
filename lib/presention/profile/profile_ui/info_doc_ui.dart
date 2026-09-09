import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoDocController extends GetxController {
  final String apiUrl;
  final String dataKey; // e.g. "privacyPolicy" or "terms"
  
  var isLoading = false.obs;
  var docTitle = "".obs;
  var lastUpdated = "".obs;
  var sections = <dynamic>[].obs;

  InfoDocController({required this.apiUrl, required this.dataKey});

  @override
  void onInit() {
    super.onInit();
    fetchDoc();
  }

  Future<void> fetchDoc() async {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      
      final response = await GetConnect().get(
        apiUrl,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null && data[dataKey] != null) {
          final doc = data[dataKey];
          docTitle.value = doc['title'] ?? '';
          lastUpdated.value = doc['lastUpdated'] ?? '';
          sections.value = doc['sections'] ?? [];
        }
      } else {
        Get.snackbar("Error", "Could not load document.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred fetching document.");
    } finally {
      isLoading(false);
    }
  }
}

class InfoDocUi extends StatelessWidget {
  final String pageTitle;
  final String apiUrl;
  final String dataKey;

  const InfoDocUi({
    super.key,
    required this.pageTitle,
    required this.apiUrl,
    required this.dataKey,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a unique tag so multiple instances don't share the same controller
    final String tag = dataKey;
    final InfoDocController controller = Get.put(
      InfoDocController(apiUrl: apiUrl, dataKey: dataKey),
      tag: tag
    );

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
          pageTitle,
          style: AppTextStyle.outfit(
            size: 24,
            weight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFEC6D43)));
        }

        if (controller.sections.isEmpty) {
          return const Center(child: Text("No information available at this time."));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: controller.sections.length,
          itemBuilder: (context, index) {
            final section = controller.sections[index];
            final heading = section['heading'] ?? '';
            final body = section['body'] ?? '';

            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (heading.isNotEmpty) ...[
                    Text(
                      heading,
                      style: AppTextStyle.outfit(
                        size: 18,
                        weight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    body,
                    style: AppTextStyle.outfit(
                      size: 14,
                      weight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
