import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/models/like_model.dart';
import 'package:food_delivery/repositories/authentication_repository.dart';
import 'package:food_delivery/repositories/like_repository.dart';
import 'package:get/get.dart';

class LikeController extends GetxController {
  static LikeController get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var allLikesRes = <LikeModel>[].obs;
  final _likeRepository = Get.put(LikeRepository());
  final _authRepository = Get.put(AuthenticationRepository());
  var isFav = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getLikeResByUserId();
  }

  Future<void> getLikeResByUserId() async {
    isLoading.value = true;
    final userId = _authRepository.authUser!.uid;
    if (userId.isNotEmpty) {
      try {
        List<LikeModel> likes =
            await _likeRepository.getLikedRestaurants(userId);
        allLikesRes.assignAll(likes);
        isLoading.value = false;
      } catch (e) {
        Get.snackbar('Lỗi', e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }

  void checkIfFollowing(String restaurantId) async {
    try {
      final userId = _authRepository.authUser!.uid;
      bool isFollowing =
          await _likeRepository.isLikingRestaurant(userId, restaurantId);
      if (isFollowing) {
        isFav.value = true;
      } else {
        isFav.value = false;
      }
      update();
    } catch (e) {
      print('Lỗi: $e');
    }
  }

  Future<void> addLike(String restaurantId) async {
    try {
      isLoading.value = true;
      final userId = _authRepository.authUser!.uid;

      final newAddress = LikeModel(
          likeId: _firestore.collection('Likes').doc().id,
          userId: userId,
          restaurantId: restaurantId);

      await _likeRepository.addLikeRecord(newAddress);

      await getLikeResByUserId();
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeLikeRecord(String restaurantId) async {
    try {
      isLoading.value = true;
      final userId = _authRepository.authUser!.uid;
      await _likeRepository.removeLike(userId, restaurantId);
      getLikeResByUserId();
      Get.snackbar("Thông báo", "Đã bỏ thích!");
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    } finally {
      isLoading.value = false;
    }
  }
}
