import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';

class OnboardingNavigation extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onTap;

  const OnboardingNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _buildDot(int index) {
    final isSelected = index == currentIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 12,
      width: isSelected ? 24 : 12,
      decoration: BoxDecoration(
        gradient: isSelected ? Appcolors.primaryGradient : null,
        color: isSelected ? null : const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36, top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => _buildDot(index)),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 140,
              height: 48,
              decoration: BoxDecoration(
                gradient: Appcolors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Appcolors.pramary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
