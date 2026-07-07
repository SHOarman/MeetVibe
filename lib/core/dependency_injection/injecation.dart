import 'package:get/get.dart';
import 'package:meetvibe/presention/auth/auth_controller/authcontroller.dart';

class DependencyInjection {
  static void bindings() {
    Get.lazyPut(() => Authcontroller());
  }
}
