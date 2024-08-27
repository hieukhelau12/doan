import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/models/review_model.dart';
import 'package:food_delivery/models/user_model.dart';
import 'package:food_delivery/repositories/authentication_repository.dart';
import 'package:food_delivery/repositories/review_repository.dart';
import 'package:food_delivery/repositories/user_respository.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var allReviews = <ReviewModel>[].obs;
  var allReviewsByUser = <ReviewModel>[].obs;
  var allReviewsByRes = <ReviewModel>[].obs;
  final _reviewRepository = Get.put(ReviewRepository());
  final _userRepository = Get.put(UserRespository());
  final _authRepository = Get.put(AuthenticationRepository());
  final txtReview = TextEditingController();
  var reviewedOrders = <String, bool>{}.obs;
  var selectedImage = "".obs;
  var rating = 0.0.obs;
  var averageRating = <String, double>{}.obs;
  var totalReviews = <String, int>{}.obs;
  final isLoading = false.obs;
  final isReviewed = false.obs;
  final userNamesMap = <String, UserModel>{}.obs;
  @override
  void onInit() {
    super.onInit();
    getReviewByUserId();
  }

  Future<void> getAllReviews() async {
    try {
      List<ReviewModel> reviews = await _reviewRepository.getAllReviews();
      allReviews.assignAll(reviews);
      update();
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    }
  }

  Future<void> getReviewByUserId() async {
    final userId = _authRepository.authUser!.uid;
    print(userId);
    if (userId.isNotEmpty) {
      try {
        List<ReviewModel> reviews =
            await _reviewRepository.getReviewsByUserId(userId);
        allReviewsByUser.assignAll(reviews);
      } catch (e) {
        Get.snackbar('Lỗi', e.toString());
      }
    }
  }

  Future<void> getReviewByResId(String restaurantId) async {
    if (restaurantId.isNotEmpty) {
      try {
        List<ReviewModel> reviews =
            await _reviewRepository.getReviewsByResId(restaurantId);

        // Tạo một danh sách các tên người dùng tương ứng với danh sách đánh giá
        Map<String, UserModel> userNameMap = {};
        for (var review in reviews) {
          if (review.userID != null &&
              !userNameMap.containsKey(review.userID)) {
            var user = await _userRepository.getUserById(review.userID!);
            userNameMap[review.userID!] = user;
          }
        }

        // Lưu danh sách đánh giá và tên người dùng vào `allReviewsByRes`
        allReviewsByRes.assignAll(reviews);

        // Cập nhật danh sách người dùng tạm thời
        userNamesMap.assignAll(userNameMap);
      } catch (e) {
        Get.snackbar('Lỗi', e.toString());
      }
    }
  }

  Future<void> addReview(
      BuildContext context, String restaurantId, String orderId) async {
    try {
      isLoading.value = true;
      final userId = _authRepository.authUser!.uid;
      String imageUrl = "";
      if (selectedImage.isNotEmpty) {
        imageUrl = await _reviewRepository.uploadImage(
            "Reviews/", XFile(selectedImage.value));
      }
      final newReview = ReviewModel(
          reviewID: _firestore.collection('Reviews').doc().id,
          userID: userId,
          restaurantID: restaurantId,
          orderID: orderId,
          rating: rating.value.toInt(),
          reviewText: txtReview.text,
          reviewDate: DateTime.now().toIso8601String(),
          imageUrl: imageUrl);

      await _reviewRepository.addReviewRecord(newReview);

      await getAllReviews();
      Get.snackbar("Thông báo", "Đánh giá thành công!");
      Navigator.pop(context);

      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    } finally {
      isLoading.value = false;
    }
  }

  void pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );

      if (image != null) {
        selectedImage.value = image.path;
      }
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> loadReviewedOrders(List<String> orderIds) async {
    reviewedOrders.value =
        await _reviewRepository.checkOrdersReviewed(orderIds);
  }

  Future<void> calculateReviewStats(String restaurantId) async {
    try {
      final reviews = await _reviewRepository.getReviewsByResId(restaurantId);

      if (reviews.isEmpty) {
        averageRating[restaurantId] = 0.0;
        totalReviews[restaurantId] = 0;
      } else {
        double totalRating = 0.0;
        for (var review in reviews) {
          totalRating += review.rating!.toDouble();
        }
        double rawAverage = totalRating / reviews.length;
        averageRating[restaurantId] =
            double.parse(rawAverage.toStringAsFixed(1));
        totalReviews[restaurantId] = reviews.length;
      }
    } catch (e) {
      print('Error calculating review stats: $e');
    }
  }
}
