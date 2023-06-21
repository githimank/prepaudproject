import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prepaudproject/question/bloc/question_state.dart';
import 'package:prepaudproject/question/model/question_model.dart';

class QuestionCubit extends Cubit<QuestionState> {
  QuestionCubit() : super(QuestionInitialState());

  final List<QuestionModel> _question = [];
  late BoxCollection _boxCollection;
  final int _questionLength = 10;

  void setState(QuestionState state) {
    emit(state);
  }

  void resetQuiz() {
    _question.clear();
  }

  void addQuestion({required QuestionModel questionModel}) {
    _question.add(questionModel);
    if (_questionLength == _question.length) {}
    emit(AddedQuestionState(question: _question));
  }

  void createLocalStorage() async {
    final directory = await getApplicationDocumentsDirectory();
    // Create a box collection
    _boxCollection = await BoxCollection.open(
        'quizbox', // Name of your database
        {'question_score'}, // Names of your boxes
        path: directory.path);
  }

  void saveQuestionwithScore({required List<QuestionModel> questions}) async {
    try {
      final box = await _boxCollection.openBox<Map>('question_score');

      await Future.forEach(questions, (element) async {
        QuestionModel question = element;
        question.score =
            question.correctAnswer == question.userSelectedAnswer ? 1 : 0;

        // Put something in
        await box.put(question.id ?? "", question.toJson());
      });
      emit(QuizSavedState());
    } catch (e) {
      emit(QuizFailedState());
    }
  }

  void getAllAttemptedQuiz() async {
    emit(GetQuestionScoreLoadingState());
    try {
      final box = await _boxCollection.openBox<Map>('question_score');

      final result = await box.getAllValues();

      List<QuestionModel> questions =
          List<QuestionModel>.from(result.values.map((e) {
        return QuestionModel.fromJson(e);
      }));
      emit(GetQuestionScoreSuccessState(getQuestions: questions));
    } catch (e) {
      emit(GetQuestionScoreFailedState());
    }
  }

  Future<void> getQuestionsList() async {
    try {
      emit(QuestionLoadingState());
      SSEClient.subscribeToSSE(
          url:
              'https://question-generator-qh4u.onrender.com/questions?n=$_questionLength',
          header: {
            "Cookie":
                'jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3QiLCJpYXQiOjE2NDMyMTAyMzEsImV4cCI6MTY0MzgxNTAzMX0.U0aCAM2fKE1OVnGFbgAU_UVBvNwOMMquvPY8QaLD138; Path=/; Expires=Wed, 02 Feb 2022 15:17:11 GMT; HttpOnly; SameSite=Strict',
            "Accept": "text/event-stream",
            "Cache-Control": "no-cache",
          }).listen((event) {
        final json = jsonDecode(event.data ?? "");

        final result = QuestionModel.fromJson(((json)));
        addQuestion(questionModel: result);
      });
    } on SocketException {
      emit(QuestionFailedState());
    } catch (e) {
      emit(QuestionFailedState());
    }
  }
}
