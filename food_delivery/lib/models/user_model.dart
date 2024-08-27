import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  String mobile;
  String gender;
  String birthday;
  String job;
  bool isAdmin;
  String profilePicture;
  String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    this.gender = "",
    this.birthday = "",
    this.job = "",
    this.isAdmin = false,
    required this.profilePicture,
    this.token = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'mobile': mobile,
      'name': name,
      'gender': gender,
      'birthday': birthday,
      'job': job,
      'isAdmin': isAdmin,
      'profilePicture': profilePicture,
      'token': token,
    };
  }

  static UserModel empty() => UserModel(
      id: '',
      name: '',
      email: '',
      mobile: '',
      gender: '',
      birthday: '',
      job: '',
      isAdmin: false,
      profilePicture: '',
      token: '');

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        name: data['name'] ?? '',
        profilePicture: data['profilePicture'] ?? '',
        email: data['email'] ?? '',
        gender: data['gender'] ?? '',
        birthday: data['birthday'] ?? '',
        job: data['job'] ?? '',
        isAdmin: data['isAdmin'] ?? false,
        mobile: data['mobile'] ?? '',
        token: data['token'] ?? '',
      );
    } else {
      return UserModel.empty();
    }
  }
}
