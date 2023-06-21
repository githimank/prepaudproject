// To parse this JSON data, do
//
//     final questionModel = questionModelFromJson(jsonString);

import 'dart:convert';

QuestionModel questionModelFromJson(String str) =>
    QuestionModel.fromJson(json.decode(str));

String questionModelToJson(QuestionModel data) => json.encode(data.toJson());

class QuestionModel {
  final String? id;
  final String? question;
  final List<String>? options;
  final String? correctAnswer;
  String? userSelectedAnswer;
  double score;

  final String? explanation;

  QuestionModel(
      {this.id,
      this.question,
      this.options,
      this.correctAnswer,
      this.explanation,
      this.score = 0,
      this.userSelectedAnswer});

  factory QuestionModel.fromJson(Map<dynamic, dynamic> json) => QuestionModel(
      id: json["id"],
      question: json["question"],
      options: json["options"] == null
          ? []
          : List<String>.from(json["options"]!.map((x) => x)),
      correctAnswer: json["correctAnswer"],
      explanation: json["explanation"],
      userSelectedAnswer: json["userSelectedAnswer"],
      score: json['score']??0);

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "options":
            options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
        "correctAnswer": correctAnswer,
        "userSelectedAnswer": userSelectedAnswer,
        "score": score,
        "explanation": explanation,
      };
}
