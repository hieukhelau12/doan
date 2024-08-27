import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? reviewID;
  String? restaurantID;
  String? userID;
  String? orderID;
  int? rating;
  String? reviewText;
  String? reviewDate;
  String? imageUrl;

  ReviewModel(
      {this.reviewID,
      this.userID,
      this.restaurantID,
      this.orderID,
      this.rating,
      this.reviewText,
      this.reviewDate,
      this.imageUrl});

  factory ReviewModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return ReviewModel(
        reviewID: document.id,
        userID: data['UserID'] ?? '',
        restaurantID: data['RestaurantID'] ?? '',
        orderID: data['OrderID'] ?? '',
        rating: data['Rating'] ?? 0,
        reviewText: data['ReviewText'] ?? "",
        reviewDate: data['ReviewDate'] ?? "",
        imageUrl: data['ImageUrl'] ?? "",
      );
    } else {
      return ReviewModel.empty();
    }
  }

  static ReviewModel empty() => ReviewModel(
        reviewID: "",
        userID: "",
        restaurantID: "",
        orderID: "",
        rating: 0,
        reviewText: "",
        reviewDate: "",
        imageUrl: "",
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['RestaurantID'] = restaurantID;
    data['OrderID'] = orderID;
    data['Rating'] = rating;
    data['ReviewText'] = reviewText;
    data['ReviewDate'] = reviewDate;
    data['ImageUrl'] = imageUrl;
    return data;
  }
}
