import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/presention/profile/profile_controller/subscription_controller.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class SubscriptionUi extends StatelessWidget {
  const SubscriptionUi({super.key});

  @override
  Widget build(BuildContext context) {
    final subscriptionController = Get.put(SubscriptionController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Subscription",
          style: AppTextStyle.poppins(
            size: 20,
            weight: FontWeight.w700,
            color: const Color(0xff2D292E),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (subscriptionController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final isActive = subscriptionController.isActive.value;
        final expiration = subscriptionController.expirationDate.value;
        final statusDetails = subscriptionController.statusDetails.value;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Plan",
                style: AppTextStyle.poppins(
                  size: 18,
                  weight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isActive ? Colors.green : Colors.red,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isActive ? Icons.check_circle : Icons.cancel,
                          color: isActive ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Status: ${isActive ? "Active" : "Inactive"}",
                          style: AppTextStyle.poppins(
                            size: 16,
                            weight: FontWeight.w600,
                            color: isActive ? Colors.green.shade800 : Colors.red.shade800,
                          ),
                        ),
                      ],
                    ),
                    if (statusDetails != null && statusDetails.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        "Details: ${statusDetails.toUpperCase()}",
                        style: AppTextStyle.poppins(
                          size: 14,
                          weight: FontWeight.w400,
                        ),
                      ),
                    ],
                    if (expiration != null && expiration.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        "Expires On: $expiration",
                        style: AppTextStyle.poppins(
                          size: 14,
                          weight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
