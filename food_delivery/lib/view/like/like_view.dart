import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/restaurant_details.dart';
import 'package:food_delivery/controller/category_controller.dart';
import 'package:food_delivery/controller/like_controller.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:food_delivery/controller/review_controller.dart';
import 'package:get/get.dart';

class LikeView extends StatefulWidget {
  const LikeView({super.key});

  @override
  State<LikeView> createState() => _LikeViewState();
}

class _LikeViewState extends State<LikeView> {
  final likeController = Get.put(LikeController());
  final restaurantController = Get.put(RestaurantController());
  final categoryController = Get.put(CategoryController());
  final reviewController = Get.put(ReviewController());
  @override
  void initState() {
    super.initState();
    likeController.getLikeResByUserId().then((_) {
      // Get restaurant IDs and load restaurant details
      final restaurantIds = likeController.allLikesRes
          .map((like) => like.restaurantId)
          .where((id) => id != null)
          .cast<String>()
          .toList();

      restaurantController.loadRestaurants(restaurantIds);
      _loadRestaurantsByCategory();
    });
  }

  Future<void> _loadRestaurantsByCategory() async {
    for (var restaurantByCategory in restaurantController.allResByCategoryId) {
      await reviewController
          .calculateReviewStats(restaurantByCategory.restaurantID);
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 46,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Yêu thích",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(() {
                    if (likeController.allLikesRes.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 150),
                          child: Text('Không có dữ liệu.'),
                        ),
                      );
                    }

                    return GetBuilder<RestaurantController>(
                      builder: (restaurantController) {
                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: likeController.allLikesRes.length,
                          separatorBuilder: (context, index) => Divider(
                            indent: 25,
                            endIndent: 25,
                            color: TColor.secondaryText.withOpacity(0.4),
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            var list = likeController.allLikesRes[index];
                            var restaurantId = list.restaurantId ?? "";
                            var restaurant =
                                restaurantController.restaurants[restaurantId];
                            double rating =
                                reviewController.averageRating[restaurantId] ??
                                    0.0;
                            int totalReviews =
                                reviewController.totalReviews[restaurantId] ??
                                    0;
                            if (restaurant == null) {
                              return const SizedBox.shrink();
                            }
                            restaurantController.categoryName.value =
                                categoryController.getCategoryNameById(
                                    restaurant.idCategory ?? "");
                            return Container(
                              decoration: BoxDecoration(color: TColor.white),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              child: RestaurantDetails(
                                rating: rating,
                                totalReviews: totalReviews,
                                listItem: restaurant,
                                restaurantController: restaurantController,
                                isLike: true,
                              ),
                            );
                          },
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          Obx(() {
            return restaurantController.isLoading.value ||
                    likeController.isLoading.value
                ? Positioned(
                    child: Container(
                      color: Colors.black12,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          })
        ],
      ),
    );
  }
}
