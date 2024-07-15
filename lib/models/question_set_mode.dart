import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';

class QuestionSet {
  final int point;
  final String status;
  final List<Question> questions;

  QuestionSet({
    required this.point,
    required this.status,
    required this.questions,
  });

   factory QuestionSet.fromMap(Map<String, dynamic> data) {
    return QuestionSet(
      point: data['point'] ?? 0, // Provide a default value if null
      status: data['status'] ?? '', // Provide a default empty string if null
      questions: (data['question'] as List<dynamic>? ?? []).map((questionData) {
        return Question.fromMap(questionData as Map<String, dynamic>);
      }).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'point': point,
      'status': status,
      'questions': questions.map((question) => question.toMap()).toList(),
    };
  }
}