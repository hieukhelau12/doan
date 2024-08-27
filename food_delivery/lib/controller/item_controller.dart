import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common_widget/confirm_delete_dialog.dart';
import 'package:food_delivery/models/item_model.dart';
import 'package:food_delivery/models/restaurant_model.dart';
import 'package:food_delivery/repositories/item_repository.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ItemController extends GetxController {
  static ItemController get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _itemRepository = Get.put(ItemRepository());
  RxList<ItemModel> allItems = <ItemModel>[].obs;
  RxList<ItemModel> allItemsByCategoryId = <ItemModel>[].obs;
  RxList<ItemModel> allItemsByResId = <ItemModel>[].obs;
  var filteredItems = <ItemModel>[].obs;
  final txtSearch = TextEditingController();
  final txtName = TextEditingController();
  final txtPrice = TextEditingController();
  final restaurant = RestaurantModel().obs;
  var txtImageUrl = "".obs;
  var selectedRestaurant = "".obs;
  var selectedCategory = "".obs;
  var selectedImage = "".obs;
  var selectedPrice = "".obs;
  final isLoading = false.obs;
  var quantities = <int>[].obs;

  var isOpen = false.obs;
  var total = 0.0.obs;
  RxBool isBottomSheetOpen = false.obs;
  @override
  void onInit() {
    txtSearch.addListener(() {
      searchRestaurants(txtSearch.text);
    });
    fetchItems();
    initializeQuantities(allItemsByResId.length);
    // Theo dõi sự thay đổi của quantities
    ever(quantities, (_) => calculateTotalOrderValue());
    super.onInit();
  }

  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      final items = await _itemRepository.getAllItems();
      allItems.assignAll(items);
      filteredItems.assignAll(allItems);
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<ItemModel?> getItem(String itemId) async {
    try {
      ItemModel? item = await _itemRepository.getItemById(itemId);
      if (item != null) {
        txtName.text = item.itemName!;
        txtPrice.text = item.price!;
        txtImageUrl.value = item.imageUrl!;
      }
      return item;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      return null;
    }
  }

  Future<void> getItemByCategoryId(String categoryId) async {
    try {
      List<ItemModel> items =
          await _itemRepository.getItemsByCategoryId(categoryId);
      allItemsByCategoryId.assignAll(items);
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    }
  }

  Future<void> getItemByRestaurantId(String restaurantId) async {
    try {
      List<ItemModel> items =
          await _itemRepository.getItemsByRestaurantId(restaurantId);
      allItemsByResId.assignAll(items);
      initializeQuantities(items.length); // Khởi tạo lại danh sách quantities
      update();
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    }
  }

  void searchRestaurants(String query) {
    if (query.isEmpty) {
      filteredItems.assignAll(allItems);
    } else {
      filteredItems.assignAll(
        allItems.where((restaurant) =>
            restaurant.itemName?.toLowerCase().contains(query.toLowerCase()) ??
            false),
      );
    }
  }

  Future<void> addItem(BuildContext context) async {
    try {
      isLoading.value = true;
      if (selectedImage.value.isNotEmpty) {
        final imageUrl = await _itemRepository.uploadImage(
            "Items/", XFile(selectedImage.value));

        final newRestaurant = ItemModel(
          itemID: _firestore.collection('Items').doc().id,
          restaurantID: selectedRestaurant.value,
          itemCategoryID: selectedCategory.value,
          itemName: txtName.text,
          price: txtPrice.text,
          imageUrl: imageUrl,
        );

        await _itemRepository.addItemRecord(newRestaurant);
        await fetchItems();
        Navigator.pop(context);
        Get.snackbar("Thông báo", "Thêm món ăn thành công!");
      } else {
        Get.snackbar("Lỗi", "Vui lòng thêm ảnh món ăn!");
      }
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateInformation(BuildContext context, String itemId) async {
    if (itemId.isEmpty) return;
    try {
      isLoading.value = true;
      var item = await _itemRepository.getItemById(itemId);
      String oldImageUrl = item?.imageUrl ?? "";
      String imageUrl = "";

      if (selectedImage.value.isNotEmpty) {
        imageUrl = await _itemRepository.uploadImage(
            "Items/", XFile(selectedImage.value));
      }
      Map<String, dynamic> data = {
        'ItemName': txtName.text,
        'Price': txtPrice.text,
        'RestaurantID': selectedRestaurant.value,
        'ItemCategoryID': selectedCategory.value,
        if (imageUrl.isNotEmpty) 'ImageUrl': imageUrl,
      };
      await _itemRepository.updateItemField(data, itemId);
      Get.snackbar("Thông báo", "Cập nhật thông tin thành công");
      if (imageUrl.isNotEmpty && oldImageUrl.isNotEmpty) {
        await _itemRepository.deleteImage(oldImageUrl);
      }
      await fetchItems();
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

  // Cập nhật danh sách số lượng
  void updateQuantities(int index, int quantity) {
    if (index >= 0 && index < quantities.length) {
      quantities[index] = quantity;
      update(); // Đảm bảo
    }
  }

  // Khởi tạo số lượng khi dữ liệu món ăn thay đổi
  void initializeQuantities(int length) {
    quantities.value = List<int>.filled(length, 0);
    calculateTotalOrderValue();
  }

  void calculateTotalOrderValue() {
    double totalValue = 0.0;
    for (int i = 0; i < allItemsByResId.length; i++) {
      var item = allItemsByResId[i];
      double price = double.tryParse(item.price ?? '0') ?? 0;
      totalValue += price * quantities[i];
    }
    total.value = totalValue; // Cập nhật giá trị tổng
  }

  void clearAllQuantities() {
    for (int i = 0; i < quantities.length; i++) {
      quantities[i] = 0;
    }
    update();
  }

  int getTotalQuantity() {
    int totalQuantity = 0;
    for (int qty in quantities) {
      totalQuantity += qty;
    }
    return totalQuantity;
  }

  void onDeletePressed(BuildContext context, String itemId) async {
    bool? confirm = await showConfirmDialog(context);
    if (confirm == true) {
      await removeItemRecord(itemId);
    }
  }

  Future<void> removeItemRecord(String itemId) async {
    try {
      isLoading.value = true;
      var item = await _itemRepository.getItemById(itemId);
      String? oldImageUrl = item?.imageUrl;
      await _itemRepository.removeItem(itemId);
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        await _itemRepository.deleteImage(oldImageUrl);
      }
      fetchItems();
      Get.snackbar("Thông báo", "Xoá thành công món ăn!!");
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    } finally {
      isLoading.value = false;
    }
  }
}
