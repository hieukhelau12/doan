import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common_widget/confirm_delete_dialog.dart';
import 'package:food_delivery/models/item_model.dart';
import 'package:food_delivery/models/restaurant_model.dart';
import 'package:food_delivery/repositories/item_repository.dart';
import 'package:food_delivery/repositories/restaurant_repository.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantController extends GetxController {
  static RestaurantController get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _restaurantRepository = Get.put(RestaurantRepository());
  final _itemRepository = Get.put(ItemRepository());
  RxList<RestaurantModel> allRestaurants = <RestaurantModel>[].obs;
  RxList<RestaurantModel> allResByCategoryId = <RestaurantModel>[].obs;
  var restaurantLike = RestaurantModel().obs;
  final txtSearch = TextEditingController();
  final txtName = TextEditingController();
  final txtClose = "".obs;
  final txtOpen = "".obs;
  final txtAddress = TextEditingController();
  final txtIdCatogory = TextEditingController();
  final categoryEditingController = TextEditingController();
  var restaurants = <String, RestaurantModel>{}.obs;
  var filteredRestaurants = <RestaurantModel>[].obs;
  var selectedCategory = "".obs;
  var categoryName = "".obs;
  var selectedImage = "".obs;
  var txtImageUrl = "".obs;
  var searchQuery = ''.obs;
  final isLoading = false.obs;
  @override
  void onInit() {
    txtSearch.addListener(() {
      searchRestaurants(txtSearch.text);
    });
    fetchRestaurants();
    super.onInit();
  }

  Future<void> fetchRestaurants() async {
    try {
      isLoading.value = true;
      final restaurants = await _restaurantRepository.getAllRestaurants();
      allRestaurants.assignAll(restaurants);
      filteredRestaurants.assignAll(allRestaurants);
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getRestaurant(String restaurantId) async {
    if (restaurantId.isNotEmpty) {
      try {
        RestaurantModel res =
            await _restaurantRepository.getRestaurantById(restaurantId);
        if (res != null) {
          txtName.text = res.restaurantName!;
          txtAddress.text = res.address!;
          txtOpen.value = res.openingTime!;
          txtClose.value = res.closingTime!;
          txtImageUrl.value = res.imageUrl;
        }
        restaurantLike.value = res;
      } catch (e) {
        Get.snackbar('Lỗi', e.toString());
      }
    }
  }

  // Future<void> loadRestaurants(List<String> restaurantIds) async {
  //   try {
  //     final futures = restaurantIds
  //         .map((id) => _restaurantRepository.getRestaurantById(id));
  //     final results = await Future.wait(futures);

  //     for (var restaurant in results) {
  //       if (restaurant != null) {
  //         restaurants[restaurant.restaurantID] = restaurant;
  //       }
  //     }
  //   } catch (e) {
  //     Get.snackbar('Lỗi', e.toString());
  //   }
  // }
  Future<void> loadRestaurants(List<String> restaurantIds) async {
    try {
      isLoading.value = true;
      for (var id in restaurantIds) {
        var restaurant = await _restaurantRepository.getRestaurantById(id);
        restaurants[id] = restaurant; // Cập nhật vào danh sách nhà hàng
      }
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getResByCategoryId(String categoryId) async {
    try {
      List<RestaurantModel> items =
          await _restaurantRepository.getResByCategoryId(categoryId);
      allResByCategoryId.assignAll(items);
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    }
  }

  String getRestaurantNameById(String id) {
    return allRestaurants
            .firstWhere((restaurant) => restaurant.restaurantID == id,
                orElse: () => RestaurantModel.empty())
            .restaurantName ??
        "";
  }

  void searchRestaurants(String query) {
    if (query.isEmpty) {
      filteredRestaurants.assignAll(allRestaurants);
    } else {
      filteredRestaurants.assignAll(
        allRestaurants.where((restaurant) =>
            restaurant.restaurantName
                ?.toLowerCase()
                .contains(query.toLowerCase()) ??
            false),
      );
    }
  }

  Future<void> addRestaurant(BuildContext context) async {
    try {
      isLoading.value = true;
      if (selectedImage.value.isNotEmpty) {
        final imageUrl = await _restaurantRepository.uploadImage(
            "Restaurants/", XFile(selectedImage.value));

        final newRestaurant = RestaurantModel(
          restaurantID: _firestore.collection('Restaurants').doc().id,
          restaurantName: txtName.text,
          address: txtAddress.text,
          idCategory: selectedCategory.value,
          openingTime: txtOpen.value,
          closingTime: txtClose.value,
          imageUrl: imageUrl,
        );

        await _restaurantRepository.addRestaurantRecord(newRestaurant);
        await fetchRestaurants();
        Navigator.pop(context);
        Get.snackbar("Thông báo", "Thêm quán ăn thành công!");
      } else {
        Get.snackbar("Lỗi", "Vui lòng chọn ảnh quán ăn!");
      }
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateInformation(
      BuildContext context, String restaurantId) async {
    if (restaurantId.isEmpty) return;

    try {
      isLoading.value = true;

      var restaurant =
          await _restaurantRepository.getRestaurantById(restaurantId);
      String oldImageUrl = restaurant.imageUrl;
      String imageUrl = "";

      if (selectedImage.value.isNotEmpty) {
        imageUrl = await _restaurantRepository.uploadImage(
            "Restaurants/", XFile(selectedImage.value));
      }

      Map<String, dynamic> data = {
        'RestaurantName': txtName.text,
        'Address': txtAddress.text,
        'ItemCategoryID': selectedCategory.value,
        'OpeningTime': txtOpen.value,
        'ClosingTime': txtClose.value,
        if (imageUrl.isNotEmpty) 'ImageUrl': imageUrl
      };

      await _restaurantRepository.updateRestaurantField(data, restaurantId);

      if (imageUrl.isNotEmpty && oldImageUrl.isNotEmpty) {
        await _restaurantRepository.deleteImage(oldImageUrl);
      }

      Get.snackbar("Thông báo", "Cập nhật thông tin thành công");
      await fetchRestaurants();
      Navigator.pop(context);
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi update: $e");
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

  void onDeletePressed(BuildContext context, String restaurantId) async {
    bool? confirm = await showConfirmDialog(context);
    if (confirm == true) {
      await removeRestaurantRecord(restaurantId);
    }
  }

  Future<void> removeRestaurantRecord(String restaurantId) async {
    try {
      isLoading.value = true;
      var restaurant =
          await _restaurantRepository.getRestaurantById(restaurantId);
      String? oldImageUrl = restaurant.imageUrl;
      List<ItemModel> itemsToUpdate =
          await _itemRepository.getItemsByRestaurantId(restaurantId);
      for (var item in itemsToUpdate) {
        await _itemRepository
            .updateItemField({'RestaurantID': ""}, item.itemID ?? "");
      }
      await _restaurantRepository.removeRestaurant(restaurantId);
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        await _restaurantRepository.deleteImage(oldImageUrl);
      }
      fetchRestaurants();
      Get.snackbar("Thông báo", "Xoá thành công quán ăn!!");
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    } finally {
      isLoading.value = false;
    }
  }
}
