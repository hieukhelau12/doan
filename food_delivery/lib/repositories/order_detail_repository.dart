import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/models/ordel_detail_model.dart';
import 'package:get/get.dart';

class OrderDetailRepository extends GetxController {
  static OrderDetailRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // Future<List<AddressModel>> getAllCategories() async {
  //   try {
  //     final snapshot = await _db.collection("Addresses").get();
  //     final list = snapshot.docs
  //         .map((document) => AddressModel.fromSnapshot(document))
  //         .toList();

  //     return list;
  //   } catch (e) {
  //     Get.snackbar('Lỗi', e.toString());
  //     throw "Lỗi";
  //   }
  // }

  Future<List<OrderDetailModel>> getOrderDetails(String orderId) async {
    try {
      final querySnapshot = await _db
          .collection("OrderDetails")
          .where('OrderID', isEqualTo: orderId)
          .get();

      final orderDetails = querySnapshot.docs.map((doc) {
        return OrderDetailModel.fromSnapshot(doc);
      }).toList();

      return orderDetails;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      throw "Lỗi";
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

  Future<void> addOrderDetail(OrderDetailModel orderDetail) async {
    try {
      await _db
          .collection("OrderDetails")
          .doc(orderDetail.orderDetailID)
          .set(orderDetail.toJson());
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> updateOrderDetail(
      Map<String, dynamic> json, String orderDetailId) async {
    try {
      await _db.collection("OrderDetails").doc(orderDetailId).update(json);
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> removeAddress(String orderDetailId) async {
    try {
      await _db.collection("OrderDetails").doc(orderDetailId).delete();
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }
}
