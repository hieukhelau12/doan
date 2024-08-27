import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/controller/category_controller.dart';
import 'package:food_delivery/view/csdl/edit_category_view.dart';
import 'package:get/get.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final controller = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    controller.txtSearch.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 60),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RoundTextField(
                    controller: controller.txtSearch,
                    hintText: "Tìm kiếm danh mục",
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
                    itemCount: controller.filteredCategories.length,
                    separatorBuilder: ((context, index) => Divider(
                          indent: 25,
                          endIndent: 25,
                          color: TColor.secondaryText.withOpacity(0.4),
                          height: 1,
                        )),
                    itemBuilder: ((context, index) {
                      var list = controller.filteredCategories[index];
                      return Container(
                        decoration: BoxDecoration(color: TColor.white),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Column(
                                children: [
                                  if (list.imageUrl.isNotEmpty)
                                    CachedNetworkImage(
                                      height: 90,
                                      width: 90,
                                      imageUrl: list.imageUrl,
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                ],
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
                                    list.categoryName,
                                    style: TextStyle(
                                        color: TColor.primaryText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Get.to(() => EditCategoryView(
                                          categoryId: list.itemCategoryID ?? "",
                                        ));
                                  },
                                  icon: Icon(
                                    Icons.edit_square,
                                    color: TColor.secondaryText,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.onDeletePressed(
                                        context, list.itemCategoryID ?? "");
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: TColor.secondaryText,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }),
                  );
                })
              ],
            ),
          ),
        ),
        Obx(() {
          return controller.isLoading.value
              ? Positioned(
                  child: Container(
                    color: Colors.black12,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  ),
                )
              : const SizedBox.shrink();
        })
      ],
    );
  }
}
