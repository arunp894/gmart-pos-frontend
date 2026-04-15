import 'package:gmart/Core/application_base.dart';

class SpEngine {
  SharedPreferences? prefs;

  SpEngine() {
    startEngine();
  }

  void startEngine() async {
    prefs = await SharedPreferences.getInstance();
  }
}
