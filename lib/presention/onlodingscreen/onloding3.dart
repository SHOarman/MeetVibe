import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';
import 'nextbutton/next_button.dart';

class Onloding3 extends StatelessWidget {
  const Onloding3({super.key});

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
                        'assets/image/image 11.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.map, size: 80)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Heading text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Discover Community\nVibes and Events.',
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
                    // Subtitle description text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: Text(
                        'Join community events and skill workshops to meet like-minded people. Discover curated vibes and find groups that align with your interests for authentic connections.',
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
              currentIndex: 2,
              onTap: () => Get.toNamed(AppRoutes.loginOrSignUp),
            ),
          ],
        ),
      ),
    );
  }
}
