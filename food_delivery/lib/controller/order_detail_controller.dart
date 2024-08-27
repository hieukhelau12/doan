import 'package:food_delivery/controller/item_controller.dart';
import 'package:food_delivery/models/item_model.dart';
import 'package:food_delivery/models/ordel_detail_model.dart';
import 'package:food_delivery/repositories/item_repository.dart';
import 'package:food_delivery/repositories/order_detail_repository.dart';
import 'package:get/get.dart';

class OrderDetailController extends GetxController {
  static OrderDetailController get instance => Get.find();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var allOrderDetails = <OrderDetailModel>[].obs;
  final _orderDetailRepository = Get.put(OrderDetailRepository());
  final isLoading = false.obs;
  final itemController = Get.put(ItemController());
  final _itemRepository = Get.find<ItemRepository>();
  // @override
  // void onInit() {
  //   super.onInit();
  //   getOrder();
  // }

  Future<void> getOrder(String orderId) async {
    try {
      List<OrderDetailModel> orders =
          await _orderDetailRepository.getOrderDetails(orderId);
      print("details for order $orderId");
      allOrderDetails.assignAll(orders);
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    }
  }

  Future<List<OrderDetailModel>> getOrderDetails(String orderId) async {
    try {
      // Lấy tất cả OrderDetail cho orderId từ repository
      List<OrderDetailModel> orders =
          await _orderDetailRepository.getOrderDetails(orderId);

      // Cập nhật danh sách chi tiết đơn hàng
      allOrderDetails.assignAll(orders);
      print("Fetched ${orders.length} details for order $orderId");
      return orders;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch order details');
      return [];
    }
  }

  Future<List<ItemModel>> getItemsForOrder(String orderId) async {
    try {
      // Lấy tất cả OrderDetail cho orderId
      await getOrder(orderId);

      // Lấy itemId từ tất cả OrderDetail của orderId cụ thể
      List<String> itemIds = allOrderDetails
          .where((detail) => detail.orderID == orderId)
          .map((detail) => detail.itemID)
          .toSet()
          .toList();

      // Lấy thông tin món ăn cho các itemId
      List<ItemModel> items = await _itemRepository.getItemsByIds(itemIds);

      return items;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<int> getTotalQuantity(String orderId) async {
    try {
      await getOrder(orderId);

      final orderDetails =
          allOrderDetails.where((detail) => detail.orderID == orderId).toList();

      int totalQuantity =
          orderDetails.fold(0, (sum, detail) => sum + (detail.quantity ?? 0));
      update();
      return totalQuantity;
    } catch (e) {
      print("Error in getTotalQuantity: $e"); // Debug log
      return 0;
    }
  }
}
