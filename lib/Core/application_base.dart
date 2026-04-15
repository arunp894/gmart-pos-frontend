library app_core;

import 'package:gmart/Core/AppModel/app_profile.dart';
import 'package:gmart/Core/Engine/database_engine.dart';
import 'package:gmart/Core/Engine/dialogue_engine.dart';
import 'package:gmart/Core/Engine/http_engine.dart';
import 'package:gmart/Core/Engine/sp_engine.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/Core/application_core.dart';
import 'package:get_it/get_it.dart';
export 'dart:async';
export 'package:flutter/material.dart';
export 'Base/base_model.dart';
export 'Base/base_view.dart';
export 'package:provider/provider.dart';
export 'package:flutter/foundation.dart';
export 'package:shared_preferences/shared_preferences.dart';

part 'app_base.dart';

part 'locator.dart';

SpEngine? spEngine;
ApplicationCore? applicationCore;
HttpEngine? httpEngine;
DialogueEngine? dialogueEngine;
DatabaseEngine? dataBaseEngine;


setUpBase() {
  locator.registerSingleton(SpEngine());
  locator.registerSingleton(HttpEngine());
  locator.registerSingleton(DialogueEngine());
  locator.registerSingleton(ApplicationCore());
  locator.registerSingleton(DatabaseEngine());
  spEngine = locator.get<SpEngine>();
  httpEngine = locator.get<HttpEngine>();
  dialogueEngine = locator.get<DialogueEngine>();
  applicationCore = locator.get<ApplicationCore>();
  dataBaseEngine = locator.get<DatabaseEngine>();
}

Future<void> initApplication(Widget rootApplication,
    {required AppProfile debugProfile,
    required AppProfile releaseProfile}) async {
  await setUpBase();
  switch (ProfileManager.getProfileState()) {
    case ProfileState.debug:
      // print("Switch debug mode");
      applicationCore!._appProfile = debugProfile;
      break;
    case ProfileState.profile:
      applicationCore!._appProfile = debugProfile;
      break;
    case ProfileState.release:
      applicationCore!._appProfile = releaseProfile;
      break;
  }
  runApp(Provider<ApplicationCore>(
    create: (context) => applicationCore!,
    builder: (context, child) => rootApplication,
  ));
}
