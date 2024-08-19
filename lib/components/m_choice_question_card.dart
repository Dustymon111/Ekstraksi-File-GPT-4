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
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF1C88BF), width: 2), // Warna border
        borderRadius: BorderRadius.circular(10), // Radius sudut border
      ),
      child: Card(
        elevation: 2, // Menambahkan shadow pada Card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              10), // Menyelaraskan border radius dengan Container
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${number}. ${question.text}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
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
      ),
    );
  }
}
