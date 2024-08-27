import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  String? likeId;
  String? userId;
  String? restaurantId;

  LikeModel({this.likeId, this.userId, this.restaurantId});

  static LikeModel empty() => LikeModel(
        likeId: "",
        userId: "",
        restaurantId: "",
      );
  factory LikeModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return LikeModel(
        likeId: document.id,
        userId: data['UserId'] ?? '',
        restaurantId: data['RestaurantId'] ?? '',
      );
    } else {
      return LikeModel.empty();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['RestaurantId'] = restaurantId;
    return data;
  }
}
