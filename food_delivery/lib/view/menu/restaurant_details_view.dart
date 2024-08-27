import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_delivery/common_widget/bottom_bar.dart';
import 'package:food_delivery/common_widget/currency_formatter.dart';
import 'package:food_delivery/common_widget/custom_bottom_sheet.dart';
import 'package:food_delivery/controller/category_controller.dart';
import 'package:food_delivery/controller/item_controller.dart';
import 'package:food_delivery/controller/like_controller.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:food_delivery/models/restaurant_model.dart';
import 'package:food_delivery/view/review/review_view.dart';
import 'package:get/get.dart';

import '../../common/color_extension.dart';

class RestaurantDetailsView extends StatefulWidget {
  const RestaurantDetailsView(
      {super.key,
      required this.restaurant,
      this.rating = 0,
      this.totalReviews = 0});

  final RestaurantModel restaurant;
  final double rating;
  final int totalReviews;
  @override
  State<RestaurantDetailsView> createState() => _RestaurantDetailsViewState();
}

class _RestaurantDetailsViewState extends State<RestaurantDetailsView> {
  final itemController = Get.put(ItemController());
  final restaurantController = Get.put(RestaurantController());
  final categoryController = Get.put(CategoryController());
  final likeController = Get.put(LikeController());
  @override
  void initState() {
    super.initState();
    if (itemController.restaurant.value.restaurantID !=
        widget.restaurant.restaurantID) {
      itemController.allItemsByResId.clear();
      itemController.total.value = 0.0;
      itemController.getItemByRestaurantId(widget.restaurant.restaurantID);
      itemController.restaurant.value = widget.restaurant;
    }
    likeController.isFav.value = false;
    likeController.checkIfFollowing(widget.restaurant.restaurantID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:
              Image.asset("assets/images/btn_back.png", width: 20, height: 20),
        ),
      ),
      body: Obx(() {
        if (itemController.quantities.isEmpty) {
          itemController
              .initializeQuantities(itemController.allItemsByResId.length);
        }
        return Stack(
          children: [
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: CachedNetworkImage(
                      imageUrl: widget.restaurant.imageUrl,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text(
                            widget.restaurant.restaurantName ?? "",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                            softWrap: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Obx(() {
                        likeController
                            .checkIfFollowing(widget.restaurant.restaurantID);
                        return Container(
                          margin: const EdgeInsets.only(right: 4),
                          child: InkWell(
                            onTap: () {
                              likeController.isFav.value =
                                  !likeController.isFav.value;
                              if (likeController.isFav.value) {
                                likeController
                                    .addLike(widget.restaurant.restaurantID);
                              } else {
                                likeController.removeLikeRecord(
                                    widget.restaurant.restaurantID);
                              }
                            },
                            child: Image.asset(
                                likeController.isFav.value
                                    ? "assets/images/favorites_btn.png"
                                    : "assets/images/favorites_btn_2.png",
                                width: 60,
                                height: 60),
                          ),
                        );
                      })
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IgnorePointer(
                          ignoring: true,
                          child: RatingBar.builder(
                            initialRating: widget.rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: TColor.primary,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => ReviewView(
                                  restaurant: widget.restaurant,
                                ));
                          },
                          child: Text(
                            " (${widget.totalReviews} đánh giá)",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Divider(
                        color: TColor.secondaryText.withOpacity(0.4),
                        height: 1,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Menu",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: itemController.allItemsByResId.length,
                    separatorBuilder: ((context, index) => Divider(
                          indent: 25,
                          endIndent: 25,
                          color: TColor.secondaryText.withOpacity(0.4),
                          height: 1,
                        )),
                    itemBuilder: ((context, index) {
                      var listItem = itemController.allItemsByResId[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              height: 90,
                              width: 90,
                              imageUrl: listItem.imageUrl ?? "",
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
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    listItem.itemName ?? "",
                                    style: TextStyle(
                                        color: TColor.primaryText,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Giá: ${formatCurrency(double.tryParse(listItem.price ?? '0') ?? 0)}",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (itemController.quantities[index] > 0)
                                        InkWell(
                                          onTap: () {
                                            itemController.updateQuantities(
                                                index,
                                                itemController
                                                        .quantities[index] -
                                                    1);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            height: 25,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: TColor.primary,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12.5)),
                                            child: Text(
                                              "-",
                                              style: TextStyle(
                                                  color: TColor.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      if (itemController.quantities[index] > 0)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          height: 25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: TColor.primary,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.5)),
                                          child: Text(
                                            itemController.quantities[index]
                                                .toString(),
                                            style: TextStyle(
                                                color: TColor.primary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          itemController.updateQuantities(
                                              index,
                                              itemController.quantities[index] +
                                                  1);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          height: 25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: TColor.primary,
                                            borderRadius:
                                                BorderRadius.circular(12.5),
                                          ),
                                          child: Text(
                                            "+",
                                            style: TextStyle(
                                                color: TColor.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )),
            if (itemController.isOpen.value)
              GestureDetector(
                onTap: () {
                  if (itemController.isOpen.value) {
                    itemController.isOpen.value = !itemController.isOpen.value;
                  }
                },
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Màu xám mờ
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            if (itemController.isOpen.value)
              const Positioned(
                  left: 0, right: 0, bottom: 70, child: CustomBottomSheet()),
            if (itemController.getTotalQuantity() > 0)
              const Positioned(bottom: 0, left: 0, right: 0, child: BottomBar())
          ],
        );
      }),
    );
  }
}
