import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  String? userId;
  String? addressId;
  String? displayName;
  String? clientName;
  String? phoneNumber;
  String? detailAddress;
  String? ward;
  String? district;
  String? city;
  bool isDefault;

  AddressModel(
      {this.userId,
      this.addressId,
      this.displayName,
      this.clientName,
      this.phoneNumber,
      this.detailAddress,
      this.ward,
      this.district,
      this.city,
      this.isDefault = false});

  static AddressModel empty() => AddressModel(
        addressId: "",
        userId: "",
        displayName: "",
        clientName: "",
        phoneNumber: "",
        detailAddress: "",
        ward: "",
        district: "",
        city: "",
        isDefault: false,
      );

  factory AddressModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return AddressModel(
        addressId: document.id,
        userId: data['UserId'] ?? '',
        displayName: data['DisplayName'] ?? '',
        clientName: data['ClientName'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        detailAddress: data['DetailAddress'] ?? '',
        ward: data['Ward'] ?? '',
        district: data['District'] ?? '',
        city: data['City'] ?? '',
        isDefault: data['IsDefault'] ?? false,
      );
    } else {
      return AddressModel.empty();
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['DisplayName'] = displayName;
    data['ClientName'] = clientName;
    data['PhoneNumber'] = phoneNumber;
    data['DetailAddress'] = detailAddress;
    data['Ward'] = ward;
    data['District'] = district;
    data['City'] = city;
    data['IsDefault'] = isDefault;
    return data;
  }
}
