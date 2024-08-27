import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_delivery/models/item_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ItemRepository extends GetxController {
  static ItemRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<ItemModel>> getAllItems() async {
    try {
      final snapshot = await _db.collection("Items").get();
      final list = snapshot.docs
          .map((document) => ItemModel.fromSnapshot(document))
          .toList();

      return list;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      throw "Lỗi";
    }
  }

  Future<ItemModel?> getItemById(String itemId) async {
    try {
      final doc = await _db.collection("Items").doc(itemId).get();
      if (doc.exists) {
        return ItemModel.fromSnapshot(doc);
      } else {
        Get.snackbar('Lỗi', 'Món ăn không tồn tại');
        return null;
      }
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      throw "Lỗi";
    }
  }

  Future<List<ItemModel>> getItemsByIds(List<String> itemIds) async {
    List<ItemModel> items = [];

    try {
      for (String itemId in itemIds) {
        // Truy vấn đơn lẻ theo từng itemId
        DocumentSnapshot<Map<String, dynamic>> doc =
            await _db.collection('Items').doc(itemId).get();

        if (doc.exists) {
          // Sử dụng phương thức fromSnapshot để chuyển đổi dữ liệu
          items.add(ItemModel.fromSnapshot(doc));
        }
      }
    } catch (e) {
      print("Error getting items by IDs: $e");
    }

    return items;
  }

  Future<List<ItemModel>> getItemsByCategoryId(String categoryId) async {
    try {
      // Giả sử bạn sử dụng Firestore
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Items')
          .where('ItemCategoryID', isEqualTo: categoryId)
          .get();

      return querySnapshot.docs
          .map((doc) => ItemModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Error getting items by category ID: $e');
    }
  }

  Future<List<ItemModel>> getItemsByRestaurantId(String restaurantId) async {
    try {
      // Giả sử bạn sử dụng Firestore
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Items')
          .where('RestaurantID', isEqualTo: restaurantId)
          .get();

      return querySnapshot.docs
          .map((doc) => ItemModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Error getting items by category ID: $e');
    }
  }

  Future<void> addItemRecord(ItemModel item) async {
    try {
      await _db.collection("Items").doc(item.itemID).set(item.toJson());
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> updateItemField(Map<String, dynamic> json, String itemId) async {
    try {
      await _db.collection("Items").doc(itemId).update(json);
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref(path)
          .child(DateTime.now().toIso8601String());
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
    return "";
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      var fileRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await fileRef.delete();
    } catch (e) {
      throw Exception('Error deleting image: $e');
    }
  }

  Future<void> removeItem(String itemId) async {
    try {
      await _db.collection("Items").doc(itemId).delete();
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }
}
