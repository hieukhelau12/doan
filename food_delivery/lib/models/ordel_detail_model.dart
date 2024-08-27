import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailModel {
  String? orderDetailID;
  String? orderID;
  String itemID;
  int? quantity;
  String? totalPrice;

  OrderDetailModel(
      {this.orderDetailID,
      this.orderID,
      this.itemID = "",
      this.quantity,
      this.totalPrice});

  factory OrderDetailModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return OrderDetailModel(
        orderDetailID: document.id,
        orderID: data['OrderID'] ?? '',
        itemID: data['ItemID'] ?? '',
        quantity: data['Quantity'] ?? 0,
        totalPrice: data['TotalPrice'] ?? "0",
      );
    } else {
      return OrderDetailModel.empty();
    }
  }

  static OrderDetailModel empty() => OrderDetailModel(
        orderDetailID: "",
        orderID: "",
        itemID: "",
        quantity: 0,
        totalPrice: "0",
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OrderID'] = orderID;
    data['ItemID'] = itemID;
    data['Quantity'] = quantity;
    data['TotalPrice'] = totalPrice;
    return data;
  }
}
