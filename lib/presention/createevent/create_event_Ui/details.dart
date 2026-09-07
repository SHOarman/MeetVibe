import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/presention/auth/auth_widget/customtextfild.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'package:meetvibe/presention/createevent/create_event_controller/create_controller.dart';

class DetailsStep extends StatefulWidget {
  const DetailsStep({super.key});

  @override
  State<DetailsStep> createState() => _DetailsStepState();
}

class _DetailsStepState extends State<DetailsStep> {
  final createController = Get.isRegistered<CreateController>() ? Get.find<CreateController>() : Get.put(CreateController());

  @override
  void initState() {
    super.initState();
    if (createController.tags.isEmpty) {
      createController.tags.addAll(["tech", "networking"]);
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
            "Event Details",
            style: AppTextStyle.poppins(
              size: 18,
              weight: FontWeight.bold,
              color: const Color(0xff2A2A2A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Provide additional details like tags, visibility and description.",
            style: AppTextStyle.poppins(
              size: 13,
              weight: FontWeight.normal,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),



          CustomTextfild(
            labelText: "Agenda/Description",
            hintText: "Enter event details and description...",
            controller: createController.agendaController,
            maxLines: 4,
          ),
          const SizedBox(height: 20),

          CustomTextfild(
            labelText: "What to Bring",
            hintText: "e.g. Laptop and business cards",
            controller: createController.whatToBringController,
          ),
          const SizedBox(height: 20),
          Text(
            "Event Tag",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0C0A09),
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => _TagInput(
            tags: createController.tags.toList(),
            onChanged: (newTags) {
              createController.tags.assignAll(newTags);
            },
          )),
          const SizedBox(height: 24),


          Text(
            "Event Visibility",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0C0A09),
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Column(
            children: [
              _VisibilityOption(
                title: "Public",
                description: "Anyone can discover and join",
                isSelected: createController.visibility.value == 'PUBLIC',
                onTap: () {
                  createController.visibility.value = 'PUBLIC';
                },
              ),
              const SizedBox(height: 12),
              _VisibilityOption(
                title: "Friends Only",
                description: "Only Your Connections can join",
                isSelected: createController.visibility.value == 'PRIVATE',
                onTap: () {
                  createController.visibility.value = 'PRIVATE';
                },
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class _TagInput extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;

  const _TagInput({required this.tags, required this.onChanged});

  @override
  State<_TagInput> createState() => _TagInputState();
}

class _TagInputState extends State<_TagInput> {
  final _controller = TextEditingController();

  void _addTag(String val) {
    final text = val.trim();
    if (text.isNotEmpty && !widget.tags.contains(text)) {
      final newTags = List<String>.from(widget.tags)..add(text);
      widget.onChanged(newTags);
    }
    _controller.clear();
  }

  void _removeTag(String tag) {
    final newTags = List<String>.from(widget.tags)..remove(tag);
    widget.onChanged(newTags);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...widget.tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE7CF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tag,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2A2A2A),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => _removeTag(tag),
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: Color(0xFF2A2A2A),
                      ),
                    ),
                  ],
                ),
              )),
          SizedBox(
            width: 100,
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Add tag...",
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: GoogleFonts.poppins(fontSize: 14),
              onSubmitted: _addTag,
            ),
          ),
        ],
      ),
    );
  }
}

class _VisibilityOption extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _VisibilityOption({
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeBg = Color(0xFFFFE7CF);
    const activeBorderColor = Color(0x1A000000);
    const inactiveBorderColor = Color(0x1A000000);
    const activeRadioColor = Color(0xFFEC6D43);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 59,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? activeBorderColor : inactiveBorderColor,
          ),
        ),
        child: Row(
          children: [
            // Radio circle indicator
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? activeRadioColor : Colors.white,
                border: Border.all(
                  color: isSelected ? activeRadioColor : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: isSelected
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
            const SizedBox(width: 16),
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0C0A09),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
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
