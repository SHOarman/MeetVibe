import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetvibe/presention/message/message_controller/msgcontroller.dart';
import 'package:meetvibe/presention/message/message_widget/connection_request_card.dart';

class RequestMessage extends StatelessWidget {
  const RequestMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final MsgController controller = Get.find<MsgController>();

    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        children: [
          // Section Header: Connection Requests
          Text(
            "Connection Requests",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0C0A09),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0x1A000000), height: 1),
          const SizedBox(height: 8),

          Obx(() {
            if (controller.connectionRequests.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: Text(
                    "No pending requests",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: controller.connectionRequests.map((req) {
                return ConnectionRequestCard(
                  name: req.name,
                  meetupName: req.meetupName,
                  mutualConnections: req.mutualConnections,
                  timeAgo: req.timeAgo,
                  avatarPath: req.avatarPath,
                  onAccept: () => controller.acceptRequest(req),
                  onIgnore: () => controller.ignoreRequest(req),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
