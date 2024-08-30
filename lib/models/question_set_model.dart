import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';

class QuestionSet {
  String? id;
  String? title;
  late int point;
  late String status;
  int? correctAnswers;
  int? questionCount;
  List<Question> questions;
  late Map<int, dynamic> selectedOptions;
  DateTime? createdAt;
  DateTime? finishedAt;
  final String subjectId; // Reference to the Subject document
  String? duration;

  QuestionSet({
    this.id,
    this.title,
    this.correctAnswers,
    this.questionCount,
    required this.point,
    required this.status,
    required this.questions,
    required this.selectedOptions,
    required this.subjectId,
    this.createdAt,
    this.finishedAt,
    this.duration, // Initialize the duration field
  });

  factory QuestionSet.fromMap(Map<String, dynamic> data) {
    return QuestionSet(
      id: data['id'] ?? "",
      title: data['title'],
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
      subjectId: data['subjectId'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] is Timestamp
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.tryParse(data['createdAt'] as String) ??
                  DateTime.now())
          : null,
      finishedAt: data['finishedAt'] != null
          ? (data['finishedAt'] is Timestamp
              ? (data['finishedAt'] as Timestamp).toDate()
              : DateTime.tryParse(data['finishedAt'] as String) ??
                  DateTime.now())
          : null,
      duration: data['duration'] ?? "", // Add duration mapping
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? "",
      'title': title,
      'point': point,
      'correct_answers': correctAnswers,
      'questionCount': questionCount,
      'status': status,
      'questions': questions.map((question) => question.toMap()).toList(),
      'selectedOptions':
          selectedOptions.map((key, value) => MapEntry(key.toString(), value)),
      'subjectId': subjectId,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : null,
      'finishedAt': finishedAt != null
          ? Timestamp.fromDate(finishedAt!)
          : null,
      'duration': duration ?? "", // Add duration to the map
    };
  }
}

