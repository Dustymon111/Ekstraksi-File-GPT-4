import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';

class QuestionSet {
  String? id;
  late int point;
  late String status;
  int? correctAnswers;
  int? questionCount;
  List<Question> questions;
  late Map<int, dynamic> selectedOptions;
  final String subjectId; // Reference to the Subject document

  QuestionSet({
    this.id,
    this.correctAnswers,
    this.questionCount,
    required this.point,
    required this.status,
    required this.questions,
    required this.selectedOptions,
    required this.subjectId,
  });

  factory QuestionSet.fromMap(Map<String, dynamic> data) {
    return QuestionSet(
      id: data['id'] ?? "",
      point: data['point'] ?? 0,
      correctAnswers: data['correct_answers'] ?? 0,
      questionCount: data['questionCount'] ?? 0,
      status: data['status'] ?? '',
      questions:
          (data['questions'] as List<dynamic>? ?? []).map((questionData) {
        return Question.fromMap(questionData as Map<String, dynamic>);
      }).toList(),
      selectedOptions: (data['selectedOptions'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(int.parse(key), value)) ??
          {},
      subjectId:
          data['subjectId'] ?? '', // Provide a default empty string if null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? "",
      'point': point,
      'correct_answers': correctAnswers,
      'questionCount': questionCount,
      'status': status,
      'questions': questions.map((question) => question.toMap()).toList(),
      'selectedOptions':
          selectedOptions.map((key, value) => MapEntry(key.toString(), value)),
      'subjectId': subjectId,
    };
  }
}
