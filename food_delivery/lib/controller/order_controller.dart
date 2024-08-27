import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common_widget/confirm_delete_dialog.dart';
import 'package:food_delivery/controller/item_controller.dart';
import 'package:food_delivery/controller/order_detail_controller.dart';
import 'package:food_delivery/models/item_model.dart';
import 'package:food_delivery/models/ordel_detail_model.dart';
import 'package:food_delivery/models/order_model.dart';
import 'package:food_delivery/models/restaurant_model.dart';
import 'package:food_delivery/repositories/authentication_repository.dart';
import 'package:food_delivery/repositories/order_detail_repository.dart';
import 'package:food_delivery/repositories/order_repository.dart';
import 'package:food_delivery/repositories/restaurant_repository.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var allOrdersByUser = <OrderModel>[].obs;
  var allOrders = <OrderModel>[].obs;
  var allOrdersPending = <OrderModel>[].obs;
  var allOrdersCompleteAndCancel = <OrderModel>[].obs;
  var recentRestaurants = <RestaurantModel>[].obs;
  var order = OrderModel().obs;
  final _orderRepository = Get.put(OrderRepository());
  final orderDetailController = Get.put(OrderDetailController());
  final _authRepository = Get.put(AuthenticationRepository());
  final _orderDetailRepository = Get.put(OrderDetailRepository());
  final _restaurantRepository = Get.put(RestaurantRepository());
  final isLoading = false.obs;
  final itemController = Get.put(ItemController());
  var isPopupVisible = false.obs;
  var selectedStatus = 'Đang xử lý'.obs;
  final List<String> statuses1 = ['Tất cả', 'Hoàn thành', 'Đã huỷ'].obs;
  final List<String> statuses2 =
      ['Đang xử lý', 'Tất cả', 'Đang giao hàng', 'Hoàn thành', 'Đã huỷ'].obs;
  var sortOrder = "Sắp xếp".obs;

  var isSortPopupVisible = false.obs;

  var orderDetailsCache = <String, List<OrderDetailModel>>{}.obs;
  var itemsCache = <String, List<ItemModel>>{}.obs;
  void toggleSortPopup() {
    isSortPopupVisible.value = !isSortPopupVisible.value;
  }

  void selectSortOrder(String value) {
    sortOrder.value = value;
    isSortPopupVisible.value = false;
  }

  void sortOrdersBy(String sortOrder) {
    if (sortOrder == "Mới nhất") {
      filteredOrdersCSDL.sort((a, b) => b.orderDate!.compareTo(a.orderDate!));
    } else if (sortOrder == "Cũ nhất") {
      filteredOrdersCSDL.sort((a, b) => a.orderDate!.compareTo(b.orderDate!));
    }
  }

  Future<void> loadOrderDetails(String orderId) async {
    if (!orderDetailsCache.containsKey(orderId)) {
      final details = await orderDetailController.getOrderDetails(orderId);
      orderDetailsCache[orderId] = details;
    }
  }

  Future<void> loadItemsForOrder(String orderId) async {
    if (!itemsCache.containsKey(orderId)) {
      final items = await orderDetailController.getItemsForOrder(orderId);
      itemsCache[orderId] = items;
    }
  }

  Future<void> getOrder() async {
    try {
      List<OrderModel> orders = await _orderRepository.getAllOrders();
      allOrders.assignAll(orders);
      update();
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    }
  }

  Future<void> getOrderByUserId() async {
    final userId = _authRepository.authUser!.uid;
    if (userId.isNotEmpty) {
      try {
        List<OrderModel> orders =
            await _orderRepository.getOrderByUserId(userId);
        allOrdersByUser.assignAll(orders);
      } catch (e) {
        Get.snackbar('Lỗi', e.toString());
      }
    }
  }

  Future<List<OrderModel>> getOrdersPending() async {
    try {
      final userId = _authRepository.authUser!.uid;

      List<OrderModel> ordersStatus1 =
          await _orderRepository.getOrdersByUserIdAndStatus(userId, 1);

      List<OrderModel> ordersStatus2 =
          await _orderRepository.getOrdersByUserIdAndStatus(userId, 2);

      List<OrderModel> ordersPending = [...ordersStatus1, ...ordersStatus2];

      allOrdersPending.assignAll(ordersPending);
      update();

      return ordersPending;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return [];
    }
  }

  Future<List<OrderModel>> getOrdersCompleteAndCancel() async {
    try {
      final userId = _authRepository.authUser!.uid;
      List<OrderModel> ordersStatus1 =
          await _orderRepository.getOrdersByUserIdAndStatus(userId, 3);

      List<OrderModel> ordersStatus2 =
          await _orderRepository.getOrdersByUserIdAndStatus(userId, 4);

      List<OrderModel> ordersCompleteAndCancel = [
        ...ordersStatus1,
        ...ordersStatus2
      ];

      allOrdersCompleteAndCancel.assignAll(ordersCompleteAndCancel);

      return ordersCompleteAndCancel;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return [];
    }
  }

  void togglePopup() {
    isPopupVisible.value = !isPopupVisible.value;
  }

  void selectStatus(String status) {
    selectedStatus.value = status;
    isPopupVisible.value = false;
  }

  List<OrderModel> get filteredOrdersCSDL {
    if (selectedStatus.value == 'Tất cả') {
      return allOrders;
    } else if (selectedStatus.value == 'Đang xử lý') {
      return allOrders.where((order) => order.status == 1).toList();
    } else if (selectedStatus.value == 'Đang giao hàng') {
      return allOrders.where((order) => order.status == 2).toList();
    } else if (selectedStatus.value == 'Đã Huỷ') {
      return allOrders.where((order) => order.status == 3).toList();
    } else if (selectedStatus.value == 'Hoàn thành') {
      return allOrders.where((order) => order.status == 4).toList();
    }
    return allOrdersCompleteAndCancel;
  }

  List<OrderModel> get filteredOrders {
    if (selectedStatus.value == 'Tất cả') {
      return allOrdersCompleteAndCancel;
    } else if (selectedStatus.value == 'Hoàn thành') {
      return allOrdersCompleteAndCancel
          .where((order) => order.status == 4)
          .toList();
    } else if (selectedStatus.value == 'Đã huỷ') {
      return allOrdersCompleteAndCancel
          .where((order) => order.status == 3)
          .toList();
    }
    return allOrdersCompleteAndCancel;
  }

  Future<void> getOrderById(String orderId) async {
    try {
      var item = await _orderRepository.getOrderById(orderId);
      order.value = item;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    }
  }

  Future<void> addOrder({
    required String restaurantId,
    required double totalAmount,
    required String deliveryAddress,
    required String clientName,
    required String clientPhone,
    required String paymentMethod,
  }) async {
    try {
      isLoading.value = true;
      final userId = _authRepository.authUser!.uid;
      final newOrder = OrderModel(
        orderID: _firestore.collection('Orders').doc().id,
        userID: userId,
        restaurantID: restaurantId,
        totalAmount: totalAmount.toString(),
        deliveryAddress: deliveryAddress,
        clientName: clientName,
        clientPhone: clientPhone,
        paymentMethod: paymentMethod,
        status: 1,
        orderDate: DateTime.now().toIso8601String(),
        completeDate: "",
      );

      await _orderRepository.addOrderRecord(newOrder);

      for (var item in itemController.allItemsByResId) {
        final quantity = itemController
            .quantities[itemController.allItemsByResId.indexOf(item)];
        if (quantity > 0) {
          final price = double.tryParse(item.price ?? "")! * quantity;
          final orderDetail = OrderDetailModel(
            orderDetailID: _firestore.collection('OrderDetails').doc().id,
            orderID: newOrder.orderID,
            itemID: item.itemID ?? "",
            totalPrice: price.toString(),
            quantity: quantity,
          );

          await _orderDetailRepository.addOrderDetail(orderDetail);
        }
      }

      await getOrder();
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onUpdatePressed(BuildContext context, String orderId, int status) async {
    bool? confirm = await showConfirmDialog(context);
    if (confirm == true) {
      await updateInformation(context, orderId, status);
    }
  }

  Future<void> updateInformation(
      BuildContext context, String orderId, int status) async {
    if (orderId.isEmpty) return;
    try {
      isLoading.value = true;

      Map<String, dynamic> data = {"Status": status};
      await _orderRepository.updateOrderField(data, orderId);
      if (status == 1) {
        Get.snackbar(
            "Thông báo", "Đã đổi trạng thái đơn hàng thành giao hàng!!");
      }
      if (status == 2) {
        Get.snackbar("Thông báo", "Huỷ đơn hàng thành công!!");
      }
      if (status == 3) {
        Get.snackbar("Thông báo", "Đơn hàng đã hoàn thành!!");
      }
      await getOrder();
      await getOrdersCompleteAndCancel();
      await getOrdersPending();
      Navigator.pop(context);
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getRecentOrderedRestaurants() async {
    try {
      final userId = _authRepository.authUser!.uid;
      final orders = await _orderRepository.getOrderByUserId(userId);
      final recentOrders = orders.where((order) {
        final orderDateTime = order.orderDateTime;
        final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 15));
        return orderDateTime.isAfter(thirtyDaysAgo);
      }).toList();
      final restaurantIds =
          recentOrders.map((order) => order.restaurantID).toSet();
      final fetchedRestaurants = <RestaurantModel>[];
      for (var restaurantId in restaurantIds) {
        final restaurant =
            await _restaurantRepository.getRestaurantById(restaurantId ?? "");
        fetchedRestaurants.add(restaurant);
      }
      recentRestaurants.value = fetchedRestaurants;
    } catch (e) {
      print('Error fetching recent ordered restaurants: $e');
    }
  }
}
