import 'package:flutter/material.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';

class MultipleAnswerQuestionCard extends StatelessWidget {
  final Question question;
  final int number;
  final List<String> selectedOptions;
  final Function(bool?, String) onCheckboxChanged;

  const MultipleAnswerQuestionCard({
    required this.question,
    required this.number,
    required this.selectedOptions,
    required this.onCheckboxChanged,
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
                bool isChecked = selectedOptions.contains(option);
                return CheckboxListTile(
                  value: isChecked,
                  onChanged: (bool? value) {
                    onCheckboxChanged(value, option);
                  },
                  title: Text(option),
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
