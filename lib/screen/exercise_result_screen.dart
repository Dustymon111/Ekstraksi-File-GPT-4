import 'package:aplikasi_ekstraksi_file_gpt4/components/custom_button.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/answers_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/topics_detail_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/utils/docx_generator.dart';
import 'package:flutter/material.dart';

class ExerciseResultScreen extends StatelessWidget {
  final List<Question> questions;
  final int totalQuestions;
  final int correctAnswers;
  final Map<int, String> selectedOptions;
  final Subject subject;

  ExerciseResultScreen({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.questions,
    required this.selectedOptions,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final double score = (correctAnswers / totalQuestions * 100).ceilToDouble();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF1C88BF),
        title: Text('Exercise Result'),
        leading: Container(),
      ),
      body: Card(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Your Result',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C88BF),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Total Questions: $totalQuestions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Correct Answers: $correctAnswers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Score: $score',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnswersScreen(
                          questions: questions,
                          selectedOption: selectedOptions,
                        ),
                      ),
                    );
                  },
                  label: 'Check Answers',
                ),
                SizedBox(height: 16),
                CustomElevatedButton(
                  onPressed: () {
                    generateQuestionsDocx();
                  },
                  label: 'Generate Docx',
                ),
                SizedBox(height: 16),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SubjectDetailScreen(subject: subject)));
                  },
                  label: 'Selesai',
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
