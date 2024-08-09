import 'package:flutter/material.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';

class MultipleChoiceQuestionCard extends StatelessWidget {
  final Question question;
  final int number;
  final dynamic selectedOption;
  final Function(String?) onOptionChanged;

  const MultipleChoiceQuestionCard({
    required this.question,
    required this.number,
    required this.selectedOption,
    required this.onOptionChanged,
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
            Column(
              children: question.options.map((option) {
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: selectedOption,
                  onChanged: onOptionChanged,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
