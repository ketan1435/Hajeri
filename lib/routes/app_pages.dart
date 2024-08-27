import 'package:get/get.dart';
import 'package:hajeri/routes/routes.dart';

import '../binding/admin_binding/app_binding.dart';
import '../screen/admin_screens/home_screen.dart';
import '../screen/admin_screens/login_screen.dart';

class AppPages {
  // Define Initial Route
  static String INITIAL_ROUTE = Routes.LOGIN_SCREEN_ROUTE;

  // Define Pages of aaplication
  static final pages = [
    GetPage(
        name: Routes.LOGIN_SCREEN_ROUTE,
        page: () => LoginScreen(),
        binding:AppBinding()
    ),
    GetPage(
        name: Routes.HOME_SCREEN_ROUTE,
        page: () => HomeScreen(),
        binding:AppBinding()
    )
  ];
}