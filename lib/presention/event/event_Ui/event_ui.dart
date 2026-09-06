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

class EventUi extends StatelessWidget {
  const EventUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
      body: SingleChildScrollView(
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

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(
                  children: [
                    NearbyEventCard(
                      width: 176.0,
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
                      width: 176.0,
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


              SizedBox(height: 16,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(
                  children: [
                    UpcomingEventCard(
                      width: 176.0,
                      day: '05',
                      month: 'Jun',
                      title: 'Teach Talk',
                      attendeeCount: 100,
                      location: 'Zoom Office, Dhaka',
                      distance: '2.9 km away',
                      imagePath: 'assets/image/image 6 (3).png',
                      onJoinTap: () => Get.toNamed(AppRoutes.eventdetels),
                    ),
                    const SizedBox(width: 14),
                    UpcomingEventCard(
                      width: 176.0,
                      day: '10',
                      month: 'April',
                      title: 'Morning Yoga Session',
                      attendeeCount: 35,
                      location: 'Hatirjhil Park',
                      distance: '10.00 km away',
                      imagePath: 'assets/image/image 6 (2).png',
                      onJoinTap: () => Get.toNamed(AppRoutes.eventdetels),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 100,)
            ],
          ),
        ),
      ),
    );
  }
}
