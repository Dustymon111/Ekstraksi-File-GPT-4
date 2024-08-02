import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';

class QuestionSet {
  String? id;
  late int point;
  late String status;
  List<Question> questions;
  late Map<int, String> selectedOption;
  final String subjectId; // Reference to the Subject document

  QuestionSet({
    this.id,
    required this.point,
    required this.status,
    required this.questions,
    required this.selectedOption,
    required this.subjectId,
  });

  factory QuestionSet.fromMap(Map<String, dynamic> data) {
    return QuestionSet(
      id: data['id'] ?? "",
      point: data['point'] ?? 0,
      status: data['status'] ?? '',
      questions:
          (data['questions'] as List<dynamic>? ?? []).map((questionData) {
        return Question.fromMap(questionData as Map<String, dynamic>);
      }).toList(),
      selectedOption: (data['selectedOptions'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(int.parse(key), value as String)) ??
          {},
      subjectId:
          data['subjectId'] ?? '', // Provide a default empty string if null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? "",
      'point': point,
      'status': status,
      'questions': questions.map((question) => question.toMap()).toList(),
      'selectedOptions':
          selectedOption.map((key, value) => MapEntry(key.toString(), value)),
      'subjectId': subjectId,
    };
  }
}
