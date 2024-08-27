import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_delivery/models/restaurant_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantRepository extends GetxController {
  static RestaurantRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<RestaurantModel>> getAllRestaurants() async {
    try {
      final snapshot = await _db.collection("Restaurants").get();
      final list = snapshot.docs
          .map((document) => RestaurantModel.fromSnapshot(document))
          .toList();

      return list;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      throw "Lỗi";
    }
  }

  Future<RestaurantModel> getRestaurantById(String restaurantId) async {
    try {
      final doc = await _db.collection("Restaurants").doc(restaurantId).get();
      if (doc.exists) {
        final restaurant = RestaurantModel.fromSnapshot(doc);
        return restaurant;
      } else {
        return RestaurantModel.empty();
      }
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      throw "Lỗi";
    }
  }
  // Future<RestaurantModel> getRestaurantById(String restaurantId) async {
  //   try {
  //     final doc = await _db.collection("Restaurants").doc(restaurantId).get();
  //     if (doc.exists) {
  //       return RestaurantModel.fromSnapshot(doc);
  //     } else {
  //       return RestaurantModel.empty();
  //     }
  //   } catch (e) {
  //     Get.snackbar('Lỗi', e.toString());
  //     throw "Lỗi";
  //   }
  // }

  Future<List<RestaurantModel>> getResByCategoryId(String categoryId) async {
    try {
      // Giả sử bạn sử dụng Firestore
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Restaurants')
          .where('ItemCategoryID', isEqualTo: categoryId)
          .get();

      return querySnapshot.docs
          .map((doc) => RestaurantModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Error getting items by category ID: $e');
    }
  }

  Future<void> addRestaurantRecord(RestaurantModel restaurant) async {
    try {
      await _db
          .collection("Restaurants")
          .doc(restaurant.restaurantID)
          .set(restaurant.toJson());
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> updateRestaurantField(
      Map<String, dynamic> json, String restaurantId) async {
    try {
      await _db.collection("Restaurants").doc(restaurantId).update(json);
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

  Future<void> removeRestaurant(String restaurantId) async {
    try {
      await _db.collection("Restaurants").doc(restaurantId).delete();
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }
}
