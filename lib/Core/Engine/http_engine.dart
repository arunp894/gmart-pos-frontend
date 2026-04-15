import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:dio/dio.dart';

class HttpEngine {
  HttpEngine();

  SharedPreferences? prefs;
  Dio? dio;
  Dio? refreshDio;

  Future<Response> get({required String url, bool isProtected = true}) async {
    prefs = spEngine!.prefs;
    dio = Dio();
    dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (isProtected) {
          Map<String, dynamic> header = {
            "Authorization":
                "Bearer ${prefs!.getString(AppStrings.accessToken)}"
          };
          options.headers.addAll(header);
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) {
        if (error.response!.statusCode == 400) {
          return handler.next(error);
        } else if (error.response!.statusCode == 401) {
          return handler.next(error);
        } else if (error.response!.statusCode != 200 ||
            error.response!.statusCode == 400 ||
            error.response!.statusCode == 401) {
          return handler.next(error);
        }
      },
    ));
    Response response = await dio!.get(url);
    return response;
  }

  Future<Response> downloadFile(
      {required String url, bool isProtected = true}) async {
    prefs = spEngine!.prefs;
    dio = Dio();
    dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (isProtected) {
          Map<String, dynamic> header = {
            "Authorization":
                "Bearer ${prefs!.getString(AppStrings.accessToken)}"
          };
          options.responseType = ResponseType.bytes;
          options.headers.addAll(header);
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) {
        if (error.response!.statusCode == 400) {
          return handler.next(error);
        } else if (error.response!.statusCode == 401) {
          return handler.next(error);
        } else if (error.response!.statusCode != 200 ||
            error.response!.statusCode == 400 ||
            error.response!.statusCode == 401) {
          return handler.next(error);
        }
      },
    ));
    Response response = await dio!.get(url);
    return response;
  }

  Future<Response> post(
      {required String url, bool isProtected = true, required postData}) async {
    prefs = spEngine!.prefs;
    dio = Dio();
    dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (isProtected) {
          Map<String, dynamic> header = {
            "Authorization":
                "Bearer ${prefs!.getString(AppStrings.accessToken)}"
          };
          options.headers.addAll(header);
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // HttpResponseModel res = HttpResponseModel.fromJson(response.data);
        // debugPrint("After Response : ${res.toString()}");
        return handler.next(response);
      },
      onError: (error, handler) {
        if (error.response!.statusCode == 400) {
          return handler.next(error);
        } else if (error.response!.statusCode == 401) {
          return handler.next(error);
        } else if (error.response!.statusCode != 200 ||
            error.response!.statusCode == 400) {
          // dialogueEngine!.showDialogueBox(
          //     msg: "Oops! something wen wrong...", isClose: true);
          return handler.next(error);
        }
      },
    ));
    Response response = await dio!.post(url, data: postData);
    return response;
  }

  /*Future<void> callRefreshToken(
      DioException e, ErrorInterceptorHandler handler) async {
    refreshDio = Dio();
    prefs = spEngine!.prefs;
    final completer = Completer<void>();
    RequestOptions options = e.response!.requestOptions;
    options.headers.clear();
    FormData bodyData = FormData.fromMap({
      "refresh": 'Bearer ${prefs!.getString(AppStrings.refreshToken) ?? ""}'
    });
    refreshDio!
        .post(applicationCore!.appProfile.baseUrl! + AppStrings.userRefreshUrl,
            data: bodyData, options: Options(headers: options.headers))
        .then(
      (value) async {
        if (value.statusCode == 200 && value.statusCode == 201) {
          RefreshResponseModel entity =
              RefreshResponseModel.fromJson(value.data);
          prefs!.setString(AppStrings.accessToken, entity.access ?? "");
          Map<String, dynamic> header = {
            "Authorization":
                "Bearer ${prefs!.getString(AppStrings.accessToken)}"
          };
          final response = await dio!.request(e.requestOptions.path,
              options: Options(headers: header, method: options.method),
              data: options.data);
          handler.resolve(response);
          completer.complete();
        } else {
          await clearData();
          completer.completeError('Refresh token error');
          Navigator.of(applicationCore!.navigatorKey.currentContext!)
              .pushNamedAndRemoveUntil("/", (route) => false);
        }
      },
    ).onError(
      (error, stackTrace) async {
        await clearData();
        completer.completeError('Refresh token error');
        Navigator.of(applicationCore!.navigatorKey.currentContext!)
            .pushNamedAndRemoveUntil("/", (route) => false);
      },
    );
    return completer.future;
  }*/

  Future<void> clearPrefsExcept(String keyToKeep) async {
    final prefs = spEngine!.prefs; // or however you get SharedPreferences
    final keys = prefs!.getKeys().toList(); // get all keys

    for (var key in keys) {
      if (key != keyToKeep) {
        await prefs.remove(key); // remove everything except keyToKeep
      }
    }
  }

}
