import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/models/like_model.dart';
import 'package:get/get.dart';

class LikeRepository extends GetxController {
  static LikeRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  Future<void> addLikeRecord(LikeModel like) async {
    try {
      await _db.collection("Likes").doc(like.likeId).set(like.toJson());
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> removeLike(String userId, String restaurantId) async {
    try {
      final querySnapshot = await _db
          .collection('Likes')
          .where('UserId', isEqualTo: userId)
          .where('RestaurantId', isEqualTo: restaurantId)
          .get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<bool> isLikingRestaurant(String userId, String restaurantId) async {
    try {
      // Truy vấn để kiểm tra sự tồn tại của document
      final querySnapshot = await _db
          .collection('Likes')
          .where('UserId', isEqualTo: userId)
          .where('RestaurantId', isEqualTo: restaurantId)
          .get();

      // Nếu có ít nhất một document tồn tại, trả về true
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Xử lý lỗi (tuỳ chọn)
      print('Lỗi khi kiểm tra theo dõi nhà hàng: $e');
      return false;
    }
  }

  Future<List<LikeModel>> getLikedRestaurants(String userId) async {
    try {
      final querySnapshot = await _db
          .collection('Likes')
          .where('UserId', isEqualTo: userId)
          .get();

      final likes = querySnapshot.docs.map((doc) {
        return LikeModel.fromSnapshot(doc);
      }).toList();

      return likes;
    } catch (e) {
      throw Exception("Lỗi khi lấy danh sách nhà hàng đã theo dõi: $e");
    }
  }
}
