import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/repositories/user_respository.dart';
import 'package:food_delivery/models/user_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final txtName = TextEditingController();
  final txtEmail = TextEditingController();
  final txtMobile = TextEditingController();
  final txtGender = TextEditingController();
  final txtBirth = "".obs;
  final txtJob = TextEditingController();
  final userRespository = Get.put(UserRespository());

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  Future<void> fetchUserRecord() async {
    try {
      // profileLoading.value = true;
      final user = await userRespository.fetchUserRecord();
      this.user(user);
      txtName.text = user!.name;
      txtEmail.text = user.email;
      txtMobile.text = user.mobile;
      txtGender.text = user.gender;
      txtBirth.value = user.birthday;
      txtJob.text = user.job;
      // profileLoading.value = false;
    } catch (e) {
      user(UserModel.empty());
      // Get.snackbar("Thông báo", "Lỗi $e");
    } finally {
      // profileLoading.value = false;
    }
  }

  Future<void> saveUserRecord(UserCredential? userCredential) async {
    try {
      await fetchUserRecord();
      if (user.value.id.isEmpty) {
        if (userCredential != null) {
          final user = UserModel(
              id: userCredential.user!.uid,
              name: userCredential.user!.displayName ?? "",
              email: userCredential.user!.email ?? "",
              mobile: userCredential.user!.phoneNumber ?? "",
              isAdmin: false,
              profilePicture: userCredential.user!.photoURL ?? "");
          await userRespository.saveUserRecord(user);
        }
      }
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> updateGender(String gender) async {
    try {
      profileLoading.value = true;
      Map<String, dynamic> data = {
        'gender': gender,
      };
      await userRespository.updateSingleField(data);
      user.update((val) {
        val?.gender = gender;
      });
      profileLoading.value = false;
      Get.snackbar("Thông báo", "Cập nhật thông tin thành công");
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> updateBirthday(String birthday) async {
    try {
      profileLoading.value = true;
      Map<String, dynamic> birth = {
        'birthday': birthday,
      };
      await userRespository.updateSingleField(birth);
      txtBirth.value = birthday;
      profileLoading.value = false;
      Get.snackbar("Thông báo", "Cập nhật thông tin thành công");
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> saveUserToken(String token) async {
    try {
      Map<String, dynamic> data = {
        'token': token,
      };
      await userRespository.updateSingleField(data);
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> updateName(BuildContext context) async {
    try {
      profileLoading.value = true;
      Map<String, dynamic> name = {
        'name': txtName.text,
      };
      await userRespository.updateSingleField(name);
      user.update((val) {
        val?.name = txtName.text;
      });
      profileLoading.value = false;
      Get.snackbar("Thông báo", "Cập nhật thông tin thành công");
      Navigator.pop(context);
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> updateJob(BuildContext context) async {
    try {
      profileLoading.value = true;
      Map<String, dynamic> data = {
        'job': txtJob.text,
      };
      await userRespository.updateSingleField(data);
      user.update((val) {
        val?.job = txtJob.text;
      });
      profileLoading.value = false;
      Get.snackbar("Thông báo", "Cập nhật thông tin thành công");
      Navigator.pop(context);
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
          maxHeight: 512,
          maxWidth: 512);
      if (image != null) {
        final imageUrl =
            await userRespository.uploadImage("Users/Images/Profile/", image);
        Map<String, dynamic> json = {'profilePicture': imageUrl};
        await userRespository.updateSingleField(json);
        user.update((val) {
          val?.profilePicture = imageUrl;
        });
        Get.snackbar("Thông báo", "Cập nhật ảnh đại diện thành công!");
      }
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }
}
