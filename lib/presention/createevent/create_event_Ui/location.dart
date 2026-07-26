import 'package:flutter/material.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/presention/createevent/create_event_widget/venue_onlineoroffline.dart';
import 'package:meetvibe/presention/createevent/create_event_widget/mapcreate.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class LocationStep extends StatefulWidget {
  const LocationStep({super.key});

  @override
  State<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<LocationStep> {
  bool _isVenueSelected = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location",
              style: AppTextStyle.poppins(
                size: 18,
                weight: FontWeight.bold,
                color: const Color(0xff2A2A2A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Where is your event?",
              style: AppTextStyle.poppins(
                size: 13,
                weight: FontWeight.normal,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            VenueOnlineOrOfflineSelector(
              isVenueSelected: _isVenueSelected,
              onChanged: (value) {
                setState(() {
                  _isVenueSelected = value;
                });
              },
            ),

            const SizedBox(height: 24),
            CustomTextfild(labelText: "Venue Name", hintText: "e.g. Stadium"),

            SizedBox(height: 10),
            CustomTextfild(
              labelText: "Full Address",
              hintText: "ex. Road 27, Dhanmondi, Dhaka 1209, Bangladesh",
            ),

            SizedBox(height: 30),
            Text(
              "Show on Map",
              style: AppTextStyle.poppins(
                size: 15,
                weight: FontWeight.w800,
                color: Color(0xff0C0A09),
              ),
            ),
            SizedBox(height: 10,),
            const MapCreateWidget(),
          ],
        ),
      ),
    );
  }
}
