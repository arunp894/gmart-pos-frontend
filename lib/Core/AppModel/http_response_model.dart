class HttpResponseModel {
  dynamic data;
  String? msg;
  bool? status;

  HttpResponseModel({this.data, this.msg, this.status});

  HttpResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    msg = json['message'];
    status = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = msg;
    data['success'] = status;
    return data;
  }
}
