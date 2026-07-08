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

class HomeUi extends StatelessWidget {
  const HomeUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
      body: SingleChildScrollView(
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(
                  children: [
                    NearbyEventCard(
                      title: 'Live Music Festival',
                      categoryName: 'Music',
                      categoryColor: const Color(0xFF6B46C1),
                      attendeeCount: 124,
                      location: 'Gulsan lake park',
                      dateTime: '02 July - 6:00 PM',
                      imagePath: 'assets/image/image 6 (1).png',
                      onJoinTap: () => Get.toNamed(AppRoutes.eventdetels),
                    ),
                    const SizedBox(width: 14),
                    NearbyEventCard(
                      title: 'Weekend Hike & Camping',
                      categoryName: 'Adventure',
                      categoryColor: const Color(0xFFF97316),
                      attendeeCount: 32,
                      location: 'Sajek Valley',
                      dateTime: '05 July - 8:00 AM',
                      imagePath: 'assets/image/image 6 (1).png',
                      onJoinTap: () => Get.toNamed(AppRoutes.eventdetels),
                    ),
                  ],
                ),
              ),

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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(
                  children: [
                    UpcomingEventCard(
                      day: '05',
                      month: 'Jun',
                      title: 'Teach Talk',
                      attendeeCount: 68,
                      location: 'Zoom Office, Dhaka',
                      distance: '2.1 km away',
                      imagePath: 'assets/image/image 6 (3).png',
                      onJoinTap: () => Get.toNamed(AppRoutes.eventdetels),
                    ),
                    const SizedBox(width: 14),
                    UpcomingEventCard(
                      day: '08',
                      month: 'Jun',
                      title: 'Morning Yoga Session',
                      attendeeCount: 35,
                      location: 'Hatirjhil Park',
                      distance: '3.4 km away',
                      imagePath: 'assets/image/image 6 (2).png',
                      onJoinTap: () => Get.toNamed(AppRoutes.eventdetels),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
