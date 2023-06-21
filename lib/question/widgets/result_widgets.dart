import 'package:flutter/material.dart';
import 'package:prepaudproject/constants/app_text_style.dart';

class TitileWidget extends StatelessWidget {
  const TitileWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyle.f16W700kMainBlack.copyWith(fontSize: 18),
    );
  }
}

class SubtitleTileWidget extends StatelessWidget {
  const SubtitleTileWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyle.f14W600kMainBlack,
    );
  }
}
