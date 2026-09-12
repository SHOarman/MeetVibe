import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/global_widget/customnavigator_button.dart';
import 'package:meetvibe/presention/home/home_widget/event_card.dart';
import 'package:meetvibe/presention/home/home_widget/profilesecation.dart';
import 'package:meetvibe/presention/home/home_widget/search_bar.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/presention/home/home_widget/nearbycard.dart';
import 'package:meetvibe/presention/home/home_widget/tendingcatory.dart';
import 'package:meetvibe/presention/home/home_widget/upcomingevent.dart';
import 'package:meetvibe/presention/home/home_controller/home_controller.dart';

class HomeUi extends StatelessWidget {
  const HomeUi({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());
    
    // Controller initializes data automatically in onInit()

    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
      body: RefreshIndicator(
        onRefresh: () async {
          await homeController.fetchNearbyEvents();
          await homeController.fetchUpcomingEvents();
          await homeController.fetchMyEvents();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              ///===========================profilescation=======================================
              const ProfileSecation(),
              const SizedBox(height: 10),

              ///===================================Suchbar-===============================================
              const HomeSearchBar(),
              const SizedBox(height: 20),

              //-========================================Homecard---============================================
              HomeEventCard(
                title: 'Coffee Networking',
                description: 'A perfect match for your interests',
                attendeeCountText: '24 others going',
                bannerImagePath: 'assets/image/homer.png',
                attendeeAvatars: const [
                  'assets/image/Ellipse 12 (1).png',
                  'assets/image/Ellipse 13 (1).png',
                  'assets/image/Ellipse 14 (1).png',
                  'assets/image/Ellipse 15 (1).png',
                ],
                onJoinTap: () => Get.toNamed(AppRoutes.eventdetels),
              ),

              const SizedBox(height: 32),

              //-========================================Nearby Events Header============================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nearby Events",
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

              //-========================================Nearby Events Scroll============================================
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

              const SizedBox(height: 32),
              
              //-========================================Trending Categories Header======================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Trending Categories",
                    style: AppTextStyle.poppins(
                      size: 18,
                      weight: FontWeight.w600,
                      color: const Color(0xff0C0A09),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.tendingcatagory),
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
              const SizedBox(height: 10),

              ///===========================Trending Categories=======================================
              const TrendingCategoryRow(),
              const SizedBox(height: 20),

              //-========================================Upcoming Events Header============================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upcoming Events",
                    style: AppTextStyle.poppins(
                      size: 18,
                      weight: FontWeight.w600,
                      color: const Color(0xff0C0A09),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.upcominevent),
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

              //-========================================Upcoming Events Scroll============================================
              Obx(() {
                if (homeController.isLoadingUpcoming.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                
                if (homeController.upcomingEvents.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(child: Text("No upcoming events found")),
                  );
                }

                final displayEvents = homeController.upcomingEvents.take(3).toList();

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
                          distance: '2.1 km away', // Backend may not provide distance yet
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

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
