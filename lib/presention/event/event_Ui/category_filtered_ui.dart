import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/home/home_widget/upcomingevent.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meetvibe/presention/home/home_controller/home_controller.dart';

class CategoryFilteredUi extends StatefulWidget {
  const CategoryFilteredUi({super.key});

  @override
  State<CategoryFilteredUi> createState() => _CategoryFilteredUiState();
}

class _CategoryFilteredUiState extends State<CategoryFilteredUi> {
  List<dynamic> events = [];
  bool isLoading = true;
  String categoryName = 'Category';
  String categorySlug = '';

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      categorySlug = args['slug'] ?? '';
      categoryName = args['name'] ?? 'Category';
    }
    fetchCategoryEvents();
  }

  Future<void> fetchCategoryEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      String url = '${Apiservices.eventList}?category=$categorySlug';
      final response = await GetConnect().get(
        url,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null && data['events'] != null) {
          setState(() {
            events = List.from(data['events']);
          });
        }
      }
    } catch (e) {
      print('Fetch category events error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final HomeController homeCtrl = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final int crossAxisCount = isTablet ? 3 : 2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0C0A09)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '$categoryName Events',
          style: AppTextStyle.poppins(
            size: 20,
            weight: FontWeight.bold,
            color: const Color(0xFF0C0A09),
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (isLoading && events.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (events.isEmpty) {
            return const Center(child: Text("No events found in this category", style: TextStyle(color: Colors.grey)));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: events.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.67,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 16.0,
            ),
            itemBuilder: (context, index) {
              final event = events[index];
              final String coverSource = (event['coverImage'] != null && event['coverImage'].toString().isNotEmpty) 
                                         ? Apiservices.fixImageUrl(event['coverImage']) 
                                         : '';

              return UpcomingEventCard(
                day: homeCtrl.getDay(event['startDate']),
                month: homeCtrl.getFormattedDate(event['startDate']).split(' ').length > 1 
                  ? homeCtrl.getFormattedDate(event['startDate']).split(' ')[1] 
                  : 'TBA',
                title: event['title'] ?? 'No Title',
                attendeeCount: event['participantsCount'] ?? event['_aggr_count_participants'] ?? event['capacity'] ?? 0,
                location: event['venueType']?.toString().toUpperCase() == 'ONLINE' ? 'Online' : (event['address'] ?? event['venueName'] ?? 'Location TBA'),
                distance: '',
                imagePath: coverSource.isNotEmpty ? coverSource : 'assets/image/image 6 (3).png',
                onJoinTap: () => Get.toNamed(AppRoutes.eventdetels, arguments: event),
              );
            },
          );
        },
      ),
    );
  }
}
