import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';

class TabButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String icon;
  final bool isSelected;
  const TabButton(
      {super.key,
      required this.onTap,
      required this.title,
      required this.isSelected,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 15,
              height: 15,
              color: isSelected ? TColor.primary : TColor.placeholder,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              style: TextStyle(
                  color: isSelected ? TColor.primary : TColor.placeholder,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
