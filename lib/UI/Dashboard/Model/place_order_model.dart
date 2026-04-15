class PlaceOrderModel {
  List<Bill>? bill;
  int? total;

  PlaceOrderModel({this.bill, this.total});

  PlaceOrderModel.fromJson(Map<String, dynamic> json) {
    if (json['bill'] != null) {
      bill = <Bill>[];
      json['bill'].forEach((v) {
        bill!.add(Bill.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bill != null) {
      data['bill'] = bill!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    return data;
  }
}

class Bill {
  int? productId;
  int? productVariableId;
  double? quantity;

  Bill({this.productId, this.productVariableId, this.quantity});

  Bill.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productVariableId = json['product_variable_id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_variable_id'] = productVariableId;
    data['quantity'] = quantity;
    return data;
  }
}
