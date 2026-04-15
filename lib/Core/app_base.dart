part of 'application_base.dart';

class AppBase extends ChangeNotifier {
  String applicationName = '';
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final bool _isPhone = kIsWeb ? false : true;
  bool isDebug = ProfileManager.getProfileState() == ProfileState.debug;
  late AppProfile _appProfile;

  AppProfile get appProfile => _appProfile;

  bool get isPhone => _isPhone;


  set appProfile(AppProfile _) {
    print("application base debug mode");
    _appProfile = _;
    notifyListeners();
  }
}
