// question_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prepaudproject/constants/app_color.dart';
import 'package:prepaudproject/question/bloc/question_cubit.dart';
import 'package:prepaudproject/question/bloc/question_state.dart';
import 'package:prepaudproject/question/model/question_model.dart';
import 'package:prepaudproject/question/widgets/option_tile.dart';

import '../../common_widgets/custom_button.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late QuestionCubit questionCubit;
  List<QuestionModel> questions = [];
  int score = 0;

  @override
  void initState() {
    super.initState();
    questionCubit = BlocProvider.of<QuestionCubit>(context);
    questionCubit.getQuestionsList();
  }

  bool isDisabled = true;

  void questionAttemptCheck() {
    final unAttemptedQuestion = questions.firstWhere(
      (element) => element.userSelectedAnswer == null,
      orElse: () {
        return QuestionModel();
      },
    );

    if (isDisabled != (unAttemptedQuestion.id != null)) {
      isDisabled = unAttemptedQuestion.id != null;
      questionCubit.setState(CheckButtonState());
    }
  }

  @override
  void dispose() {
    super.dispose();
    questionCubit.resetQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Paper'),
      ),
      body: Column(
        children: [
          BlocBuilder<QuestionCubit, QuestionState>(
            buildWhen: (previous, current) =>
                current is QuestionFailedState ||
                current is AnswerSelectedState ||
                current is QuestionLoadingState ||
                current is AddedQuestionState,
            builder: (context, state) {
              if (state is AddedQuestionState) {
                questions.clear();
                questions.addAll(state.question);
              }
              if (state is QuestionFailedState) {
                questions.clear();
                return const Expanded(
                    child: Text("DownTime!! try after sometime."));
              }
              if (state is AnswerSelectedState) {}
              if (state is QuestionLoadingState) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Card(
                          child: ListTile(
                            title: Text("${index + 1}. "
                                "${questions[index].question}"),
                          ),
                        ),
                        ...List.generate(questions[index].options?.length ?? 0,
                            (qindex) {
                          final option = questions[index].options?[qindex];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: OptionsTile(
                                selectedAnswer:
                                    questions[index].userSelectedAnswer ?? "",
                                correctAnswer:
                                    questions[index].correctAnswer ?? "",
                                option: option ?? "",
                                onTap: () {
                                  if ((questions[index].userSelectedAnswer ??
                                          "")
                                      .isEmpty) {
                                    questions[index].userSelectedAnswer =
                                        questions[index].options?[qindex];
                                    questionCubit
                                        .setState(AnswerSelectedState());
                                    questionAttemptCheck();
                                  }
                                }),
                          );
                        })
                      ],
                    );
                  },
                ),
              );
            },
          ),
          BlocConsumer<QuestionCubit, QuestionState>(
            listenWhen: (previous, current) {
              return current is QuizSavedState || current is QuizFailedState;
            },
            listener: (context, state) {
              if (state is QuizSavedState) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Quiz Saved Successfully!")));
              }
              if (state is QuizFailedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to save quiz.")));
              }
            },
            buildWhen: (previous, current) => current is CheckButtonState,
            builder: (context, state) {
              if (state is CheckButtonState) {}
              return Padding(
                padding: const EdgeInsets.all(20),
                child: CustomButton(
                    buttonColor:
                        !isDisabled ? AppColors.kMainGrey : AppColors.kGrey,
                    onTap: isDisabled
                        ? () {}
                        : () {
                            questionCubit.saveQuestionwithScore(
                                questions: questions);
                          },
                    buttonText: 'Finish'),
              );
            },
          ),
        ],
      ),
    );
  }
}
