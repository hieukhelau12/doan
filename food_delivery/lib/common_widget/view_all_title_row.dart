import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';

class ViewAllTitleRow extends StatelessWidget {
  final String title;
  final VoidCallback onView;
  final bool isRecent;
  const ViewAllTitleRow(
      {super.key,
      required this.title,
      required this.onView,
      this.isRecent = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w800),
        ),
        if (!isRecent)
          TextButton(
            onPressed: onView,
            child: Text(
              "Xem tất cả",
              style: TextStyle(
                  color: TColor.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ),
      ],
    );
  }
}
