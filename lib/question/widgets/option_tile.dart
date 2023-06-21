import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prepaudproject/constants/app_color.dart';
import 'package:prepaudproject/constants/app_text_style.dart';
import 'package:prepaudproject/constants/image_path.dart';

class OptionsTile extends StatelessWidget {
  final String selectedAnswer;
  final String correctAnswer;
  final String option;
  final VoidCallback onTap;
  const OptionsTile(
      {super.key,
      required this.selectedAnswer,
      required this.correctAnswer,
      required this.option,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isSelected = option == selectedAnswer;
    final bool isCorrect =
        option == correctAnswer && selectedAnswer.trim().isNotEmpty;
    final bool isWrong = !isCorrect;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isCorrect ? AppColors.yellowAmber100 : AppColors.kPureWhite,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              color: isSelected
                  ? isWrong
                      ? AppColors.red500
                      : AppColors.green500
                  : isCorrect
                      ? AppColors.yellowAmber
                      : AppColors.grey200),
        ),
        child: Row(
          children: [
            SvgPicture.asset(isSelected
                ? isWrong
                    ? ImagePath.icCheckedCircleRed
                    : ImagePath.icCheckedCircle
                : isCorrect
                    ? ImagePath.icCheckedCircle
                    : ImagePath.icCircle),
            const SizedBox(
              width: 10,
            ),
            Text(
              option,
              style: isSelected
                  ? isWrong
                      ? AppTextStyle.f14W600red
                      : AppTextStyle.f14W600green
                  : isCorrect
                      ? AppTextStyle.f14W600green
                      : AppTextStyle.f14W600kMainBlack,
            )
          ],
        ),
      ),
    );
  }
}
