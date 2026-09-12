import 'package:flutter/material.dart';
import 'package:meetvibe/global_widget/eventbutton.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class HomeEventCard extends StatelessWidget {
  final String title;
  final String description;
  final String attendeeCountText;
  final String bannerImagePath;
  final List<String> attendeeAvatars;
  final VoidCallback onJoinTap;

  const HomeEventCard({
    super.key,
    required this.title,
    required this.description,
    required this.attendeeCountText,
    required this.bannerImagePath,
    required this.attendeeAvatars,
    required this.onJoinTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.0,
      decoration: BoxDecoration(
        color: const Color(0x1AFFB670),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0x0D000000), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 12,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyle.poppins(
                            size: 15,
                            weight: FontWeight.w500,
                            color: const Color(0xFF0C0A09),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          description,
                          style: AppTextStyle.poppins(
                            size: 11,
                            weight: FontWeight.w400,
                            color: const Color(0xFF0C0A09),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 22,
                          width: (attendeeAvatars.length * 15.0) + 7.0,
                          child: Stack(
                            children: List.generate(
                              attendeeAvatars.length,
                              (index) => Positioned(
                                left: index * 15.0,
                                child: Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        attendeeAvatars[index],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            attendeeCountText,
                            style: AppTextStyle.poppins(
                              size: 10,
                              weight: FontWeight.w500,
                              color: const Color(0xFF7E7E7E),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    EventButton(text: 'Join Event', onTap: onJoinTap),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Align(
                alignment: Alignment.centerRight,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80.0),
                    bottomLeft: Radius.circular(80.0),
                    topRight: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                  child: bannerImagePath.startsWith('http')
                      ? Image.network(
                          bannerImagePath,
                          height: 160.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            'assets/image/homer.png',
                            height: 160.0,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          bannerImagePath,
                          height: 160.0,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
