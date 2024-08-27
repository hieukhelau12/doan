import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/currency_formatter.dart';
import 'package:food_delivery/common_widget/tab_button.dart';
import 'package:food_delivery/controller/item_controller.dart';
import 'package:food_delivery/controller/notification_controller.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:food_delivery/view/home/home_view.dart';
import 'package:food_delivery/view/like/like_view.dart';
import 'package:food_delivery/view/menu/restaurant_details_view.dart';
import 'package:food_delivery/view/more/more_view.dart';
import 'package:food_delivery/view/order/my_order_view.dart';
import 'package:get/get.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key, this.index = 0});
  final int index;

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectTab = 0;
  PageStorageBucket storageBucket = PageStorageBucket();
  Widget selectPageView = const HomeView();
  final notificationController = Get.put(PushNotifications());
  @override
  void initState() {
    super.initState();
    setState(() {
      selectTab = widget.index;
      if (selectTab == 1) {
        selectPageView = const MyOrderView();
      }
    });
    notificationController.getDeviceToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageStorage(
            bucket: storageBucket,
            child: selectPageView,
          ),
          GetBuilder<ItemController>(
            builder: (controller) {
              return GetBuilder<RestaurantController>(
                  builder: (restaurantController) {
                if (controller.getTotalQuantity() > 0) {
                  return Positioned(
                      bottom: 10,
                      left: 20,
                      right: 20,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => RestaurantDetailsView(
                                  restaurant: controller.restaurant.value));
                            },
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: TColor.white,
                                borderRadius: BorderRadius.circular(12.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.2), // Màu sắc của bóng
                                    spreadRadius: 2, // Độ lan tỏa của bóng
                                    blurRadius: 5, // Độ mờ của bóng
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: TColor.primary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Image.asset(
                                        "assets/images/history.png"),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.restaurant.value
                                                  .restaurantName ??
                                              "",
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: TColor.primaryText,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "${controller.getTotalQuantity().toString()} món - ${formatCurrency(controller.total.value)}",
                                          style: TextStyle(
                                              color: TColor.primaryText,
                                              fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              right: -10,
                              top: -10,
                              child: InkWell(
                                onTap: () {
                                  controller.clearAllQuantities();
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: TColor.textfield,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: TColor.primaryText,
                                    size: 20,
                                  ),
                                ),
                              ))
                        ],
                      ));
                } else {
                  return const SizedBox.shrink();
                }
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: TColor.white,
        shadowColor: Colors.black,
        elevation: 1,
        height: 60,
        child: SafeArea(
          child: Row(
            children: [
              TabButton(
                  onTap: () {
                    if (selectTab != 0) {
                      selectTab = 0;
                      selectPageView = const HomeView();
                      setState(() {});
                    } else {}
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  title: "Trang chủ",
                  icon: "assets/images/tab_home.png",
                  isSelected: selectTab == 0),
              const SizedBox(
                width: 50,
              ),
              TabButton(
                  onTap: () {
                    if (selectTab != 1) {
                      selectTab = 1;
                      selectPageView = const MyOrderView();
                    } else {}
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  title: "Đơn hàng",
                  icon: "assets/images/tab_offer.png",
                  isSelected: selectTab == 1),
              const SizedBox(
                width: 50,
              ),
              TabButton(
                  onTap: () {
                    if (selectTab != 2) {
                      selectTab = 2;
                      selectPageView = const LikeView();
                    } else {}
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  title: "Thích",
                  icon: "assets/images/heart.png",
                  isSelected: selectTab == 2),
              const Spacer(),
              TabButton(
                  onTap: () {
                    if (selectTab != 3) {
                      selectTab = 3;
                      selectPageView = const MoreView();
                    } else {}
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  title: "Khác",
                  icon: "assets/images/tab_more.png",
                  isSelected: selectTab == 4)
            ],
          ),
        ),
      ),
    );
  }
}
