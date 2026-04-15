import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';

class CustomDialogBox {
  Future<void> getCustomBox(
      {required BuildContext context,
      required String message,
      required Function() onDone,
      required Function() onCancel}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(16),
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: const Row(
            children: [
              Expanded(child: Divider(color: Colors.black12)),
              SizedBox(width: 15.0),
              Text(AppStrings.appName),
              SizedBox(width: 15.0),
              Expanded(child: Divider(color: Colors.black12)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyle(color: AppColor.blackColor, fontSize: 15.0),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkResponse(
                      onTap: onDone,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          "Yes",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: InkResponse(
                      onTap: onCancel,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          "No",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> customWidgetBox(
      {required BuildContext context,
      required String message,
      required Widget customWidget}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(16),
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: const Row(
            children: [
              Expanded(child: Divider(color: Colors.black12)),
              SizedBox(width: 15.0),
              Text(AppStrings.appName),
              SizedBox(width: 15.0),
              Expanded(child: Divider(color: Colors.black12)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyle(color: AppColor.blackColor, fontSize: 15.0),
              ),
              const SizedBox(
                height: 8.0,
              ),
              customWidget
            ],
          ),
        );
      },
    );
  }
}
