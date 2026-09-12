import 'package:flutter/material.dart';
import 'package:meetvibe/presention/message/message_ui/Primary_message.dart';
import 'package:meetvibe/presention/message/message_ui/Events_message.dart';

class AllMessage extends StatelessWidget {
  const AllMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryMessage(),
        EventsMessage(showCards: false),
      ],
    );
  }
}

