import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/models/order_model.dart';
import 'package:get/get.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<OrderModel>> getAllOrders() async {
    try {
      final snapshot = await _db.collection("Orders").get();
      final list = snapshot.docs
          .map((document) => OrderModel.fromSnapshot(document))
          .toList();

      return list;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      throw "Lỗi";
    }
  }

  Future<List<OrderModel>> getOrderByUserId(String userId) async {
    try {
      final querySnapshot = await _db
          .collection("Orders")
          .where('UserID', isEqualTo: userId)
          .get();

      final orders = querySnapshot.docs.map((doc) {
        return OrderModel.fromSnapshot(doc);
      }).toList();

      return orders;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      throw "Lỗi";
    }
  }

  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final doc = await _db.collection("Orders").doc(orderId).get();
      if (doc.exists) {
        final restaurant = OrderModel.fromSnapshot(doc);
        return restaurant;
      } else {
        return OrderModel.empty();
      }
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      throw "Lỗi";
    }
  }

  Future<List<OrderModel>> getOrdersByUserIdAndStatus(
      String userId, int status) async {
    try {
      // Query Firestore to get orders for the user with the specific status
      final querySnapshot = await _db
          .collection('Orders')
          .where('UserID', isEqualTo: userId)
          .where('Status', isEqualTo: status)
          .get();

      // Convert the query result to a list of OrderModel objects
      List<OrderModel> orders = querySnapshot.docs.map((doc) {
        return OrderModel.fromSnapshot(doc);
      }).toList();

      return orders;
    } catch (e) {
      print("Error getting orders: $e");
      return [];
    }
  }

  // Future<AddressModel> getAddressById(String addressId) async {
  //   try {
  //     final documentSnapshot =
  //         await _db.collection("Addresses").doc(addressId).get();

  //     if (documentSnapshot.exists) {
  //       // Chuyển đổi documentSnapshot thành AddressModel
  //       return AddressModel.fromSnapshot(documentSnapshot);
  //     } else {
  //       throw Exception("Địa chỉ không tồn tại.");
  //     }
  //   } catch (e) {
  //     Get.snackbar('Lỗi', e.toString());
  //     throw "Lỗi: ${e.toString()}";
  //   }
  // }

  Future<void> addOrderRecord(OrderModel order) async {
    try {
      await _db.collection("Orders").doc(order.orderID).set(order.toJson());
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> updateOrderField(
      Map<String, dynamic> json, String orderId) async {
    try {
      await _db.collection("Orders").doc(orderId).update(json);
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  // Future<void> updateAddressField(
  //     Map<String, dynamic> json, String addressId) async {
  //   try {
  //     await _db.collection("Addresses").doc(addressId).update(json);
  //   } catch (e) {
  //     Get.snackbar("Thông báo", "Lỗi $e");
  //   }
  // }

  Future<void> removeOrder(String orderId) async {
    try {
      await _db.collection("Orders").doc(orderId).delete();
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }
}
