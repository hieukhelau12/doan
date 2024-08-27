import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/controller/profile_controller.dart';
import 'package:get/get.dart';

final controller = Get.put(ProfileController());
void showGenderSelectionBottomSheet(BuildContext context,
    String currentSelection, Function(String) onGenderSelected) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Nam'),
              contentPadding: EdgeInsets.zero,
              value: 'Nam',
              groupValue: currentSelection,
              onChanged: (value) {
                onGenderSelected(value!);
                controller.updateGender(value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Nữ'),
              contentPadding: EdgeInsets.zero,
              value: 'Nữ',
              groupValue: currentSelection,
              onChanged: (value) {
                onGenderSelected(value!);
                controller.updateGender(value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Khác'),
              contentPadding: EdgeInsets.zero,
              value: 'Khác',
              groupValue: currentSelection,
              onChanged: (value) {
                onGenderSelected(value!);
                controller.updateGender(value);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: TColor.primary,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                child: Text(
                  "Huỷ",
                  style: TextStyle(
                      color: TColor.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
