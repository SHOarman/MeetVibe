import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:get/get.dart';
import 'package:meetvibe/presention/createevent/create_event_controller/create_controller.dart';

class BasicInfoStep extends StatefulWidget {
  const BasicInfoStep({super.key});

  @override
  State<BasicInfoStep> createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends State<BasicInfoStep> {
  String? _selectedEventType;
  bool _isFree = true;

  @override
  Widget build(BuildContext context) {
    final createController = Get.isRegistered<CreateController>() ? Get.find<CreateController>() : Get.put(CreateController());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Cover Section
          Text(
            "Event Photo",
            style: AppTextStyle.poppins(
              size: 18,
              weight: FontWeight.bold,
              color: const Color(0xff2A2A2A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add a photo or banner for your event",
            style: AppTextStyle.poppins(
              size: 13,
              weight: FontWeight.normal,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: createController.pickCoverImage,
            child: Obx(() {
              if (createController.coverImage.value != null) {
                 return Container(
                   height: 150,
                   width: double.infinity,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(12),
                     image: DecorationImage(
                       image: FileImage(createController.coverImage.value!), 
                       fit: BoxFit.cover,
                     ),
                   ),
                 );
              }
              return CustomPaint(
                painter: DashedGradientPainter(
                  gradient: ui.Gradient.linear(
                    Offset(0, 0),
                    Offset(300, 150),
                    const [Color(0xFFEC6D43), Color(0xFFFFB670)],
                  ),
                  strokeWidth: 5.0,
                  radius: 12,
                  dashPattern: const [6, 4],
                ),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [Color(0xFFFFB670), Color(0xFFEC6D43)],
                          ).createShader(bounds);
                        },
                        child: const Icon(
                          Icons.upload_outlined,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Add Event cover",
                        style: AppTextStyle.inter(
                          size: 14,
                          weight: FontWeight.w500,
                          color: const Color(0xFF2A2A2A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Max size 10MB",
                        style: AppTextStyle.inter(
                          size: 11,
                          weight: FontWeight.normal,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          // Event Title Section
          const SizedBox(height: 30),
          Text(
            "Event Title",
            style: AppTextStyle.poppins(
              size: 18,
              weight: FontWeight.w600,
              color: const Color(0xff2A2A2A),
            ),
          ),
          const SizedBox(height: 8),
          CustomTextfild(
            hintText: "Enter event title",
            controller: createController.titleController,
          ),

          const SizedBox(height: 30),
          Text(
            "Event Category",
            style: AppTextStyle.poppins(
              size: 18,
              weight: FontWeight.w600,
              color: const Color(0xff2A2A2A),
            ),
          ),
          const SizedBox(height: 8),
          DynamicCategoryRow(controller: createController),

          // Event Description Section
          const SizedBox(height: 30),
          Text(
            "Event Description",
            style: AppTextStyle.poppins(
              size: 18,
              weight: FontWeight.w600,
              color: const Color(0xff2A2A2A),
            ),
          ),
          const SizedBox(height: 8),
          const CustomTextfild(
            hintText: "Enter event description...",
            maxLines: 4,
          ),

          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Event Type",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0C0A09),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      final items = createController.dynamicEventTypes.isEmpty
                          ? ['In-Person', 'Online', 'Webinar', 'Other']
                          : createController.dynamicEventTypes.toList();
                      
                      String? dropdownValue = _selectedEventType;
                      if (!items.contains(dropdownValue) && items.isNotEmpty) {
                        dropdownValue = null;
                      }

                      return DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: dropdownValue,
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
                          "Select event type",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                        items: items.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type,
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
                            _selectedEventType = newValue;
                          });
                          if (newValue != null) {
                            createController.eventType.value = newValue;
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Capacity Input
              Expanded(
                child: CustomTextfild(
                  labelText: "Capacity",
                  hintText: "e.g. 100",
                  controller: createController.capacityController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Plan",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0C0A09),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => _PlanToggle(
                      isFreeSelected: createController.isFree.value,
                      onChanged: (val) {
                        createController.isFree.value = val;
                      },
                    )),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Price (optional)
              Expanded(
                child: CustomTextfild(
                  labelText: "Price (optional)",
                  hintText: "e.g. 0.00",
                  controller: createController.priceController,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                    child: Text(
                      "\$",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PlanToggle extends StatelessWidget {
  final bool isFreeSelected;
  final ValueChanged<bool> onChanged;

  const _PlanToggle({
    required this.isFreeSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x1A000000)),
      ),
      child: Row(
        children: [
          // Free Option
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: Container(
                decoration: BoxDecoration(
                  color: isFreeSelected
                      ? const Color(0xFFFFE7CF)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(7),
                    bottomLeft: Radius.circular(7),
                  ),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFreeSelected
                              ? const Color(0xFFEC6D43)
                              : Colors.white,
                          border: Border.all(
                            color: isFreeSelected
                                ? const Color(0xFFEC6D43)
                                : const Color(0xFFD1D5DB),
                            width: 2,
                          ),
                        ),
                        child: isFreeSelected
                            ? Center(
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Free",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF0C0A09),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Vertical Divider
          Container(
            width: 1,
            height: double.infinity,
            color: const Color(0x1A000000),
          ),
          // Premium Option
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: Container(
                decoration: BoxDecoration(
                  color: !isFreeSelected
                      ? const Color(0xFFFFE7CF)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: !isFreeSelected
                              ? const Color(0xFFEC6D43)
                              : Colors.white,
                          border: Border.all(
                            color: !isFreeSelected
                                ? const Color(0xFFEC6D43)
                                : const Color(0xFFD1D5DB),
                            width: 2,
                          ),
                        ),
                        child: !isFreeSelected
                            ? Center(
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Premium",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF0C0A09),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashedGradientPainter extends CustomPainter {
  final ui.Gradient gradient;
  final double strokeWidth;
  final double radius;
  final List<double> dashPattern;

  DashedGradientPainter({
    required this.gradient,
    this.strokeWidth = 1.5,
    this.radius = 12,
    this.dashPattern = const [6, 4],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..shader = gradient;

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = _createDashedPath(path, dashPattern);

    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source, List<double> pattern) {
    final Path dest = Path();
    for (final ui.PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      int index = 0;
      while (distance < metric.length) {
        final double len = pattern[index];
        if (draw) {
          dest.addPath(
            metric.extractPath(
              distance,
              (distance + len).clamp(0.0, metric.length),
            ),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
        index = (index + 1) % pattern.length;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant DashedGradientPainter oldDelegate) {
    return oldDelegate.gradient != gradient ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius;
  }
}

class DynamicCategoryRow extends StatelessWidget {
  final CreateController controller;
  const DynamicCategoryRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.dynamicCategories.isEmpty) {
        return const SizedBox(
          height: 100, 
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: controller.dynamicCategories.map((category) {
            final isSelected = controller.category.value == category['id'];
            final colors = [const Color(0xFFE6DDFA), const Color(0xFFDFEFE2), const Color(0xFFDEE5F7), const Color(0xFFFEDFE5), const Color(0xFFFFE5CF)];
            final idx = category['name'].toString().length % colors.length;
            final bgColor = colors[idx];

            return Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: GestureDetector(
                onTap: () {
                  controller.category.value = category['id'];
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 52.0,
                      width: 52.0,
                      decoration: BoxDecoration(
                        color: bgColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? const Color(0xFFEC6D43) : const Color(0x1A939393),
                          width: isSelected ? 2.0 : 1.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          category['emoji'] ?? '✨',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['name'] ?? '',
                      style: AppTextStyle.inter(
                        size: 12,
                        weight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: const Color(0xFF0C0A09),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}

