import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final double? width;

  const ProfileCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: 64,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 3),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,

                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        iconPath,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.error_outline,
                              size: 18,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title text
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D292E),
                      ),
                    ),
                  ],
                ),
                // Chevron icon
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF0F0F0F),
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
