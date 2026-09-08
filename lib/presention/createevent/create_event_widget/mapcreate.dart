import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MapCreateWidget extends StatelessWidget {
  const MapCreateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x1A000000)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Map Image
                  Image.asset(
                    "assets/image/dubai_map.png",
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Address & Details Container
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row 1: Location Pin & Address
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icon/Frame (12).svg",
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Dubai, Al Aweer, 7025",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2A2A2A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Row 2: Route & Distance
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icon/Frame (23).svg",
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "2.1 km away",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        
          Positioned(
            right: 16,
            bottom: 35, // Positioned overlapping map and bottom card
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/icon/Frame (33).svg",
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
