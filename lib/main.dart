import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Core/AppModel/app_profile.dart';
import 'package:gmart/UI/Splash/View/splash_screen.dart';
import 'package:gmart/UI/ViceDisplay/view/vice_display_screen.dart';
import 'Core/application_base.dart' as core;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  AppProfile  releaseProfile =
  AppProfile(appName: "HNmart", baseUrl: "https://pettikadai.macromend.com/"); //https://pos.hnmartsg.com/

  AppProfile debugProfile  =
  AppProfile(appName: "HNmart", baseUrl: "https://planetearth.macromend.com/" // pos.gmart.sg/
  );
  core.initApplication(const MainApplication(),
      debugProfile: debugProfile, releaseProfile: releaseProfile);
}

class MainApplication extends StatefulWidget {
  const MainApplication({super.key});

  @override
  State<MainApplication> createState() => _MainApplicationState();
}

class _MainApplicationState extends State<MainApplication> {
  @override
  Widget build(BuildContext context) {
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
        theme: ThemeData(
            useMaterial3: false,
            // primaryColor: AppColor.primaryColor,
            colorSchemeSeed: AppColor.primaryColor),
        // initialRoute: core.applicationCore!.initialRoute,
        routes: core.applicationCore!.routes,
        navigatorKey: core.applicationCore!.navigatorKey,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (RouteSettings routeSettings) {
          return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                if (routeSettings.name == 'viceMain') {
                  return const ViceDisplayScreen();
                } else {
                  return const SplashScreen();
                }
              });
        });
  }
}
