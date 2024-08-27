import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:food_delivery/models/category_model.dart';
import 'package:get/get.dart';

class CategoryCell extends StatelessWidget {
  final CategoryModel cObj;
  final VoidCallback onTap;
  final bool isNetworkImage;
  const CategoryCell(
      {super.key,
      required this.cObj,
      required this.onTap,
      this.isNetworkImage = false});

  @override
  Widget build(BuildContext context) {
    final restaurant = Get.put(RestaurantController());
    return Obx(() {
      return Container(
        width: 90,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: restaurant.selectedCategory.value == cObj.itemCategoryID
                ? TColor.primary
                : TColor.white,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: isNetworkImage
                    ? CachedNetworkImage(
                        height: 60,
                        width: 60,
                        imageUrl: cObj.imageUrl,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                const Center(
                                  child: CircularProgressIndicator(
                                                            color: Colors.black,
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
                height: 8,
              ),
              Flexible(
                child: Text(
                  cObj.categoryName.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
