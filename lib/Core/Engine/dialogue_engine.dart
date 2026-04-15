import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';

class DialogueEngine {
  // SharedPreferences? prefs;
  DialogueEngine();

  showDialogueBox({String? msg, bool isClose = false}) {
    // prefs = spEngine!.prefs;
    showDialog(
      context: applicationCore!.navigatorKey.currentState!.overlay!.context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              children: [
                Expanded(
                  child: Divider(
                    height: 2,
                    color: Colors.black12,
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text(AppStrings.appName),
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Divider(
                    height: 2,
                    color: Colors.black12,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(msg ?? "")
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (isClose) {
                Navigator.of(ctx).pushNamedAndRemoveUntil(
                  "/",
                  (route) => false,
                );
              } else {
                Navigator.of(ctx).pop();
              }
              // Navigator.of(ctx).pop();
            },
            child: const Text("okay"),
          ),
        ],
      ),
    );
  }


}
