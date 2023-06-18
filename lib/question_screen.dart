// question_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:prepaudproject/question/bloc/question_cubit.dart';
import 'package:prepaudproject/question/bloc/question_state.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late QuestionCubit questionCubit;
  List<String> questions = [];
  int score = 0;

  @override
  void initState() {
    super.initState();
    questionCubit = BlocProvider.of<QuestionCubit>(context);
    fetchQuestions();
    retrieveScore();
  }

  void fetchQuestions() async {
    while (true) {
      final response = await http.get(Uri.parse(
          'https://question-generator-qh4u.onrender.com/questions?n=10'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<String> newQuestions = [];
        for (var question in jsonData) {
          newQuestions.add(question['text']);
        }
        setState(() {
          questions = newQuestions;
        });
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }

  void retrieveScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      score = prefs.getInt('score') ?? 0;
    });
  }

  void updateScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      score++;
      prefs.setInt('score', score);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Paper'),
      ),
      body: Column(
        children: [
          Text('Score: $score'),
          BlocBuilder<QuestionCubit, QuestionState>(
            // buildWhen: (previous, current) =>
            //     current is QuestionFailedState ||
            //     current is QuestionSuccessState ||
            //     current is QuestionLoadingState,
            builder: (context, state) {
              if (state is QuestionFailedState) {
                questions.clear();
              }
              if (state is QuestionSuccessState) {
                // questions.addAll(iterable);
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(questions[index]),
                        onTap: () {
                          updateScore();
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
