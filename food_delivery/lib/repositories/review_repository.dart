import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_delivery/models/review_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ReviewRepository extends GetxController {
  static ReviewRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<ReviewModel>> getAllReviews() async {
    try {
      final snapshot = await _db.collection("Reviews").get();
      final list = snapshot.docs
          .map((document) => ReviewModel.fromSnapshot(document))
          .toList();

      return list;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      throw "Lỗi";
    }
  }

  Future<List<ReviewModel>> getReviewsByUserId(String userId) async {
    try {
      final querySnapshot = await _db
          .collection("Reviews")
          .where('UserId', isEqualTo: userId)
          .get();

      final reviews = querySnapshot.docs.map((doc) {
        return ReviewModel.fromSnapshot(doc);
      }).toList();

      return reviews;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      throw "Lỗi";
    }
  }

  Future<List<ReviewModel>> getReviewsByResId(String restaurantId) async {
    try {
      final querySnapshot = await _db
          .collection("Reviews")
          .where('RestaurantID', isEqualTo: restaurantId)
          .get();

      final reviews = querySnapshot.docs.map((doc) {
        return ReviewModel.fromSnapshot(doc);
      }).toList();

      return reviews;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      throw "Lỗi";
    }
  }

  Future<void> addReviewRecord(ReviewModel review) async {
    try {
      await _db.collection("Reviews").doc(review.reviewID).set(review.toJson());
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

  Future<bool> isReviewed(String orderId) async {
    try {
      // Truy vấn để tìm đánh giá với orderId
      final querySnapshot = await _db
          .collection('Reviews')
          .where('OrderID', isEqualTo: orderId)
          .get();

      // Nếu có ít nhất 1 kết quả, có nghĩa là đã có đánh giá cho đơn hàng này
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking review: $e");
      return false;
    }
  }

  Future<bool> checkIfOrderReviewed(String orderId) async {
    try {
      final querySnapshot = await _db
          .collection('Reviews')
          .where('OrderID', isEqualTo: orderId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking if order is reviewed: $e");
      return false;
    }
  }

  Future<Map<String, bool>> checkOrdersReviewed(List<String> orderIds) async {
    final results = <String, bool>{};

    try {
      for (var orderId in orderIds) {
        final querySnapshot = await _db
            .collection('Reviews')
            .where('OrderID', isEqualTo: orderId)
            .limit(1)
            .get();

        results[orderId] = querySnapshot.docs.isNotEmpty;
      }
    } catch (e) {
      print("Error checking reviews: $e");
      for (var orderId in orderIds) {
        results[orderId] = false;
      }
    }

    return results;
  }
  // Future<void> deleteImage(String imageUrl) async {
  //   try {
  //     var fileRef = FirebaseStorage.instance.refFromURL(imageUrl);
  //     await fileRef.delete();
  //   } catch (e) {
  //     throw Exception('Error deleting image: $e');
  //   }
  // }

  // Future<void> removeRestaurant(String restaurantId) async {
  //   try {
  //     await _db.collection("Restaurants").doc(restaurantId).delete();
  //   } catch (e) {
  //     Get.snackbar("Thông báo", "Lỗi $e");
  //   }
  // }
}
