import 'package:get/get.dart';
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';
import 'package:meetvibe/presention/message/message_controller/msgcontroller.dart';
import 'package:meetvibe/presention/profile/profile_controller/profile_controller.dart';

class DependencyInjection {
  static void bindings() {
    Get.lazyPut(() => Authcontroller());
    Get.lazyPut(()=>MsgController());
    Get.lazyPut(()=>ProfileController());
  }
}
