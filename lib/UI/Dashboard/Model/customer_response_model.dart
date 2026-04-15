class CustomerResponseModel {
  List<Customer>? customer = [];

  CustomerResponseModel({this.customer});

  CustomerResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['customer'] != null) {
      customer = <Customer>[];
      json['customer'].forEach((v) {
        customer!.add(new Customer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['customer'] = this.customer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customer {
  int? id;
  String? text;
  String? mobile;
  String? name;

  Customer(
      {this.id,
        this.text,
        this.mobile,
        this.name
        });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    mobile = json['mobile'];
    name = json['name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['mobile'] = this.mobile;
    data['name'] = this.name;
    return data;
  }
}
