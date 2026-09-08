import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/home/home_controller/home_controller.dart';
import 'package:meetvibe/presention/home/home_widget/nearbycard.dart'; // We can use this or upcoming for full width
import 'package:meetvibe/presention/profile/profile_widget/custommsg.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class MyEventsUi extends StatelessWidget {
  const MyEventsUi({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "My Events",
          style: AppTextStyle.poppins(
            size: 18,
            weight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(() {
        if (homeController.isLoadingMyEvents.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (homeController.myEvents.isEmpty) {
          return Center(
            child: Text(
              "You haven't created any events yet.",
              style: AppTextStyle.poppins(
                size: 14,
                weight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => homeController.fetchMyEvents(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: homeController.myEvents.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final event = homeController.myEvents[index];
              final eventId = event['id'] ?? event['_id'];

              return Stack(
                children: [
                  NearbyEventCard(
                    title: event['title'] ?? 'Unknown Event',
                    categoryName: event['category'] ?? 'Category',
                    categoryColor: const Color(0xFFEC6D43),
                    attendeeCount: event['capacity'] ?? 0,
                    location: event['address'] ?? event['venueName'] ?? 'Location TBA',
                    dateTime: homeController.getFormattedDate(event['startDate']),
                    imagePath: event['coverImage'] ?? 'assets/image/image 6 (1).png',
                    onJoinTap: () => Get.toNamed(AppRoutes.manageEvent, arguments: event),
                  ),
                  if (eventId != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          Get.dialog(
                            CustomMsgDialog(
                              title: "Delete this event?",
                              buttonText: "Delete",
                              iconPath: "assets/icon/Frame (27).svg", // Adjust if you have a trash icon
                              onCancel: () => Get.back(),
                              onConfirm: () async {
                                Get.back(); // close dialog
                                Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
                                final success = await homeController.deleteEvent(eventId.toString());
                                Get.back(); // close loading
                                if (success) {
                                  Get.snackbar("Success", "Event deleted successfully", backgroundColor: Colors.green, colorText: Colors.white);
                                } else {
                                  Get.snackbar("Error", "Could not delete event", backgroundColor: Colors.red, colorText: Colors.white);
                                }
                              },
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
