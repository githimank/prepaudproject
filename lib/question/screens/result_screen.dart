import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prepaudproject/question/bloc/question_cubit.dart';
import 'package:prepaudproject/question/bloc/question_state.dart';
import 'package:prepaudproject/question/model/question_model.dart';
import 'package:prepaudproject/question/widgets/result_widgets.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late QuestionCubit questionCubit;
  List<QuestionModel> questions = [];

  @override
  void initState() {
    super.initState();
    questionCubit = BlocProvider.of<QuestionCubit>(context);
    questionCubit.getAllAttemptedQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Column(
        children: [
          BlocBuilder<QuestionCubit, QuestionState>(
            buildWhen: (previous, current) =>
                current is GetQuestionScoreLoadingState ||
                current is GetQuestionScoreSuccessState ||
                current is GetQuestionScoreFailedState,
            builder: (context, state) {
              if (state is GetQuestionScoreLoadingState) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is GetQuestionScoreSuccessState) {
                questions.clear();
                questions.addAll(state.getQuestions);
              }
              if (state is GetQuestionScoreFailedState) {
                questions.clear();
                return const Expanded(child: Text("No Data to show"));
              }
              return Expanded(
                  child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Card(
                          child: ListTile(
                            title: TitileWidget(
                                text: "${index + 1}. "
                                    "${questions[index].question}"),
                            subtitle: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SubtitleTileWidget(
                                    text:
                                        "Correct Answer:- ${questions[index].correctAnswer}"),
                                SubtitleTileWidget(
                                  text:
                                      "User Selected Answer:- ${questions[index].userSelectedAnswer}",
                                ),
                                SubtitleTileWidget(
                                  text: "Score:- ${questions[index].score}",
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ));
            },
          )
        ],
      ),
    );
  }
}
