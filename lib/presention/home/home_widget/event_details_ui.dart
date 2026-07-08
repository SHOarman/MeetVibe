import 'package:flutter/material.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class EventDetailsUi extends StatelessWidget {
  const EventDetailsUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event Details',
          style: AppTextStyle.poppins(size: 18, weight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Text(
          'Event Details Screen',
          style: AppTextStyle.poppins(size: 16, weight: FontWeight.w500),
        ),
      ),
    );
  }
}
