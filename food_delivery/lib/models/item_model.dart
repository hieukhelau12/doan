import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String? itemID;
  String? restaurantID;
  String? itemCategoryID;
  String? itemName;
  String? price;
  String? imageUrl;

  ItemModel(
      {this.itemID,
      this.restaurantID,
      this.itemCategoryID,
      this.itemName,
      this.price,
      this.imageUrl});

  static ItemModel empty() => ItemModel(
        itemID: "",
        restaurantID: "",
        itemCategoryID: "",
        itemName: "",
        price: "",
        imageUrl: "",
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RestaurantID'] = restaurantID;
    data['ItemCategoryID'] = itemCategoryID;
    data['ItemName'] = itemName;
    data['Price'] = price;
    data['ImageURL'] = imageUrl;
    return data;
  }

  factory ItemModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return ItemModel(
        itemID: document.id,
        restaurantID: data['RestaurantID'] ?? '',
        itemCategoryID: data['ItemCategoryID'] ?? '',
        itemName: data['ItemName'] ?? '',
        price: data['Price'] ?? '',
        imageUrl: data['ImageURL'] ?? '',
      );
    } else {
      return ItemModel.empty();
    }
  }
}
