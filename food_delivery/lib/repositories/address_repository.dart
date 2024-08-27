import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/models/address_model.dart';
import 'package:get/get.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

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

  Future<List<AddressModel>> getAddressByUserId(String userId) async {
    try {
      final querySnapshot = await _db
          .collection("Addresses")
          .where('UserId', isEqualTo: userId)
          .get();

      final addresses = querySnapshot.docs.map((doc) {
        return AddressModel.fromSnapshot(doc);
      }).toList();

      return addresses;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      throw "Lỗi";
    }
  }

  Future<AddressModel> getAddressById(String addressId) async {
    try {
      final documentSnapshot =
          await _db.collection("Addresses").doc(addressId).get();

      if (documentSnapshot.exists) {
        // Chuyển đổi documentSnapshot thành AddressModel
        return AddressModel.fromSnapshot(documentSnapshot);
      } else {
        throw Exception("Địa chỉ không tồn tại.");
      }
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      throw "Lỗi: ${e.toString()}";
    }
  }

  Future<AddressModel> getDefaultAddress(String userId) async {
    try {
      // Truy vấn để lấy địa chỉ mặc định
      final querySnapshot = await _db
          .collection('Addresses')
          .where('UserId', isEqualTo: userId)
          .where('IsDefault', isEqualTo: true)
          .limit(1) // Chỉ lấy một địa chỉ
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Lấy dữ liệu từ document đầu tiên và chuyển đổi thành AddressModel
        final doc = querySnapshot.docs.first;
        return AddressModel.fromSnapshot(doc);
      } else {
        return AddressModel.empty(); // Không có địa chỉ mặc định
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy địa chỉ mặc định: $e');
    }
  }

  Future<List<AddressModel>> getNoDefaultAddress(String userId) async {
    try {
      // Truy vấn để lấy địa chỉ mặc định
      final querySnapshot = await _db
          .collection('Addresses')
          .where('UserId', isEqualTo: userId)
          .where('IsDefault', isEqualTo: false)
          .get();
      final addresses = querySnapshot.docs.map((doc) {
        return AddressModel.fromSnapshot(doc);
      }).toList();

      return addresses;
    } catch (e) {
      throw Exception('Lỗi khi lấy địa chỉ mặc định: $e');
    }
  }

  Future<void> addAddressRecord(AddressModel address) async {
    try {
      await _db
          .collection("Addresses")
          .doc(address.addressId)
          .set(address.toJson());
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> updateAddressField(
      Map<String, dynamic> json, String addressId) async {
    try {
      await _db.collection("Addresses").doc(addressId).update(json);
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> removeAddress(String addressId) async {
    try {
      await _db.collection("Addresses").doc(addressId).delete();
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }
}
