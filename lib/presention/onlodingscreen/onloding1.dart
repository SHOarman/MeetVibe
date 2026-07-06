import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';
import 'nextbutton/next_button.dart';

class Onloding1 extends StatelessWidget {
  const Onloding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Image.asset(
                        'assets/image/image 3.png',
                        height: 58,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.favorite,
                          color: Appcolors.pramary,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 340,
                      child: Image.asset(
                        'assets/image/image 6.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.person, size: 80)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Heading text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Build Meaningful\nConnections, Safely.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Appcolors.black,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: Text(
                        'Our verified profiles and smart interest matching help you discover your community and make every interaction unforgettable.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF000000),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Custom Onboarding Navigation
            OnboardingNavigation(
              currentIndex: 0,
              onTap: () => Get.toNamed(AppRoutes.onloding2),
            ),
          ],
        ),
      ),
    );
  }
}
