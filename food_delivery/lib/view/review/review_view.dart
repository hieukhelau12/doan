import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/controller/review_controller.dart';
import 'package:food_delivery/models/restaurant_model.dart';
import 'package:food_delivery/models/review_model.dart';
import 'package:get/get.dart';

class ReviewView extends StatefulWidget {
  const ReviewView({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  final reviewController = Get.put(ReviewController());
  @override
  void initState() {
    super.initState();
    // Gọi phương thức để lấy các đánh giá
    reviewController.getReviewByResId(widget.restaurant.restaurantID);
  }

  DateTime getOrderDateTime(ReviewModel? review) {
    if (review != null && review.reviewDate != null) {
      return DateTime.parse(review.reviewDate!);
    } else {
      return DateTime.now();
    }
  }

  String formatDateTime(DateTime dateTime) {
    String formattedDay = dateTime.day.toString().padLeft(2, '0');
    String formattedMonth = dateTime.month.toString().padLeft(2, '0');
    String formattedHour = dateTime.hour.toString().padLeft(2, '0');
    String formattedMinute = dateTime.minute.toString().padLeft(2, '0');
    return "$formattedHour:$formattedMinute $formattedDay/$formattedMonth/${dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đánh giá"),
        centerTitle: true,
      ),
      body: Obx(() {
        // Xử lý danh sách đánh giá và tên người dùng
        if (reviewController.allReviewsByRes.isEmpty) {
          return const Center(child: Text('Chưa có đánh giá'));
        }

        return Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.separated(
            itemCount: reviewController.allReviewsByRes.length,
            separatorBuilder: (context, index) => Container(
              height: 10,
            ),
            itemBuilder: (context, index) {
              final review = reviewController.allReviewsByRes[index];
              final userName =
                  reviewController.userNamesMap[review.userID]?.name ?? '';
              final imageUrl = reviewController
                      .userNamesMap[review.userID]?.profilePicture ??
                  "";
              DateTime dateTime = getOrderDateTime(review);
              String reviewDate = formatDateTime(dateTime);
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: TColor.primary)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      child: imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 65,
                              color: TColor.secondaryText,
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userName),
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/rate.png",
                                height: 10,
                                width: 10,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                "${review.rating}",
                                style: TextStyle(
                                    color: TColor.secondaryText,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            review.reviewText ?? "",
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          if (review.imageUrl!.isNotEmpty)
                            CachedNetworkImage(
                              imageUrl: review.imageUrl ?? "",
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            reviewDate,
                            style: TextStyle(
                                color: TColor.secondaryText, fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
