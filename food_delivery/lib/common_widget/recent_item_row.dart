import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/time_utils.dart';
import 'package:food_delivery/models/restaurant_model.dart';
import 'package:get/get.dart';

class RecentItemRow extends StatelessWidget {
  final RestaurantModel rObj;
  final VoidCallback onTap;
  final double rating;
  final int totalReviews;
  const RecentItemRow(
      {super.key,
      required this.rObj,
      required this.onTap,
      this.rating = 0,
      this.totalReviews = 0});

  @override
  Widget build(BuildContext context) {
    final openStatus = getOpenStatus(rObj.openingTime, rObj.closingTime);
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  height: 70,
                  width: 70,
                  imageUrl: rObj.imageUrl,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    rObj.restaurantName.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        rObj.address.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                        "$rating",
                        style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "($totalReviews đánh giá)  |  ",
                        style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 12,
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
