import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common_widget/time_utils.dart';
import 'package:food_delivery/models/restaurant_model.dart';
import 'package:get/get.dart';

import '../common/color_extension.dart';

class PopularRestaurantRow extends StatelessWidget {
  final RestaurantModel pObj;
  final VoidCallback onTap;
  final bool isNetworkImage;
  final double rating;
  final int totalReviews;
  final String categoryName;
  const PopularRestaurantRow(
      {super.key,
      required this.pObj,
      required this.onTap,
      this.isNetworkImage = false,
      this.rating = 0.0,
      this.totalReviews = 0,
      this.categoryName = ""});

  @override
  Widget build(BuildContext context) {
    final openStatus = getOpenStatus(pObj.openingTime, pObj.closingTime);
    final statusText = openStatus['status'] as String;
    final statusColor = openStatus['color'] as Color;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: statusText == 'Đóng cửa'
            ? () {
                Get.snackbar(
                  'Thông báo',
                  'Nhà hàng đang đóng cửa. Bạn không thể đặt hàng tại thời điểm này.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            : onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              child: isNetworkImage
                  ? CachedNetworkImage(
                      height: 250,
                      width: double.infinity,
                      imageUrl: pObj.imageUrl,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => const Center(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
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
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pObj.restaurantName ?? "",
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(pObj.address ?? "",
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 13,
                      )),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/rate.png",
                        width: 10,
                        height: 10,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "$rating",
                        style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "($totalReviews đánh giá)  |  ",
                        style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "$categoryName  |  ",
                        style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        statusText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
