import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String? itemCategoryID;
  String categoryName;
  String imageUrl;

  CategoryModel(
      {this.itemCategoryID, required this.categoryName, this.imageUrl = ''});

  static CategoryModel empty() => CategoryModel(
        itemCategoryID: "",
        categoryName: "",
        imageUrl: "",
      );

  factory CategoryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return CategoryModel(
        itemCategoryID: document.id,
        categoryName: data['CategoryName'] ?? '',
        imageUrl: data['ImageUrl'] ?? '',
      );
    } else {
      return CategoryModel.empty();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CategoryName'] = categoryName;
    data['ImageUrl'] = imageUrl;
    return data;
  }
}
