import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? orderID;
  String? userID;
  String? restaurantID;
  String? orderDate;
  String? totalAmount;
  String? deliveryAddress;
  String? clientName;
  String? clientPhone;
  String? completeDate;
  String? paymentMethod;
  int status;

  OrderModel(
      {this.orderID,
      this.userID,
      this.restaurantID,
      this.orderDate,
      this.totalAmount,
      this.deliveryAddress,
      this.completeDate,
      this.clientName,
      this.clientPhone,
      this.paymentMethod,
      this.status = 1});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['RestaurantID'] = restaurantID;
    data['OrderDate'] = orderDate;
    data['TotalAmount'] = totalAmount;
    data['DeliveryAddress'] = deliveryAddress;
    data['PaymentMethod'] = paymentMethod;
    data['ClientName'] = clientName;
    data['ClientPhone'] = clientPhone;
    data['CompleteDate'] = completeDate;
    data['Status'] = status;
    return data;
  }

  static OrderModel empty() => OrderModel(
        orderID: "",
        userID: "",
        restaurantID: "",
        orderDate: "",
        totalAmount: "0",
        deliveryAddress: "",
        completeDate: "",
        clientName: "",
        clientPhone: "",
        paymentMethod: "",
        status: 1,
      );

  factory OrderModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return OrderModel(
        orderID: document.id,
        userID: data['UserID'] ?? '',
        restaurantID: data['RestaurantID'] ?? '',
        orderDate: data['OrderDate'] ?? '',
        totalAmount: data['TotalAmount'] ?? 0,
        deliveryAddress: data['DeliveryAddress'] ?? '',
        completeDate: data['CompleteDate'] ?? '',
        clientName: data['ClientName'] ?? '',
        clientPhone: data['ClientPhone'] ?? '',
        paymentMethod: data['PaymentMethod'] ?? '',
        status: data['Status'] ?? '',
      );
    } else {
      return OrderModel.empty();
    }
  }
  DateTime get orderDateTime => DateTime.parse(orderDate ?? "");
}
