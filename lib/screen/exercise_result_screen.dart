import 'package:aplikasi_ekstraksi_file_gpt4/providers/question_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/answers_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseResultScreen extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;

  ExerciseResultScreen({
    required this.totalQuestions,
    required this.correctAnswers,
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
                    builder: (context) => AnswersScreen(selectedOption: context.read<QuestionProvider>().selectedOption),
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
