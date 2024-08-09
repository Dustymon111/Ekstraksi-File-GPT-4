import 'package:flutter/material.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';

class EssayQuestionCard extends StatelessWidget {
  final Question question;
  final int number;
  final Function(String) onEssayChanged;
  final TextEditingController controller;

  const EssayQuestionCard({
    required this.question,
    required this.number,
    required this.onEssayChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${number}. ${question.text}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            TextFormField(
              onChanged: onEssayChanged,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Type your answer here...',
                border: OutlineInputBorder(),
              ),
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}
