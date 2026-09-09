import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaqsController extends GetxController {
  var isLoading = false.obs;
  var faqsList = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      
      final response = await GetConnect().get(
        Apiservices.settingsFaqs,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        if (response.body is List) {
          faqsList.value = response.body;
        } else if (response.body['data'] is List) {
           faqsList.value = response.body['data'];
        }
      } else {
        Get.snackbar("Error", "Could not load FAQs.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while fetching FAQs.");
    } finally {
      isLoading(false);
    }
  }
}

class FaqsUi extends StatelessWidget {
  const FaqsUi({super.key});

  @override
  Widget build(BuildContext context) {
    final FaqsController controller = Get.put(FaqsController());

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
          "FAQs",
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

        if (controller.faqsList.isEmpty) {
          return const Center(child: Text("No FAQs available."));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.faqsList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final faq = controller.faqsList[index];
            final category = faq['category'] ?? '';
            final question = faq['question'] ?? 'No question';
            final answer = faq['answer'] ?? 'No answer provided';

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
                ]
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  iconColor: const Color(0xFFEC6D43),
                  collapsedIconColor: Colors.grey,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (category.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFEC6D43).withOpacity(0.8),
                            ),
                          ),
                        ),
                      Text(
                        question,
                        style: AppTextStyle.outfit(
                          size: 16,
                          weight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Text(
                        answer,
                        style: AppTextStyle.outfit(
                          size: 14,
                          weight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
