import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/controller/review_controller.dart';
import 'package:get/get.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class ReviewDialog extends StatefulWidget {
  const ReviewDialog(
      {super.key, required this.orderId, required this.restaurantId});

  final String orderId;
  final String restaurantId;
  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final reviewController = Get.put(ReviewController());

  @override
  void initState() {
    super.initState();
    reviewController.selectedImage.value = "";
    reviewController.rating.value = 0;
    reviewController.txtReview.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Đánh giá của bạn"),
      content: Obx(() {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Chọn số sao
              SmoothStarRating(
                rating: reviewController.rating.value,
                size: 35,
                filledIconData: Icons.star,
                halfFilledIconData: Icons.star_half,
                defaultIconData: Icons.star_border,
                starCount: 5,
                allowHalfRating: false,
                spacing: 2.0,
                onRatingChanged: (value) {
                  reviewController.rating.value = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // Viết đánh giá
              SizedBox(
                height: 50,
                child: TextField(
                  controller: reviewController.txtReview,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Viết đánh giá",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Thêm ảnh
              reviewController.selectedImage.value.isNotEmpty
                  ? Image.file(
                      File(reviewController.selectedImage.value),
                      height: 230,
                      width: 230,
                      fit: BoxFit.cover,
                    )
                  : const Center(
                      child: Text(
                          "Vui lòng thêm ảnh cho quán bằng nút phía dưới !!!")),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: reviewController.pickImage,
                child: const Text("Chọn ảnh"),
              ),
            ],
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Hủy"),
        ),
        InkWell(
          onTap: () {
            reviewController.addReview(
                context, widget.restaurantId, widget.orderId);
          },
          child: Container(
            width: 140,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: TColor.primary,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Text(
              "Gửi đánh giá",
              style: TextStyle(
                  color: TColor.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        )
      ],
    );
  }
}
