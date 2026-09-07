import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:get/get.dart';
import 'package:meetvibe/presention/createevent/create_event_controller/create_controller.dart';

class DateTimeStep extends StatefulWidget {
  const DateTimeStep({super.key});

  @override
  State<DateTimeStep> createState() => _DateTimeStepState();
}

class _DateTimeStepState extends State<DateTimeStep> {
  final createController = Get.isRegistered<CreateController>() ? Get.find<CreateController>() : Get.put(CreateController());

  String _formatDate(DateTime date) {
    final weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return "$weekday, ${date.day} $month ${date.year}";
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFEC6D43),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (isStart) {
        createController.startDate.value = picked;
        createController.startDateController.text = _formatDate(picked);
      } else {
        createController.endDate.value = picked;
        createController.endDateController.text = _formatDate(picked);
      }
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFEC6D43),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (isStart) {
         createController.startTime.value = picked;
         createController.startTimeController.text = _formatTime(picked);
      } else {
         createController.endTime.value = picked;
         createController.endTimeController.text = _formatTime(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date & Time",
            style: AppTextStyle.poppins(
              size: 22,
              weight: FontWeight.bold,
              color: const Color(0xFF0C0A09),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "When is the event",
            style: AppTextStyle.poppins(
              size: 14,
              weight: FontWeight.normal,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Start Date
          CustomTextfild(
            controller: createController.startDateController,
            labelText: "Start Date",
            hintText: "Sat, 31 June 2026",
            readOnly: true,
            onTap: () => _selectDate(context, true),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(14.0),
              child: SvgPicture.asset(
                "assets/icon/Frame (31).svg",
                width: 16,
                height: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Start Time
          CustomTextfild(
            controller: createController.startTimeController,
            labelText: "Start Time",
            hintText: "10:00 AM",
            readOnly: true,
            onTap: () => _selectTime(context, true),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(14.0),
              child: SvgPicture.asset(
                "assets/icon/Frame (32).svg",
                width: 16,
                height: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // End Date (Optional)
          CustomTextfild(
            controller: createController.endDateController,
            labelText: "End Date",
            hintText: "Sat, 31 June 2026",
            readOnly: true,
            onTap: () => _selectDate(context, false),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(14.0),
              child: SvgPicture.asset(
                "assets/icon/Frame (31).svg",
                width: 16,
                height: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // End Time
          CustomTextfild(
            controller: createController.endTimeController,
            labelText: "End Time",
            hintText: "10:00 AM",
            readOnly: true,
            onTap: () => _selectTime(context, false),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(14.0),
              child: SvgPicture.asset(
                "assets/icon/Frame (32).svg",
                width: 16,
                height: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Time Zone TextField
          CustomTextfild(
            controller: createController.timezoneController,
            labelText: "Time Zone",
            hintText: "E.g., Asia/Dhaka or GMT+6",
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
