import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/popular_restaurant_row.dart';
import 'package:food_delivery/controller/category_controller.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:food_delivery/controller/review_controller.dart';
import 'package:get/get.dart';

class ViewAll extends StatefulWidget {
  final String title;
  const ViewAll({super.key, required this.title});

  @override
  State<ViewAll> createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  final reviewController = Get.put(ReviewController());
  final restaurantController = Get.put(RestaurantController());
  final categoryController = Get.put(CategoryController());
  @override
  void initState() {
    super.initState();

    _loadRestaurantRatings();
  }

  Future<void> _loadRestaurantRatings() async {
    for (var restaurant in restaurantController.allRestaurants) {
      await reviewController.calculateReviewStats(restaurant.restaurantID);
      if (mounted) {
        setState(() {});
      }
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   reviewController.dispose();
  //   restaurantController.dispose();
  //   categoryController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final restaurantController = Get.put(RestaurantController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:
              Image.asset("assets/images/btn_back.png", width: 20, height: 20),
        ),
        centerTitle: false,
        title: Text(
          widget.title,
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: restaurantController.allRestaurants.length,
            itemBuilder: ((context, index) {
              var pObj = restaurantController.allRestaurants[index];
              var categoryName =
                  categoryController.getCategoryNameById(pObj.idCategory ?? "");
              double rating =
                  reviewController.averageRating[pObj.restaurantID] ?? 0.0;
              int totalReviews =
                  reviewController.totalReviews[pObj.restaurantID] ?? 0;
              return PopularRestaurantRow(
                pObj: pObj,
                rating: rating,
                categoryName: categoryName,
                totalReviews: totalReviews,
                onTap: () {},
                isNetworkImage: restaurantController.allRestaurants.isNotEmpty,
              );
            }),
          );
        }),
      ),
    );
  }
}
