
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meetvibe/core/dependency_injection/injecation.dart';
import 'package:meetvibe/core/route/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meetvibe/core/route/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  DependencyInjection.bindings();

  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('accessToken');
  final bool hasToken = (token != null && token.isNotEmpty);

  runApp(MyApp(hasToken: hasToken));
}

class MyApp extends StatelessWidget {
  final bool hasToken;
  
  const MyApp({super.key, this.hasToken = false});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MeetVibe',
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF2703D),
          primary: const Color(0xFFF2703D),
        ),
        useMaterial3: true,
      ),
      initialRoute: hasToken ? AppRoutes.homeui : AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
