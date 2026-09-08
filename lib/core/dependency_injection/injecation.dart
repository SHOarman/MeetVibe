import 'package:get/get.dart';
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';
import 'package:meetvibe/presention/createevent/create_event_controller/create_controller.dart';
import 'package:meetvibe/presention/message/message_controller/msgcontroller.dart';
import 'package:meetvibe/presention/profile/profile_controller/profile_controller.dart';
import 'package:meetvibe/presention/home/home_controller/home_controller.dart';
import 'package:meetvibe/presention/event/event_controller/event_join_controller.dart';
import 'package:meetvibe/presention/event/event_controller/event_host_controller.dart';

class DependencyInjection {
  static void bindings() {
    Get.lazyPut(() => Authcontroller(), fenix: true);
    Get.lazyPut(()=>MsgController(), fenix: true);
    Get.lazyPut(()=>ProfileController(), fenix: true);

    //=============================================create event================================================
    Get.lazyPut(() => CreateController(), fenix: true);
    Get.lazyPut(() => EventJoinController(), fenix: true); 
    Get.lazyPut(() => EventHostController(), fenix: true);

    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
