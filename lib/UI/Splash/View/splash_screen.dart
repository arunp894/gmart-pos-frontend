import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Splash/ViewModel/splash_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/main';
  // static const routeName = '/viceMain';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? pref;
  DateTime? currentBackPressTime;
  SplashViewModel? model;

  @override
  void initState() {
    // startNavigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = DateTime.now();
            Fluttertoast.showToast(
              msg: "Press again to exit",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: AppColor.primaryColor,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          }
        }
      },
      child: BaseView<SplashViewModel>(
        prepareModel: (model) {
          this.model = model;
          model.startNavigate();
        },
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Image.asset("assets/images/mavi_logo.png"),
            ),
          );
        },
      ),
    );
  }

/*  void startNavigate() async {
    await Future.delayed(const Duration(seconds: 3));
    applicationCore!.setNotification();
    bool isLogged = LocalStorage.getBool(AppStrings.isLogIn);
    Navigator.of(context).pushNamedAndRemoveUntil(
      isLogged ? "/Dashboard" : "/LoginScreen",
      (route) => false,
    );
  }*/
  startNavigate() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, navigatePage);
  }

  navigatePage() async {
    pref = spEngine?.prefs;
    bool isLogged =
        pref == null ? false : pref!.getBool(AppStrings.isLogIn) ?? false;
    int isCash = pref == null ? 0 : pref!.getInt(AppStrings.isCash) ?? 0;
    Navigator.of(context).pushNamedAndRemoveUntil(
      isLogged && isCash != 0 ? "/Dashboard" : "/LoginScreen",
      // "/Dashboard",
      (route) => false,
    );
  }
}
