import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_delivery/models/category_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await _db.collection("ItemCategories").get();
      final list = snapshot.docs
          .map((document) => CategoryModel.fromSnapshot(document))
          .toList();

      return list;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      throw "Lỗi";
    }
  }

  Future<CategoryModel?> getCategoryById(String categoryId) async {
    try {
      final doc = await _db.collection("ItemCategories").doc(categoryId).get();
      if (doc.exists) {
        return CategoryModel.fromSnapshot(doc);
      } else {
        return null;
      }
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      throw "Lỗi";
    }
  }

  Future<void> addCategoryRecord(CategoryModel category) async {
    try {
      await _db
          .collection("ItemCategories")
          .doc(category.itemCategoryID)
          .set(category.toJson());
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> updateCategoryField(
      Map<String, dynamic> json, String categoryId) async {
    try {
      await _db.collection("ItemCategories").doc(categoryId).update(json);
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

  Future<void> removeCategory(String categoryId) async {
    try {
      await _db.collection("ItemCategories").doc(categoryId).delete();
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }
}
