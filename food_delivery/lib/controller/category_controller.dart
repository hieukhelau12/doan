import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common_widget/confirm_delete_dialog.dart';
import 'package:food_delivery/models/category_model.dart';
import 'package:food_delivery/models/item_model.dart';
import 'package:food_delivery/models/restaurant_model.dart';
import 'package:food_delivery/repositories/category_repository.dart';
import 'package:food_delivery/repositories/item_repository.dart';
import 'package:food_delivery/repositories/restaurant_repository.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _categoryRepository = Get.put(CategoryRepository());
  final _restaurantRepository = Get.put(RestaurantRepository());
  final _itemRepository = Get.put(ItemRepository());
  var allCategories = <CategoryModel>[].obs;
  var filteredCategories = <CategoryModel>[].obs;
  final txtSearch = TextEditingController();
  final txtName = TextEditingController();
  var txtImageUrl = "".obs;
  var selectedImage = "".obs;
  final isLoading = false.obs;
  @override
  void onInit() {
    txtSearch.addListener(() {
      searchCategories(txtSearch.text);
    });
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchCategories() async {
    try {
      final categories = await _categoryRepository.getAllCategories();
      allCategories.assignAll(categories);
      filteredCategories.assignAll(allCategories);
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    }
  }

  Future<CategoryModel?> getCategory(String categoryId) async {
    if (categoryId.isNotEmpty) {
      try {
        CategoryModel? category =
            await _categoryRepository.getCategoryById(categoryId);
        if (category != null) {
          txtName.text = category.categoryName;
          txtImageUrl.value = category.imageUrl;
        }
        return category;
      } catch (e) {
        Get.snackbar('Lỗi', e.toString());
        return null;
      }
    }
    return null;
  }

  void searchCategories(String query) {
    if (query.isEmpty) {
      filteredCategories.assignAll(allCategories);
    } else {
      filteredCategories.assignAll(
        allCategories.where((restaurant) => restaurant.categoryName
            .toLowerCase()
            .contains(query.toLowerCase())),
      );
    }
  }

  Future<void> addCategory(BuildContext context) async {
    try {
      isLoading.value = true;
      if (txtImageUrl.value.isNotEmpty) {
        final imageUrl = await _categoryRepository.uploadImage(
            "Categories/", XFile(txtImageUrl.value));

        final newCategory = CategoryModel(
          itemCategoryID: _firestore.collection('ItemCategories').doc().id,
          categoryName: txtName.text,
          imageUrl: imageUrl,
        );

        await _categoryRepository.addCategoryRecord(newCategory);
        await fetchCategories();
        Get.snackbar("Thông báo", "Thêm danh mục thành công!");
        Navigator.pop(context);
      } else {
        Get.snackbar("Lỗi", "Vui lòng thêm ảnh danh mục!");
      }
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    } finally {
      isLoading.value = false;
    }
  }

  String getCategoryNameById(String id) {
    return allCategories
        .firstWhere((category) => category.itemCategoryID == id,
            orElse: () => CategoryModel.empty())
        .categoryName;
  }

  Future<void> updateInformation(
      BuildContext context, String categoryId) async {
    if (categoryId.isEmpty) return;
    try {
      isLoading.value = true;
      var restaurant = await _categoryRepository.getCategoryById(categoryId);
      String oldImageUrl = restaurant?.imageUrl ?? "";
      String imageUrl = "";

      if (selectedImage.value.isNotEmpty) {
        imageUrl = await _categoryRepository.uploadImage(
            "Categories/", XFile(selectedImage.value));
      }
      Map<String, dynamic> data = {
        'CategoryName': txtName.text,
        if (imageUrl.isNotEmpty) 'ImageUrl': imageUrl,
      };
      await _categoryRepository.updateCategoryField(data, categoryId);
      Get.snackbar("Thông báo", "Cập nhật thông tin thành công");
      if (imageUrl.isNotEmpty && oldImageUrl.isNotEmpty) {
        await _categoryRepository.deleteImage(oldImageUrl);
      }
      await fetchCategories();
      Navigator.pop(context);
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    } finally {
      isLoading.value = false;
    }
  }

  void pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );

      if (image != null) {
        selectedImage.value = image.path;
      }
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  void onDeletePressed(BuildContext context, String categoryId) async {
    bool? confirm = await showConfirmDialog(context);
    if (confirm == true) {
      // User confirmed deletion
      await removeCategoryRecord(categoryId);
    }
  }

  Future<void> removeCategoryRecord(String categoryId) async {
    try {
      isLoading.value = true;
      var category = await _categoryRepository.getCategoryById(categoryId);
      String? oldImageUrl = category?.imageUrl;
      List<RestaurantModel> resToUpdate =
          await _restaurantRepository.getResByCategoryId(categoryId);
      List<ItemModel> itemsToUpdate =
          await _itemRepository.getItemsByCategoryId(categoryId);
      for (var res in resToUpdate) {
        await _itemRepository
            .updateItemField({'ItemCategoryID': ""}, res.idCategory ?? "");
      }
      for (var item in itemsToUpdate) {
        await _itemRepository
            .updateItemField({'ItemCategoryID': ""}, item.itemID ?? "");
      }

      await _categoryRepository.removeCategory(categoryId);
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        await _categoryRepository.deleteImage(oldImageUrl);
      }
      fetchCategories();
      Get.snackbar("Thông báo", "Xoá thành công quán ăn!!");
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    } finally {
      isLoading.value = false;
    }
  }
}
