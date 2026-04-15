class CashCheckingResponseModel {
  OpenedRegister? openedRegister;
  List<Payment>? payment;

  CashCheckingResponseModel({this.openedRegister, this.payment});

  CashCheckingResponseModel.fromJson(Map<String, dynamic> json) {
    openedRegister = json['OpenedRegister'] != null
        ? new OpenedRegister.fromJson(json['OpenedRegister'])
        : null;
    if (json['payment'] != null) {
      payment = <Payment>[];
      json['payment'].forEach((v) {
        payment!.add(new Payment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.openedRegister != null) {
      data['OpenedRegister'] = this.openedRegister!.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OpenedRegister {
  int? id;

  OpenedRegister({this.id});

  OpenedRegister.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class Payment {
  String? type;
  String? key;

  Payment({this.type, this.key});

  Payment.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['key'] = this.key;
    return data;
  }
}
