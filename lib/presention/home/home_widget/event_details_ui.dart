import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/presention/home/home_controller/home_controller.dart';
import 'package:meetvibe/presention/event/event_controller/event_join_controller.dart';
import 'package:meetvibe/presention/profile/profile_controller/profile_controller.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';

class EventDetailsUi extends StatelessWidget {
  const EventDetailsUi({super.key});

  Widget _buildAttendeeAvatars() {
    final avatarPaths = [
      "assets/image/Avatar.png",
      "assets/image/Avatar (1).png",
      "assets/image/Avatar (2).png",
      "assets/image/Avatar (3).png",
    ];
    return SizedBox(
      height: 32,
      width: 100,
      child: Stack(
        children: List.generate(avatarPaths.length, (index) {
          return Positioned(
            left: index * 20.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey[200],
                backgroundImage: AssetImage(avatarPaths[index]),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());
    final eventJoinController = Get.isRegistered<EventJoinController>() ? Get.find<EventJoinController>() : Get.put(EventJoinController());
    final profileController = Get.isRegistered<ProfileController>() ? Get.find<ProfileController>() : Get.put(ProfileController());
    final Map<String, dynamic>? event = Get.arguments as Map<String, dynamic>?;
    
    final currentUserId = profileController.userId.value;

    final eventId = event?['id'] ?? event?['_id'];
    final bool isHost = (event != null && event['creatorId'] == currentUserId) || (eventId != null && homeController.myEvents.any((e) {
      final myEventId = e['id'] ?? e['_id'];
      return myEventId != null && myEventId == eventId;
    }));

    // Check Participation Status
    String participationStatus = '';
    
    final participations = event?['participations'] ?? event?['participants'];
    if (participations != null && participations is List && currentUserId.isNotEmpty) {
      for (var p in participations) {
        final pUserId = p['userId'] ?? (p['user'] != null ? p['user']['id'] ?? p['user']['_id'] : '');
        if (pUserId == currentUserId) {
          participationStatus = p['status'] ?? 'PENDING';
          break;
        }
      }
    }

    final String title = event?['title'] ?? "Unknown Event";
    final String category = event?['category'] ?? "No category";
    final String coverImage = event?['coverImage'] ?? "";
    final String location = event?['address'] ?? event?['venueName'] ?? "Location TBA";
    final String agenda = event?['agenda'] ?? "No description available.";
    final int capacity = event?['capacity'] ?? 0;
    final bool isFree = event?['isFree'] == true || event?['isFree'] == 'true';
    final double price = (event?['price'] != null) ? double.tryParse(event!['price'].toString()) ?? 0.0 : 0.0;
    
    String startDateRaw = event?['startDate']?.toString() ?? "";
    String displayDate = startDateRaw.isNotEmpty ? startDateRaw.split('T').first : "Date TBA";
    
    String displayTime = event?['startTime']?.toString() ?? "Time TBA";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable Body
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Cover Image & Details Overlay
                Stack(
                  children: [
                    // Cover Image
                    coverImage.startsWith('http')
                        ? Image.network(
                            Apiservices.fixImageUrl(coverImage),
                            height: 330,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, tr) => Container(
                              height: 330, width: double.infinity, color: Colors.grey[300],
                            ),
                          )
                        : Image.asset(
                            "assets/image/image 6 (5).png",
                            height: 330,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    // Gradient Shadow Overlay
                    Container(
                      height: 330,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                    // Title and Metadata Details (Bottom of Image)
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Row 1: Date
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "$displayDate - $displayTime",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Row 2: Location
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                location,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // White Details Section Card (Overlaps the bottom of the image slightly)
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Attendees Row
                        Row(
                          children: [
                            _buildAttendeeAvatars(),
                            const SizedBox(width: 8),
                            Text(
                              "$capacity others going",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0x1A000000), height: 1),
                        const SizedBox(height: 20),

                        // About Section
                        Text(
                          "About This Event",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0C0A09),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          agenda,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Color(0x1A000000), height: 1),
                        const SizedBox(height: 20),

                        // Event Details Metadata
                        Text(
                          "Event Details",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0C0A09),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Detail row 1: Date
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 12),
                            Text(
                              displayDate,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2A2A2A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Detail row 2: Time
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_outlined,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 12),
                            Text(
                              displayTime,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2A2A2A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Detail row 3: Location
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 12),
                            Text(
                              location,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2A2A2A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Color(0x1A000000), height: 1),
                        const SizedBox(height: 24),

                        // Spot Reserved Card or Host Card
                        if (isHost || participationStatus.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isHost ? const Color(0xFFE5F1FF).withOpacity(0.5) : const Color(0xFFFFE7CF).withOpacity(0.25),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0x1A000000),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isHost 
                                            ? "You are the Host!" 
                                            : (participationStatus == 'APPROVED' ? "Your spot is reserved!" : "Request is $participationStatus"),
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF0C0A09),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        isHost 
                                            ? "Manage your event from the dashboard."
                                            : (participationStatus == 'APPROVED' ? "You're all set to join the event." : "Pending host approval."),
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isHost ? Colors.blue : const Color(0xFFEC6D43),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    isHost ? Icons.manage_accounts : Icons.calendar_today_rounded,
                                    color: isHost ? Colors.blue : const Color(0xFFEC6D43),
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (isHost || participationStatus.isNotEmpty)
                          const SizedBox(height: 24),
                        const SizedBox(height: 80), // Padding to clear bottom navigation bar
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Top Header Action Buttons (Back & Notification)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                    // Notification Button
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Sticky Action Bar
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 76,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.black.withOpacity(0.06),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isFree ? "Free Event" : "\$${price.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF10B981), // Emerald Green
                    ),
                  ),
                  Text(
                    isFree ? "No payment required" : "Premium Event",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: (isHost || participationStatus.isNotEmpty) ? null : () {
                  if (eventId != null) {
                    eventJoinController.joinEvent(eventId.toString(), isFree: isFree);
                  } else {
                    Get.snackbar("Error", "Invalid event ID. Cannot join.");
                  }
                },
                child: Container(
                  height: 44,
                  width: 140,
                  decoration: BoxDecoration(
                    color: isHost 
                        ? Colors.grey 
                        : (participationStatus.isNotEmpty ? (participationStatus == 'APPROVED' ? Colors.green : Colors.orange) : const Color(0xFFF96030)),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: Text(
                      isHost 
                          ? "You are Host" 
                          : (participationStatus.isNotEmpty ? participationStatus : "Join Event"),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
