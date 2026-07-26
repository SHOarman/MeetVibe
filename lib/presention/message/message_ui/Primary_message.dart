import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/route/app_routes.dart';
import 'package:meetvibe/presention/message/message_controller/msgcontroller.dart';
import 'package:meetvibe/presention/message/message_widget/message_tile.dart';

class PrimaryMessage extends StatelessWidget {
  const PrimaryMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final MsgController controller = Get.find<MsgController>();

    return Obx(() {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.primaryChats.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFF3F3F3),
        ),
        itemBuilder: (context, index) {
          final chat = controller.primaryChats[index];
          return CustomMessageTile(
            name: chat['name'] as String,
            avatar: chat['avatar'] as String,
            lastMessage: chat['lastMessage'] as String,
            time: chat['time'] as String,
            isOnline: chat['isOnline'] as bool,
            isTyping: chat['isTyping'] as bool,
            unreadCount: chat['unreadCount'] as int,
            hasAttachment: chat['hasAttachment'] as bool,
            onTap: () => Get.toNamed(AppRoutes.msgInbox),
          );
        },
      );
    });
  }
}
