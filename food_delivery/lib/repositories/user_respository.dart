import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_delivery/repositories/authentication_repository.dart';
import 'package:food_delivery/models/user_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserRespository extends GetxController {
  static UserRespository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<UserModel?> fetchUserRecord() async {
    try {
      final documetnSnapshot = await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();
      if (documetnSnapshot.exists) {
        return UserModel.fromSnapshot(documetnSnapshot);
      } else {
        return UserModel.empty();
      }
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
    return null;
  }

  Future<void> updateUser(UserModel updateUser) async {
    try {
      await _db
          .collection("Users")
          .doc(updateUser.id)
          .update(updateUser.toJson());
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<UserModel> getUserById(String userId) async {
    try {
      final documetnSnapshot = await _db.collection("Users").doc(userId).get();
      if (documetnSnapshot.exists) {
        return UserModel.fromSnapshot(documetnSnapshot);
      }
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
    return UserModel.empty();
  }

  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update(json);
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
    return "";
  }
}
