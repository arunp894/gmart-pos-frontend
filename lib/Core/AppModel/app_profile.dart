import 'package:flutter/foundation.dart';

class AppProfile {
  final String? baseUrl;
  final String? appName;
  final String? notificationId;
  final String? packAgeName;

  AppProfile(
      {this.baseUrl, this.appName, this.notificationId, this.packAgeName});
}

enum ProfileState { debug, release, profile }

class ProfileManager {
  static ProfileState getProfileState() {
    if (kReleaseMode) {
      return ProfileState.release;
    } else if (kDebugMode) {
      print("ProfileManager debug mode");
      return ProfileState.debug;
    } else {
      return ProfileState.profile;
    }
  }
}
