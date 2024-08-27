import 'package:get/get.dart';

import '../../controller/admin_controller/home_screen_controller.dart';
import '../../controller/admin_controller/login_screen_controller.dart';

class AppBinding extends Bindings
{
  @override
  void dependencies() {
  Get.lazyPut(()=> LoginScreenController());
  Get.lazyPut(()=> HomeScreenController());
  }
}