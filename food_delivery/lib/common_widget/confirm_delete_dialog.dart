import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';

Future<bool> showConfirmDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible:
        false, // Prevent dismissing by tapping outside of the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn thực hiện không?'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(backgroundColor: TColor.primary),
            child: Text(
              'Không',
              style: TextStyle(color: TColor.white),
            ),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false if user cancels
            },
          ),
          TextButton(
            child: const Text('Có'),
            onPressed: () {
              Navigator.of(context).pop(true); // Return true if user confirms
            },
          ),
        ],
      );
    },
  );
}
