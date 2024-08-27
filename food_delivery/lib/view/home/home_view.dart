import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/category_cell.dart';
import 'package:food_delivery/common_widget/popular_restaurant_row.dart';
import 'package:food_delivery/common_widget/recent_item_row.dart';
import 'package:food_delivery/common_widget/restaurant_details.dart';
import 'package:food_delivery/common_widget/view_all.dart';
import 'package:food_delivery/common_widget/view_all_title_row.dart';
import 'package:food_delivery/controller/category_controller.dart';
import 'package:food_delivery/controller/item_controller.dart';
import 'package:food_delivery/controller/order_controller.dart';
import 'package:food_delivery/controller/profile_controller.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:food_delivery/controller/review_controller.dart';
import 'package:food_delivery/view/home/search_view.dart';
import 'package:food_delivery/view/menu/restaurant_details_view.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController txtSearch = TextEditingController();
  final controller = Get.put(ProfileController());
  final categoryController = Get.put(CategoryController());
  final restaurantController = Get.put(RestaurantController());
  final itemController = Get.put(ItemController());
  final orderController = Get.put(OrderController());
  final reviewController = Get.put(ReviewController());
  int itemCount = 0;
  int recentItemCount = 0;
  @override
  void initState() {
    super.initState();
    restaurantController.fetchRestaurants().then((_) {
      _loadRestaurantRatings();
    });
    orderController.getRecentOrderedRestaurants().then((_) {
      _loadRecentOrderedRestaurants();
    });
    _loadRestaurantsByCategory();
    restaurantController.selectedCategory.value = "";
    restaurantController.getResByCategoryId("");
  }

  Future<void> _loadRestaurantRatings() async {
    for (var restaurant in restaurantController.allRestaurants) {
      await reviewController.calculateReviewStats(restaurant.restaurantID);
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _loadRecentOrderedRestaurants() async {
    for (var recentRestaurant in orderController.recentRestaurants) {
      await reviewController
          .calculateReviewStats(recentRestaurant.restaurantID);
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _loadRestaurantsByCategory() async {
    for (int i = 0; i < restaurantController.allResByCategoryId.length; i++) {
      var restaurantByCategory = restaurantController.allResByCategoryId[i];
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Stack(
            children: [
              Obx(() {
                if (restaurantController.allRestaurants.length > 4) {
                  itemCount =
                      min(restaurantController.allRestaurants.length, 4);
                } else {
                  itemCount = restaurantController.allRestaurants.length;
                }
                if (orderController.recentRestaurants.length > 3) {
                  recentItemCount =
                      min(orderController.recentRestaurants.length, 3);
                } else {
                  recentItemCount = orderController.recentRestaurants.length;
                }
                return Column(
                  children: [
                    const SizedBox(
                      height: 46,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Chào buổi sáng!",
                                style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                controller.user.value.name,
                                style: TextStyle(
                                    color: TColor.primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                Get.to(() => const SearchView());
                              },
                              icon: const Icon(
                                Icons.search,
                                size: 30,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: categoryController.allCategories.length,
                        itemBuilder: ((context, index) {
                          var cObj = categoryController.allCategories[index];
                          return CategoryCell(
                            cObj: cObj,
                            isNetworkImage:
                                categoryController.allCategories.isNotEmpty,
                            onTap: () {
                              if (restaurantController.selectedCategory.value ==
                                  cObj.itemCategoryID) {
                                restaurantController.selectedCategory.value =
                                    "";
                                restaurantController.categoryName.value = "";
                                restaurantController.getResByCategoryId("");
                              } else {
                                restaurantController.selectedCategory.value =
                                    cObj.itemCategoryID ?? "";
                                restaurantController.categoryName.value =
                                    cObj.categoryName.toString();
                                restaurantController.getResByCategoryId(
                                    cObj.itemCategoryID ?? "");
                              }
                            },
                          );
                        }),
                      ),
                    ),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: restaurantController.allResByCategoryId.length,
                      separatorBuilder: ((context, index) => Divider(
                            indent: 25,
                            endIndent: 25,
                            color: TColor.secondaryText.withOpacity(0.4),
                            height: 1,
                          )),
                      itemBuilder: ((context, index) {
                        var listItem =
                            restaurantController.allResByCategoryId[index];
                        double rating = reviewController
                                .averageRating[listItem.restaurantID] ??
                            0.0;
                        int totalReviews = reviewController
                                .totalReviews[listItem.restaurantID] ??
                            0;
                        return Container(
                          decoration: BoxDecoration(color: TColor.white),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: RestaurantDetails(
                              rating: rating,
                              totalReviews: totalReviews,
                              listItem: listItem,
                              restaurantController: restaurantController),
                        );
                      }),
                    ),
                    if (restaurantController.allResByCategoryId.isEmpty)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ViewAllTitleRow(
                              title: "Những nhà hàng phổ biến",
                              onView: () {
                                Get.to(() => const ViewAll(
                                    title: "Tất cả các nhà hàng phổ biến"));
                              },
                            ),
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: itemCount,
                            itemBuilder: ((context, index) {
                              var pObj =
                                  restaurantController.allRestaurants[index];
                              var categoryName = categoryController
                                  .getCategoryNameById(pObj.idCategory ?? "");
                              double rating = reviewController
                                      .averageRating[pObj.restaurantID] ??
                                  0.0;
                              int totalReviews = reviewController
                                      .totalReviews[pObj.restaurantID] ??
                                  0;

                              return PopularRestaurantRow(
                                pObj: pObj,
                                rating: rating,
                                categoryName: categoryName,
                                totalReviews: totalReviews,
                                onTap: () {
                                  Get.to(() => RestaurantDetailsView(
                                        restaurant: pObj,
                                        rating: rating,
                                        totalReviews: totalReviews,
                                      ));
                                },
                                isNetworkImage: restaurantController
                                    .allRestaurants.isNotEmpty,
                              );
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ViewAllTitleRow(
                              isRecent: true,
                              title: "Những nhà hàng gần đây",
                              onView: () {},
                            ),
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            itemCount: recentItemCount,
                            itemBuilder: ((context, index) {
                              var rObj =
                                  orderController.recentRestaurants[index];
                              double rating = reviewController
                                      .averageRating[rObj.restaurantID] ??
                                  0.0;
                              int totalReviews = reviewController
                                      .totalReviews[rObj.restaurantID] ??
                                  0;
                              return RecentItemRow(
                                rating: rating,
                                totalReviews: totalReviews,
                                rObj: rObj,
                                onTap: () {
                                  Get.to(() => RestaurantDetailsView(
                                        restaurant: rObj,
                                        rating: rating,
                                        totalReviews: totalReviews,
                                      ));
                                },
                              );
                            }),
                          ),
                        ],
                      )
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
