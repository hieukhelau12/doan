import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/restaurant_details.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/controller/category_controller.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:get/get.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final restaurantController = Get.put(RestaurantController());
  final categoryController = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    restaurantController.txtSearch.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tìm kiếm'),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoundTextField(
                  hintText: "Tìm kiếm nhà hàng",
                  controller: restaurantController.txtSearch,
                  autofocus: true,
                  left: Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: Image.asset(
                      "assets/images/search.png",
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              ),
              Obx(() {
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: restaurantController.filteredRestaurants.length,
                  separatorBuilder: ((context, index) => Divider(
                        indent: 25,
                        endIndent: 25,
                        color: TColor.secondaryText.withOpacity(0.4),
                        height: 1,
                      )),
                  itemBuilder: ((context, index) {
                    var list = restaurantController.filteredRestaurants[index];
                    return Container(
                      decoration: BoxDecoration(color: TColor.white),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: RestaurantDetails(
                          listItem: list,
                          restaurantController: restaurantController),
                    );
                  }),
                );
              }),
            ],
          ),
        ));
  }
}
