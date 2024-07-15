import 'package:aplikasi_ekstraksi_file_gpt4/models/question_set_mode.dart';

class Subject {
  final String title;
  final String description;
  final List<QuestionSet> questionSets;

  Subject({
    required this.title,
    required this.description,
    required this.questionSets,
  });

  factory Subject.fromMap(Map<String, dynamic> data) {
    return Subject(
      title: data['title'] ?? '', // Provide a default empty string if null
      description: data['description'] ?? '', // Provide a default empty string if null
      questionSets: (data['questionSets'] as List<dynamic>? ?? []).map((questionSetData) {
        return QuestionSet.fromMap(questionSetData as Map<String, dynamic>);
      }).toList(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'questionSets': questionSets.map((questionSet) => questionSet.toMap()).toList(),
    };
  }
}