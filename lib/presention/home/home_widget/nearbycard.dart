import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetvibe/global_widget/eventbutton.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class NearbyEventCard extends StatelessWidget {
  final String title;
  final String categoryName;
  final Color categoryColor;
  final int attendeeCount;
  final String location;
  final String dateTime;
  final String imagePath;
  final VoidCallback onJoinTap;
  final double? width; // Optional width override

  const NearbyEventCard({
    super.key,
    required this.title,
    required this.categoryName,
    required this.categoryColor,
    required this.attendeeCount,
    required this.location,
    required this.dateTime,
    required this.imagePath,
    required this.onJoinTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent(double cardWidth) {
      final double imageHeight = cardWidth / 1.5;
      return Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: const Color(0x0D000000), // #000000 with 5% opacity
            width: 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000), // #000000 with 4% opacity
              offset: Offset(0, 3),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Event Banner Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: Image.asset(
                imagePath,
                width: cardWidth,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: AppTextStyle.outfit(
                      size: 13,
                      weight: FontWeight.bold,
                      color: const Color(0xFF2A2A2A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Category and Attendee Badges Row
                  Row(
                    children: [
                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 3.0,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          categoryName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Attendee count badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 3.0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5A5A5A),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icon/Frame (15).svg',
                              width: 8,
                              height: 8,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '$attendeeCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Location Details Row
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icon/Frame (12).svg',
                        width: 12,
                        height: 12,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          style: AppTextStyle.outfit(
                            size: 11,
                            weight: FontWeight.w500,
                            color: const Color(0x992A2A2A), // 60% opacity
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Date/Time Row
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icon/Frame (14).svg',
                        width: 12,
                        height: 12,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          dateTime,
                          style: AppTextStyle.outfit(
                            size: 11,
                            weight: FontWeight.w500,
                            color: const Color(0x992A2A2A), // 60% opacity
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Join Event Button (scaled to fit card width)
                  EventButton(
                    text: 'Join Event',
                    width: double.infinity,
                    onTap: onJoinTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (width != null) {
      return cardContent(width!);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return cardContent(constraints.maxWidth);
      },
    );
  }
}