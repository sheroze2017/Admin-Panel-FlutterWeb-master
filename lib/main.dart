import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:admin_panel/constants/style.dart';
import 'package:admin_panel/controllers/menu_controller.dart'
    as menu_controller;
import 'package:admin_panel/controllers/navigation_controller.dart';
import 'package:admin_panel/env/env.dart';
import 'package:admin_panel/helpers/custom_auth.dart';
import 'package:admin_panel/layout.dart';
import 'package:admin_panel/pages/404/error_page.dart';
import 'package:admin_panel/pages/authentication/authentication.dart';
import 'package:admin_panel/routing/routes.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  Timer.periodic(Duration(seconds: 100), (timer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refresh_token = prefs.getString('refresh_token');
    String? mobile = prefs.getString('mobile');
    if (refresh_token != null && mobile != null) {
      final url = Uri.parse('$baseUrl/users/token');
      final body = jsonEncode({
        "email": "{{email}}",
        "mobile": mobile,
        "refresh_token": refresh_token
      });
      final headers = {'Content-Type': 'application/json'};
      try {
        final response = await http.post(url, headers: headers, body: body);
        if (response.statusCode == 200) {
          // Success
          print('API hit successful');
          String? accessToken =
              jsonDecode(response.body)['data']['access_token'] as String?;
          await prefs.setString('access_token', accessToken.toString());
          print(prefs.getString('access_token'));
          if (accessToken != null) {
          } else {
            print('Access token is null');
          }
        } else {
          // Handle error
          print('Failed to hit the API. Status code: ${response.statusCode}');
        }
      } catch (e) {
        // Handle error
        print('Error: $e');
      }
    } else {
      print('Refresh token or mobile is null');
    }
  });

  Get.put(menu_controller.MenuController());
  Get.put(NavigationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      initialRoute: authenticationPageRoute,
      unknownRoute:
          GetPage(name: '/not-found', page: () => const PageNotFound()),
      defaultTransition: Transition.leftToRightWithFade,
      getPages: [
        GetPage(name: rootRoute, page: () => SiteLayout()),
        GetPage(
            name: authenticationPageRoute,
            page: () => const AuthenticationPage()),
      ],
      debugShowCheckedModeBanner: false,
      title: "Admin Panel",
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        textTheme: GoogleFonts.mulishTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Colors.black,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
        primarySwatch: Colors.indigo,
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
