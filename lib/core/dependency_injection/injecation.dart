import 'package:get/get.dart';
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';
import 'package:meetvibe/presention/createevent/create_event_controller/create_controller.dart';
import 'package:meetvibe/presention/message/message_controller/msgcontroller.dart';
import 'package:meetvibe/presention/profile/profile_controller/profile_controller.dart';
import 'package:meetvibe/presention/home/home_controller/home_controller.dart';
import 'package:meetvibe/presention/event/event_controller/event_join_controller.dart';
import 'package:meetvibe/presention/event/event_controller/event_host_controller.dart';
import 'package:meetvibe/presention/message/message_controller/single_chat_controller.dart';
import 'package:meetvibe/presention/message/message_controller/group_chat_controller.dart';

class DependencyInjection {
  static void bindings() {
    Get.put(Authcontroller(), permanent: true);
    Get.put(MsgController(), permanent: true);
    Get.put(ProfileController(), permanent: true);

    //=============================================create event================================================
    Get.lazyPut(() => CreateController(), fenix: true);
    Get.lazyPut(() => EventJoinController(), fenix: true); 
    Get.lazyPut(() => EventHostController(), fenix: true);

    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => SingleChatController(), fenix: true);
    Get.lazyPut(() => GroupChatController(), fenix: true);
  }
}
