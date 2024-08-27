import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/tab_button.dart';
import 'package:food_delivery/view/csdl/add_category_view.dart';
import 'package:food_delivery/view/csdl/add_item_view.dart';
import 'package:food_delivery/view/csdl/add_restaurant_view.dart';
import 'package:food_delivery/view/csdl/all_order_view.dart';
import 'package:food_delivery/view/csdl/category_view.dart';
import 'package:food_delivery/view/csdl/item_view.dart';
import 'package:food_delivery/view/csdl/restaurant_view.dart';
import 'package:get/get.dart';

class DatabaseView extends StatefulWidget {
  const DatabaseView({super.key});

  @override
  State<DatabaseView> createState() => _DatabaseViewState();
}

class _DatabaseViewState extends State<DatabaseView>
    with SingleTickerProviderStateMixin {
  int selectTab = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpen = false;
  PageStorageBucket storageBucket = PageStorageBucket();
  Widget selectPageView = const RestaurantView();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  void _toggle() {
    setState(() {
      if (_isOpen) {
        _controller.reverse().then((_) {
          setState(() {
            _isOpen =
                false; // Đặt trạng thái _isOpen sau khi animation hoàn tất
          });
        });
      } else {
        setState(() {
          _isOpen = true; // Đặt trạng thái _isOpen trước khi bắt đầu animation
        });
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 2),
              end: const Offset(0, 0),
            ).animate(_animation),
            child: FadeTransition(
              opacity: _animation,
              child: _isOpen
                  ? Container(
                      width: 120,
                      height: 60,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: FloatingActionButton(
                        onPressed: () {
                          if (_isOpen) {
                            _toggle(); // Close the menu if open
                          }
                          Get.to(() => const AddItemView());
                        },
                        heroTag: 'btn3',
                        backgroundColor: TColor.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: TColor.primary, // Màu viền
                            width: 2, // Độ dày của viền
                          ),
                          borderRadius:
                              BorderRadius.circular(20), // Góc bo tròn của viền
                        ),
                        child: Text(
                          "Món ăn",
                          style: TextStyle(
                              color: TColor.primaryText, fontSize: 15),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1.5),
              end: const Offset(0, 0),
            ).animate(_animation),
            child: FadeTransition(
              opacity: _animation,
              child: _isOpen
                  ? Container(
                      width: 120,
                      height: 60,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: FloatingActionButton(
                        onPressed: () {
                          if (_isOpen) {
                            _toggle(); // Close the menu if open
                          }
                          Get.to(() => const AddCategoryView());
                        },
                        heroTag: 'btn2',
                        backgroundColor: TColor.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: TColor.primary, // Màu viền
                            width: 2, // Độ dày của viền
                          ),
                          borderRadius:
                              BorderRadius.circular(20), // Góc bo tròn của viền
                        ),
                        child: Text(
                          "Danh mục",
                          style: TextStyle(
                              color: TColor.primaryText, fontSize: 15),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: const Offset(0, 0),
            ).animate(_animation),
            child: FadeTransition(
              opacity: _animation,
              child: _isOpen
                  ? Container(
                      width: 120,
                      height: 60,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: FloatingActionButton(
                        onPressed: () {
                          if (_isOpen) {
                            _toggle(); // Close the menu if open
                          }
                          Get.to(() => const AddRestaurantView());
                        },
                        heroTag: 'btn1',
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: TColor.primary, // Màu viền
                            width: 2, // Độ dày của viền
                          ),
                          borderRadius:
                              BorderRadius.circular(20), // Góc bo tròn của viền
                        ),
                        backgroundColor: TColor.white,
                        child: Text(
                          "Quán ăn",
                          style: TextStyle(
                              color: TColor.primaryText, fontSize: 15),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: FloatingActionButton(
              onPressed: _toggle,
              backgroundColor: TColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Góc bo tròn của viền
              ),
              elevation: 0,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

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
          "CSDL",
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: PageStorage(
        bucket: storageBucket,
        child: selectPageView,
      ),
      // backgroundColor: const Color(0xfff5f5f5),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: TColor.white,
        shadowColor: Colors.black,
        elevation: 1,
        notchMargin: 12,
        height: 64,
        shape: const CircularNotchedRectangle(),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                  onTap: () {
                    if (_isOpen) {
                      _toggle(); // Close the menu if open
                    }
                    if (selectTab != 0) {
                      selectTab = 0;
                      selectPageView = const RestaurantView();
                    } else {}
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  title: "Quán Ăn",
                  icon: "assets/images/tab_menu.png",
                  isSelected: selectTab == 0),
              TabButton(
                  onTap: () {
                    if (_isOpen) {
                      _toggle(); // Close the menu if open
                    }
                    if (selectTab != 1) {
                      selectTab = 1;
                      selectPageView = const CategoryView();
                    } else {}
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  title: "Danh Mục",
                  icon: "assets/images/tab_more.png",
                  isSelected: selectTab == 1),
              TabButton(
                  onTap: () {
                    if (_isOpen) {
                      _toggle(); // Close the menu if open
                    }
                    if (selectTab != 3) {
                      selectTab = 3;
                      selectPageView = const ItemView();
                    } else {}
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  title: "Món Ăn",
                  icon: "assets/images/tab_profile.png",
                  isSelected: selectTab == 3),
              TabButton(
                  onTap: () {
                    if (_isOpen) {
                      _toggle(); // Close the menu if open
                    }
                    if (selectTab != 4) {
                      selectTab = 4;
                      selectPageView = const AllOrderView();
                    } else {}
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  title: "Đơn Hàng",
                  icon: "assets/images/tab_offer.png",
                  isSelected: selectTab == 4)
            ],
          ),
        ),
      ),
    );
  }
}
