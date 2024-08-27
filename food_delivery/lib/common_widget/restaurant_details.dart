import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/currency_formatter.dart';
import 'package:food_delivery/common_widget/time_utils.dart';
import 'package:food_delivery/controller/like_controller.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:food_delivery/models/restaurant_model.dart';
import 'package:food_delivery/view/menu/restaurant_details_view.dart';
import 'package:food_delivery/view/order/order_detail_view.dart';
import 'package:get/get.dart';

class RestaurantDetails extends StatelessWidget {
  const RestaurantDetails(
      {super.key,
      required this.listItem,
      required this.restaurantController,
      this.isLike = false,
      this.isOrder = false,
      this.quantity = 0,
      this.totalPrice = 0,
      this.orderId = "",
      this.status = "",
      this.rating = 0,
      this.totalReviews = 0});
  final RestaurantModel listItem;
  final RestaurantController restaurantController;
  final bool isLike;
  final bool isOrder;
  final int quantity;
  final double totalPrice;
  final double rating;
  final int totalReviews;
  final String orderId;
  final String status;

  @override
  Widget build(BuildContext context) {
    final openStatus =
        getOpenStatus(listItem.openingTime, listItem.closingTime);
    final statusText = openStatus['status'] as String;
    final statusColor = openStatus['color'] as Color;
    return InkWell(
      onTap: () {
        if (!isOrder) {
          if (statusText == 'Đóng cửa') {
            Get.snackbar(
              'Thông báo',
              'Nhà hàng đang đóng cửa. Bạn không thể đặt hàng tại thời điểm này.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } else {
            Get.to(() => RestaurantDetailsView(
                  restaurant: listItem,
                  rating: rating,
                  totalReviews: totalReviews,
                ));
          }
        } else {
          (Get.to(() => OrderDetailView(
                orderId: orderId,
                listItem: listItem,
              )));
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            height: 90,
            width: 90,
            imageUrl: listItem.imageUrl,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          if (!isOrder)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listItem.restaurantName ?? "",
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
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
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Địa chỉ: ${listItem.address}",
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          if (isOrder)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listItem.restaurantName ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${quantity.toString()} món - ${formatCurrency(totalPrice)}",
                    style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  Text(
                    status,
                    style: TextStyle(
                        color: TColor.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          if (isLike)
            GetBuilder<LikeController>(builder: (likeController) {
              likeController.checkIfFollowing(listItem.restaurantID);
              return InkWell(
                onTap: () {
                  likeController.removeLikeRecord(listItem.restaurantID);

                  likeController.checkIfFollowing(listItem.restaurantID);
                },
                child: Image.asset(
                    likeController.isFav.value
                        ? "assets/images/heart_1.png"
                        : "assets/images/heart_border.png",
                    width: 30,
                    height: 30),
              );
            })
        ],
      ),
    );
  }
}
