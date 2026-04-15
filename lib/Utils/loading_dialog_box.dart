import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Core/application_base.dart';

class LoadingDialogBox {
  Future<void> loading(BuildContext context, keyLoader, {String? msg}) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
            key: keyLoader,
            backgroundColor: Colors.black26,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: AppColor.primaryColor,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  msg ?? "Please wait",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                )
              ],
            ));
      },
    );
  }
}
