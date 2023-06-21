import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prepaudproject/constants/app_color.dart';
import 'package:prepaudproject/constants/app_text_style.dart';
import 'package:prepaudproject/question/bloc/question_cubit.dart';
import 'package:prepaudproject/question/screens/question_screen.dart';
import 'package:prepaudproject/question/screens/result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    context.read<QuestionCubit>().createLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.kMainGrey,
          title: Text(
            'QuizApp',
            style: AppTextStyle.f24W700kPureWhite,
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const QuestionScreen();
                    },
                  ));
                },
                child: Text(
                  "Quizzes",
                  style: AppTextStyle.f20W600kMainBlack,
                )),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                 Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const ResultScreen();
                    },
                  ));
                },
                child: Text(
                  "Result",
                  style: AppTextStyle.f20W600kMainBlack,
                ))
          ],
        ),
      ),
    );
  }
}
