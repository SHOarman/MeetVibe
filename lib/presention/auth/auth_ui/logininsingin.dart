import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/auth/auth_widget/loginbutton.dart';
import 'package:meetvibe/unity/appcolors/appcolors.dart';

class Logininsingin extends StatelessWidget {
  const Logininsingin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
         
          Positioned.fill(
            child: Image.asset(
              'assets/image/unsplash_dDlYGoYJqBw.png',
              fit: BoxFit.cover,

            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0x1A000000),
                    const Color(0x1A000000),
                    const Color(0x59FF8157),
                    const Color(0xD9000000),
                  ],
                  stops: const [0.0, 0.4, 0.75, 1.0],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(height: 30,),

                  //===========================logo==================================


                  Image.asset(
                    'assets/image/image 4.png',
                    height: 100,
                    fit: BoxFit.contain,

                  ),
                  const Spacer(flex: 3),
                  // Buttons Column
                  Column(
                    children: [
                      LoginButton(
                        svgPath: 'assets/icon/gmail.svg',
                        name: 'Sign up with Email',
                        onTap: () {
                          //===========================================
                        },
                      ),
                      const SizedBox(height: 16),
                      LoginButton(
                        svgPath: 'assets/icon/Google.svg',
                        name: 'Sign up with Google',
                        onTap: () {
                          //===========================================
                        },
                      ),
                      const SizedBox(height: 16),
                      LoginButton(
                        svgPath: 'assets/icon/appel.svg',
                        name: 'Sign up with Apple',
                        onTap: () {
                          //===========================================
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Already have account?',
                    style: GoogleFonts.poppins(
                      color: const Color(0xE6FFFFFF),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: () {

                      Get.toNamed(AppRoutes.login);
                    },
                    child: Container(
                      width: 120,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: Appcolors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x4DEC6D43),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Log in',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
