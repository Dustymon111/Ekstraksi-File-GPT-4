import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/answers_screen.dart';
import 'package:flutter/material.dart';

class ExerciseResultScreen extends StatelessWidget {
  final List<Question> questions;
  final int totalQuestions;
  final int correctAnswers;
  final Map<int, String> selectedOptions;

  ExerciseResultScreen({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.questions,
    required this.selectedOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Result',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Total Questions: $totalQuestions',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Correct Answers: $correctAnswers',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Score: ${(correctAnswers/totalQuestions * 100).ceil()}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnswersScreen(questions: questions,selectedOption: selectedOptions),
                  ),
                );
              },
              child: Text('Check Answers'),
            ),
          ],
        ),
      ),
    );
  }
}
