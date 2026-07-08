import 'package:flutter/material.dart';

import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class EventButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const EventButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = 146.0,
    this.height = 29.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFEC6D43),
              Color(0xFFFFB670),
            ],
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyle.inter(
              size: 12,
              weight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
