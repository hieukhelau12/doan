import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  String restaurantID;
  String? restaurantName;
  String? idCategory;
  String? address;
  String? openingTime;
  String? closingTime;
  String imageUrl;

  RestaurantModel(
      {this.restaurantID = "",
      this.restaurantName,
      this.idCategory,
      this.address,
      this.openingTime,
      this.closingTime,
      this.imageUrl = ""});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RestaurantName'] = restaurantName;
    data['Address'] = address;
    data['ItemCategoryID'] = idCategory;
    data['OpeningTime'] = openingTime;
    data['ClosingTime'] = closingTime;
    data['ImageUrl'] = imageUrl;
    return data;
  }

  static RestaurantModel empty() => RestaurantModel(
        restaurantID: "",
        restaurantName: "",
        address: "",
        idCategory: "",
        openingTime: "",
        closingTime: "",
        imageUrl: "",
      );

  factory RestaurantModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return RestaurantModel(
        restaurantID: document.id,
        restaurantName: data['RestaurantName'] ?? '',
        address: data['Address'] ?? '',
        idCategory: data['ItemCategoryID'] ?? '',
        openingTime: data['OpeningTime'] ?? '',
        closingTime: data['ClosingTime'] ?? '',
        imageUrl: data['ImageUrl'] ?? '',
      );
    } else {
      return RestaurantModel.empty();
    }
  }
}
