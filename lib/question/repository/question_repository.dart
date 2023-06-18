import 'package:prepaudproject/config/api_service/dio_utils_service.dart';

class QuestionRepository {
  final dio = DioUtil().getInstance();

  Future<Map<String, dynamic>> getQuestionsList() async {
    const String url = "https://question-generator-qh4u.onrender.com/questions";
    final response = await dio?.get(url, queryParameters: {"n": 10});

    return response?.data as Map<String, dynamic>;
  }
}
