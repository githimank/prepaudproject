import 'dart:convert';

QuestionModel questionModelFromJson(String str) => QuestionModel.fromJson(json.decode(str));

String questionModelToJson(QuestionModel data) => json.encode(data.toJson());

class QuestionModel {
    final Data? data;

    QuestionModel({
        this.data,
    });

    factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
    };
}

class Data {
    final String? id;
    final String? question;
    final List<String>? options;
    final String? correctAnswer;
    final String? explanation;

    Data({
        this.id,
        this.question,
        this.options,
        this.correctAnswer,
        this.explanation,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        question: json["question"],
        options: json["options"] == null ? [] : List<String>.from(json["options"]!.map((x) => x)),
        correctAnswer: json["correctAnswer"],
        explanation: json["explanation"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
        "correctAnswer": correctAnswer,
        "explanation": explanation,
    };
}
