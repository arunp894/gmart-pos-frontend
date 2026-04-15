import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Constant/local_storage.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Dashboard/View/dashboard_screen.dart';
import 'package:gmart/UI/Dashboard/View/excel_import_screen.dart';
import 'package:gmart/UI/Dashboard/ViewModel/dashboard_view_model.dart';
import 'package:gmart/UI/Dashboard/ViewModel/local_dashboard_view_model.dart';
import 'package:gmart/UI/Dashboard/ViewModel/report_view_model.dart';
import 'package:gmart/UI/Login/View/login_screen.dart';
import 'package:gmart/UI/Login/ViewModel/login_view_model.dart';
import 'package:gmart/UI/Splash/View/splash_screen.dart';
import 'package:gmart/UI/Splash/ViewModel/splash_view_model.dart';
import 'package:gmart/UI/ViceDisplay/ViewModel/vice_display_view_model.dart';

class ApplicationCore extends AppBase {
  String initialRoute = "/";
  Map<String, Widget Function(BuildContext)> routes = {};

  ApplicationCore() {
    super.applicationName = AppStrings.appName;
    setUps();
  }

  setUps() {
    routes = {
      '/': (context) => const SplashScreen(),
      '/LoginScreen': (context) => const LoginScreen(),
      '/Dashboard': (context) => const DashboardScreen(),
      '/Excel': (context) => const ExcelImportScreen(),
    };
    locator.registerFactory(() => SplashViewModel());
    locator.registerFactory(() => DashboardViewModel());
    locator.registerFactory(() => LocalDashboardViewModel());
    locator.registerFactory(() => LoginViewModel());
    locator.registerFactory(() => ViceDisplayViewModel());
    locator.registerFactory(() => ReportViewModel());
  }

  setNotification() async {
    LocalStorage.putString(AppStrings.dummyValue, "Name");
    debugPrint("Notification Installed");
    debugPrint(LocalStorage.getString(AppStrings.dummyValue));
  }
}
