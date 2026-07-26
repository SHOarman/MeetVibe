import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';

class OnlodingScreen extends StatefulWidget {
  const OnlodingScreen({super.key});

  @override
  State<OnlodingScreen> createState() => _OnlodingScreenState();
}

class _OnlodingScreenState extends State<OnlodingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/image/image 6.png',
      'title': 'Build Meaningful\nConnections, Safely.',
      'subtitle': 'Our verified profiles and smart interest matching help you discover your community and make every interaction unforgettable.',
    },
    {
      'image': 'assets/image/image 9.png',
      'title': 'Unlock Shared Vibe\nInteractions.',
      'subtitle': 'Deepen your connections with interactive vibe matching. Send personalized interaction requests based on verified mutual interest and community.',
    },
    {
      'image': 'assets/image/image 11.png',
      'title': 'Discover Community\nVibes and Events.',
      'subtitle': 'Join community events and skill workshops to meet like-minded people. Discover curated vibes and find groups that align with your interests for authentic connections.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNextPressed() {
    if (_currentIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.toNamed(AppRoutes.loginOrSignUp);
    }
  }

  Widget _buildDot(int index) {
    final isSelected = index == _currentIndex;
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Static logo at the top
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
            
            // Sliding contents
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final item = _onboardingData[index];
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 340,
                          child: Image.asset(
                            item['image']!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(child: Icon(Icons.image, size: 80)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Heading text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            item['title']!,
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
                        // Subtitle text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          child: Text(
                            item['subtitle']!,
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
                  );
                },
              ),
            ),
            
            // Fixed dots and button at the bottom
            Padding(
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
                    onTap: _onNextPressed,
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
            ),
          ],
        ),
      ),
    );
  }
}
