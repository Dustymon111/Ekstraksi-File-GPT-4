import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';

class QuestionSet {
  late int point;
  late String status;
  final List<Question> questions;
  late Map<int, String> selectedOption;

  QuestionSet({
    required this.point,
    required this.status,
    required this.questions,
    required this.selectedOption,
  });

  factory QuestionSet.fromMap(Map<String, dynamic> data) {
    return QuestionSet(
      point: data['point'] ?? 0,
      status: data['status'] ?? '',
      questions: (data['questions'] as List<dynamic>? ?? []).map((questionData) {
        return Question.fromMap(questionData as Map<String, dynamic>);
      }).toList(),
      selectedOption: (data['selectedOptions'] as Map<String, dynamic>?)?.map((key, value) => MapEntry(int.parse(key), value as String)) ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'point': point,
      'status': status,
      'questions': questions.map((question) => question.toMap()).toList(),
      'selectedOptions': selectedOption.map((key, value) => MapEntry(key.toString(), value)),
    };
  }
}
