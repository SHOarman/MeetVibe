import 'package:flutter/material.dart';
import 'package:meetvibe/global_widget/customnavigator_button.dart';

class EventUi extends StatelessWidget {
  const EventUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
