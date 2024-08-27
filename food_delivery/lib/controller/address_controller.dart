import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common_widget/confirm_delete_dialog.dart';
import 'package:food_delivery/models/address_model.dart';
import 'package:food_delivery/repositories/address_repository.dart';
import 'package:food_delivery/repositories/authentication_repository.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var allAddresses = <AddressModel>[].obs;
  var noDefaultAddresses = <AddressModel>[].obs;
  var defaultAddress = AddressModel().obs;
  final _addressRepository = Get.put(AddressRepository());
  final _authRepository = Get.put(AuthenticationRepository());
  final txtDisplayName = TextEditingController();
  final txtClientName = TextEditingController();
  final txtPhone = TextEditingController();
  final txtDetailAddress = TextEditingController();
  final txtWard = TextEditingController();
  final txtDistrict = TextEditingController();
  final txtCity = TextEditingController();
  final isLoading = false.obs;
  final isChecked = false.obs;
  @override
  void onInit() {
    super.onInit();
    getAddress();
  }

  Future<void> getAddress() async {
    final userId = _authRepository.authUser!.uid;
    print(userId);
    if (userId.isNotEmpty) {
      try {
        List<AddressModel> addresses =
            await _addressRepository.getAddressByUserId(userId);
        allAddresses.assignAll(addresses);
      } catch (e) {
        Get.snackbar('Lỗi', e.toString());
      }
    }
  }

  Future<void> getNoDefaultAddresses() async {
    try {
      final userId = _authRepository.authUser!.uid;
      final address = await _addressRepository.getNoDefaultAddress(userId);
      noDefaultAddresses.value = address;
    } catch (e) {
      Get.snackbar("Lỗi", "$e");
    }
  }

  Future<void> getDefaultAddress() async {
    try {
      final userId = _authRepository.authUser!.uid;
      final address = await _addressRepository.getDefaultAddress(userId);
      defaultAddress.value = address;
    } catch (e) {
      Get.snackbar("Lỗi", "$e");
    }
  }

  Future<void> addAddress(BuildContext context) async {
    try {
      isLoading.value = true;
      final userId = _authRepository.authUser!.uid;
      if (isChecked.value) {
        final addressesQuery = await _firestore
            .collection('Addresses')
            .where('UserId', isEqualTo: userId)
            .where('IsDefault', isEqualTo: true)
            .get();

        for (var doc in addressesQuery.docs) {
          await doc.reference.update({'IsDefault': false});
        }
      }
      final newAddress = AddressModel(
          addressId: _firestore.collection('Addresses').doc().id,
          userId: userId,
          displayName: txtDisplayName.text,
          clientName: txtClientName.text,
          phoneNumber: txtPhone.text,
          detailAddress: txtDetailAddress.text,
          ward: txtWard.text,
          district: txtDistrict.text,
          city: txtCity.text,
          isDefault: isChecked.value);

      await _addressRepository.addAddressRecord(newAddress);

      await getDefaultAddress();
      await getNoDefaultAddresses();
      Get.snackbar("Thông báo", "Thêm địa chỉ thành công!");
      Navigator.pop(context);

      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateInformation(BuildContext context, String addressId) async {
    if (addressId.isEmpty) return;
    try {
      isLoading.value = true;
      final userId = _authRepository.authUser!.uid;
      if (isChecked.value) {
        final addressesQuery = await _firestore
            .collection('Addresses')
            .where('UserId', isEqualTo: userId)
            .where('IsDefault', isEqualTo: true)
            .get();

        for (var doc in addressesQuery.docs) {
          await doc.reference.update({'IsDefault': false});
        }
      }
      Map<String, dynamic> data = {
        'DisplayName': txtDisplayName.text,
        'ClientName': txtClientName.text,
        'PhoneNumber': txtPhone.text,
        'DetailAddress': txtDetailAddress.text,
        'Ward': txtWard.text,
        'District': txtDistrict.text,
        'City': txtCity.text,
        'IsDefault': isChecked.value,
      };
      await _addressRepository.updateAddressField(data, addressId);
      Get.snackbar("Thông báo", "Cập nhật thông tin thành công");

      await getDefaultAddress();
      await getNoDefaultAddresses();
      Navigator.pop(context);
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onDeletePressed(BuildContext context, String addressId) async {
    bool? confirm = await showConfirmDialog(context);
    if (confirm == true) {
      // User confirmed deletion
      await removeAddressRecord(context, addressId);
    }
  }

  Future<void> removeAddressRecord(
      BuildContext context, String addressId) async {
    try {
      isLoading.value = true;

      final addressToRemove =
          await _addressRepository.getAddressById(addressId);
      bool isDefaultAddress = addressToRemove.isDefault;

      if (isDefaultAddress) {
        final newDefaultAddress = noDefaultAddresses.firstWhere(
          (address) => address.addressId != addressId && !address.isDefault,
          orElse: () => noDefaultAddresses.first,
        );
        if (newDefaultAddress != null) {
          // Cập nhật địa chỉ mới để làm địa chỉ mặc định
          await _addressRepository.updateAddressField({
            'IsDefault': true,
          }, newDefaultAddress.addressId ?? "");
        }
        await _addressRepository.removeAddress(addressId);

        getDefaultAddress();
        getNoDefaultAddresses();
        Get.snackbar("Thông báo", "Xoá thành công địa chỉ!!");
        Navigator.pop(context);
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    } finally {
      isLoading.value = false;
    }
  }
}
