import 'package:flutter/material.dart';
import 'package:meetvibe/global_widget/customnavigator_button.dart';

class ProfileUi extends StatelessWidget {
  const ProfileUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
    );
  }
}
