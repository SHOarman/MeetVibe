import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';

class DateTimeStep extends StatefulWidget {
  const DateTimeStep({super.key});

  @override
  State<DateTimeStep> createState() => _DateTimeStepState();
}

class _DateTimeStepState extends State<DateTimeStep> {
  final _startDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endDateController = TextEditingController();
  final _endTimeController = TextEditingController();
  String? _selectedTimeZone;

  @override
  void dispose() {
    _startDateController.dispose();
    _startTimeController.dispose();
    _endDateController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

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

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
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
      controller.text = _formatDate(picked);
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
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
      controller.text = _formatTime(picked);
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
            controller: _startDateController,
            labelText: "Start Date",
            hintText: "Sat, 31 June 2026",
            readOnly: true,
            onTap: () => _selectDate(context, _startDateController),
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
            controller: _startTimeController,
            labelText: "Start Time",
            hintText: "10:00 AM",
            readOnly: true,
            onTap: () => _selectTime(context, _startTimeController),
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
            controller: _endDateController,
            labelText: "End Date (Optional)",
            hintText: "Sat, 31 June 2026",
            readOnly: true,
            onTap: () => _selectDate(context, _endDateController),
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
            controller: _endTimeController,
            labelText: "End Time",
            hintText: "10:00 AM",
            readOnly: true,
            onTap: () => _selectTime(context, _endTimeController),
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

          // Time Zone Dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Time Zone",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0C0A09),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedTimeZone,
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFD1D5DB),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFD1D5DB),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFEC6D43),
                      width: 1.5,
                    ),
                  ),
                  fillColor: const Color(0xFFF9FAFB),
                  filled: false,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF9CA3AF),
                ),
                hint: Text(
                  "select time zone",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                items: [
                  'GMT+6 (Dhaka)',
                  'GMT+0 (London)',
                  'EST (New York)',
                  'PST (Los Angeles)'
                ].map((String tz) {
                  return DropdownMenuItem<String>(
                    value: tz,
                    child: Text(
                      tz,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF0C0A09),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTimeZone = newValue;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
