import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/customnavigator_button.dart';
import 'package:meetvibe/presention/home/home_widget/nearbycard.dart';
import 'package:meetvibe/presention/home/home_widget/search_bar.dart';
import 'package:meetvibe/presention/home/home_widget/tendingcatory.dart'
    show TrendingCategoryRow;
import 'package:meetvibe/presention/home/home_widget/upcomingevent.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/presention/home/home_controller/home_controller.dart';
import 'package:get/get.dart';

class EventUi extends StatelessWidget {
  const EventUi({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
      body: RefreshIndicator(
        onRefresh: () async {
          await homeController.fetchPopularEvents();
          // other fetches if needed
        },
        child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 60),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Events",
                    style: AppTextStyle.poppins(
                      size: 20,
                      weight: FontWeight.w700,
                      color: Color(0xff2D292E),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'assets/icon/Frame (11).svg',
                      width: 28,
                      height: 28,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              const HomeSearchBar(),

              //===========================================
              SizedBox(height: 16),

              const TrendingCategoryRow(),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Near You",
                    style: AppTextStyle.poppins(
                      size: 18,
                      weight: FontWeight.w600,
                      color: const Color(0xff0C0A09),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.upcamingall),
                    child: Text(
                      "See All",
                      style: AppTextStyle.poppins(
                        size: 13,
                        weight: FontWeight.w500,
                        gradient: const LinearGradient(
                          colors: [Color(0xffEC6D43), Color(0xffFFB670)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Obx(() {
                if (homeController.isLoadingNearby.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                
                if (homeController.nearbyEvents.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(child: Text("No events found")),
                  );
                }

                final displayNearby = homeController.nearbyEvents.take(3).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: displayNearby.map((event) {
                      final eventId = (event['id'] ?? event['_id'] ?? '').toString();
                      final bool isJoined = homeController.joinedEventIds.contains(eventId);
                      final bool isFree = event['isFree'] == true || event['isFree'] == 'true';

                      int countFromDict = 0;
                      if (event['_count'] != null && event['_count'] is Map) {
                        countFromDict = event['_count']['participants'] ?? 0;
                      }
                      
                      final int joinedCount = countFromDict > 0 ? countFromDict :
                          (event['participations'] as List?)?.length ?? 
                          int.tryParse(event['participantCount']?.toString() ?? '') ?? 
                          int.tryParse(event['participantsCount']?.toString() ?? '') ?? 
                          int.tryParse(event['capacity']?.toString() ?? '') ?? 0;

                      return Padding(
                        padding: const EdgeInsets.only(right: 14.0),
                        child: NearbyEventCard(
                          width: 176.0,
                          title: event['title'] ?? 'Unknown Event',
                          categoryName: event['category'] ?? 'Category',
                          categoryColor: const Color(0xFF6B46C1),
                          attendeeCount: joinedCount,
                          location: event['venueType']?.toString().toUpperCase() == 'ONLINE' ? 'Online' : (event['address'] ?? event['venueName'] ?? 'Location TBA'),
                          dateTime: homeController.getFormattedDate(event['startDate']),
                          imagePath: event['coverImage'] ?? 'assets/image/image 6 (1).png',
                          isJoined: isJoined,
                          isFree: isFree,
                          onJoinTap: () => Get.toNamed(AppRoutes.eventdetels, arguments: event),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),

              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popular This Week",
                    style: AppTextStyle.poppins(
                      size: 18,
                      weight: FontWeight.w600,
                      color: const Color(0xff0C0A09),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.popularweek),
                    child: Text(
                      "See All",
                      style: AppTextStyle.poppins(
                        size: 13,
                        weight: FontWeight.w500,
                        gradient: const LinearGradient(
                          colors: [Color(0xffEC6D43), Color(0xffFFB670)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),


              SizedBox(height: 16,),
              Obx(() {
                if (homeController.isLoadingPopular.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                
                if (homeController.popularEvents.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(child: Text("No popular events found")),
                  );
                }

                // Show max 3 items as requested
                final displayEvents = homeController.popularEvents.take(3).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: displayEvents.map((event) {
                      final eventId = (event['id'] ?? event['_id'] ?? '').toString();
                      final bool isJoined = homeController.joinedEventIds.contains(eventId);
                      final bool isFree = event['isFree'] == true || event['isFree'] == 'true';

                      int countFromDict = 0;
                      if (event['_count'] != null && event['_count'] is Map) {
                        countFromDict = event['_count']['participants'] ?? 0;
                      }
                      
                      final int joinedCount = countFromDict > 0 ? countFromDict :
                          (event['participations'] as List?)?.length ?? 
                          int.tryParse(event['participantCount']?.toString() ?? '') ?? 
                          int.tryParse(event['capacity']?.toString() ?? '') ?? 0;

                      return Padding(
                        padding: const EdgeInsets.only(right: 14.0),
                        child: UpcomingEventCard(
                          width: 176.0,
                          day: homeController.getDay(event['startDate']),
                          month: homeController.getMonth(event['startDate']),
                          title: event['title'] ?? 'Unknown Event',
                          attendeeCount: joinedCount,
                          location: event['venueType']?.toString().toUpperCase() == 'ONLINE' ? 'Online' : (event['address'] ?? event['venueName'] ?? 'Location TBA'),
                          distance: '2.1 km away', // distance logic not yet in backend
                          imagePath: event['coverImage'] ?? 'assets/image/image 6 (3).png',
                          isJoined: isJoined,
                          isFree: isFree,
                          onJoinTap: () => Get.toNamed(AppRoutes.eventdetels, arguments: event),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),

              SizedBox(height: 100,)
            ],
          ),
        ),
      ),
      ),
    );
  }
}
