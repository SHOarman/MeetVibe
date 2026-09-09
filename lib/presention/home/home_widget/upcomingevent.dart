import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetvibe/global_widget/eventbutton.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/core/services/api_sevices/api_services.dart';

class UpcomingEventCard extends StatelessWidget {
  final String day;
  final String month;
  final String title;
  final int attendeeCount;
  final String location;
  final String distance;
  final String imagePath;
  final VoidCallback onJoinTap;
  final double? width; // Optional width override
  final bool isJoined;
  final bool isFree;

  const UpcomingEventCard({
    super.key,
    required this.day,
    required this.month,
    required this.title,
    required this.attendeeCount,
    required this.location,
    required this.distance,
    required this.imagePath,
    required this.onJoinTap,
    this.width,
    this.isJoined = false,
    this.isFree = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent(double cardWidth) {
      final double cardHeight = cardWidth * 1.49;
      final double imageHeight = cardWidth * (95.0 / 176.0);

      return Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: const Color(0x0D000000), // #000000 with 5% opacity
            width: 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x29000000), // #000000 with 16% opacity
              offset: Offset(0, 3),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: Date & Image Row (Padding removed from top/right to align image)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Column (Added custom padding here)
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0, left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          day,
                          style: AppTextStyle.poppins(
                            size: 20,
                            weight: FontWeight.w600,
                            color: const Color(0xFF0C0A09),
                          ),
                        ),
                        Text(
                          month,
                          style: AppTextStyle.poppins(
                            size: 13,
                            weight: FontWeight.w600,
                            color: const Color(0xFF0C0A09),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 15,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                    child: imagePath.startsWith('http')
                        ? Image.network(
                            Apiservices.fixImageUrl(imagePath),
                            height: imageHeight,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, trace) => Container(
                              height: imageHeight,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                          )
                        : Image.asset(
                            imagePath,
                            height: imageHeight,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, trace) => Container(
                              height: imageHeight,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.outfit(
                        size: 14,
                        weight: FontWeight.w700,
                        color: const Color(0xFF0C0A09),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                              color: const Color(0x992A2A2A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icon/Frame (23).svg',
                          width: 12,
                          height: 12,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            distance,
                            style: AppTextStyle.outfit(
                              size: 11,
                              weight: FontWeight.w500,
                              color: const Color(0x992A2A2A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    EventButton(
                      text: isJoined ? 'Joined' : 'Join Event',
                      width: double.infinity,
                      onTap: onJoinTap,
                    ),
                  ],
                ),
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