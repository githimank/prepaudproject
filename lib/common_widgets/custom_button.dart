import 'package:flutter/material.dart';
import 'package:prepaudproject/constants/app_color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    this.buttonColor = AppColors.kMainBlack,
    this.textColor = AppColors.kPureWhite,
    required this.buttonText,
    this.horizontalPadding = 16,
  });

  final Color buttonColor;
  final Color textColor;
  final String buttonText;
  final Function() onTap;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: buttonColor,
        padding:
            EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
