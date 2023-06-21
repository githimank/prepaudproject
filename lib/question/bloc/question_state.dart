import 'package:prepaudproject/question/model/question_model.dart';

abstract class QuestionState {}

class QuestionInitialState extends QuestionState {}

class QuestionLoadingState extends QuestionState {}

class AnswerSelectedState extends QuestionState {}

class AddedQuestionState extends QuestionState {
  final List<QuestionModel> question;
  AddedQuestionState({required this.question});
}

class QuestionFailedState extends QuestionState {}

class CheckButtonState extends QuestionState {}

class QuizSavedState extends QuestionState {}

class QuizFailedState extends QuestionState {}

class GetQuestionScoreLoadingState extends QuestionState {}

class GetQuestionScoreSuccessState extends QuestionState {
  List<QuestionModel> getQuestions;
  GetQuestionScoreSuccessState({required this.getQuestions});
}

class GetQuestionScoreFailedState extends QuestionState {}
