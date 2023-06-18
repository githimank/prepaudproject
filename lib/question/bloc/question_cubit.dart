import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prepaudproject/question/bloc/question_state.dart';
import 'package:prepaudproject/question/model/question_model.dart';
import 'package:prepaudproject/question/repository/question_repository.dart';

class QuestionCubit extends Cubit<QuestionState> {
  QuestionCubit() : super(QuestionInitialState());

  final QuestionRepository _questionRepository = QuestionRepository();

  Future<void> getQuestionsList() async {
    try {
      emit(QuestionLoadingState());
      final response = _questionRepository.getQuestionsList();

      // final responseData = QuestionModel.fromJson(response);

      // final result = List<QuestionModel>.from(
      //     response['data'].map((e) => QuestionModel.fromJson(e)));
      emit(QuestionSuccessState());
    } on DioException catch (e) {
      emit(QuestionFailedState());
    } catch (e) {
      emit(QuestionFailedState());
    }
  }
}
