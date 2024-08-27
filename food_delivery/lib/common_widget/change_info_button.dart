import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';

class ChangeInfoButton extends StatelessWidget {
  const ChangeInfoButton(
      {super.key,
      required this.value,
      required this.title,
      required this.onTap,
      this.isDisable = false});
  final String title;
  final String value;
  final VoidCallback onTap;
  final bool isDisable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: TColor.white,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDisable ? TColor.placeholder : TColor.primaryText),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDisable ? TColor.placeholder : TColor.primaryText),
            ),
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDisable ? TColor.placeholder : TColor.primaryText,
              size: 15,
            )
          ],
        ),
      ),
    );
  }
}
