abstract class QuestionState {}

class QuestionInitialState extends QuestionState {}

class QuestionLoadingState extends QuestionState {}

class QuestionSuccessState extends QuestionState {
  
}

class QuestionFailedState extends QuestionState {}
