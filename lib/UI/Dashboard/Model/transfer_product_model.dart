class TransferProductModel{
  List<Transfer>? transfer = [];
  TransferProductModel({this.transfer});

  TransferProductModel.fromJson(Map<String, dynamic> json){
    if (json['transfer'] != null) {
      transfer = <Transfer>[];
      json['transfer'].forEach((v) {
        transfer!.add(Transfer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (transfer != null) {
      data['transfer'] = transfer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Transfer {
  int? productId;
  String? name;
  int? variantId;
  int? enableStock;
  int? quantity;
  double? totalPrice;
  String? unit;
  String? sellingPrice;


  Transfer(
      {this.quantity,
        this.name,
        this.sellingPrice,
        this.totalPrice,
        this.unit,
        this.variantId,
        this.productId,
        this.enableStock
      });

  Transfer.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    name = json['name'];
    sellingPrice = json['sellingPrice'];
    totalPrice = json['totalPrice'];
    productId = json['productId'];
    unit = json['unit'];
    enableStock = json['enableStock'];
    variantId = json['variantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity'] = quantity;
    data['name'] = name;
    data['sellingPrice'] = sellingPrice;
    data['totalPrice'] = totalPrice;
    data['productId'] = productId;
    data['unit'] = unit;
    data['variantId'] = variantId;
    data['enableStock'] = enableStock;
    return data;
  }
}