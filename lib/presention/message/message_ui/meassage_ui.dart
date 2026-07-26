import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/global_widget/customnavigator_button.dart';
import 'package:meetvibe/presention/home/home_widget/search_bar.dart';
import 'package:meetvibe/presention/message/message_controller/msgcontroller.dart';
import 'package:meetvibe/unity/app_text_styles/app_text_style.dart';
import 'all_message.dart';
import 'Primary_message.dart';
import 'events_message.dart';
import 'request_message.dart';

class MeassageUi extends StatelessWidget {
  const MeassageUi({super.key});

  @override
  Widget build(BuildContext context) {
    final MsgController controller = Get.put(MsgController());
    final List<String> tabs = ['All', 'Primary', 'Events', 'Request'];

    final List<Widget> tabViews = const [
      AllMessage(),
      PrimaryMessage(),
      EventsMessage(),
      RequestMessage(),
    ];

    Widget buildTabItem(int index) {
      return Obx(() {
        final isSelected = controller.selectedTabIndex.value == index;
        return GestureDetector(
          onTap: () {
            controller.selectedTabIndex.value = index;
          },
          child: Container(
            height: 31,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFE6CE) : const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: isSelected
                  ? const [
                      BoxShadow(
                        color: Color(0x29000000), // #000000 at 16% opacity
                        offset: Offset(0, 3),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                    ]
                  : null,
            ),
            child: Text(
              tabs[index],
              style: TextStyle(
                color: isSelected ? const Color(0xFFF2703D) : const Color(0xFF2D292E),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        );
      });
    }

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 2),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Message",
                    style: AppTextStyle.poppins(
                      size: 20,
                      weight: FontWeight.w700,
                      color: const Color(0xff2D292E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const HomeSearchBar(
                hintText: "Search message, people, events... ",
              ),
              const SizedBox(height: 20),

              // Custom horizontal tab selector
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    tabs.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: buildTabItem(index),
                    ),
                  ),
                ),
              ),

              // Active tab content view
              Obx(() => tabViews[controller.selectedTabIndex.value]),
            ],
          ),
        ),
      ),
    );
  }
}
