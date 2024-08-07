import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:flutter/material.dart';

Widget buildQuestionCard(
    {required Question question,
    required int number,
    required String selectedOption,
    required Function(String?) onOptionChanged,
    required Function(bool?, String) onCheckboxChanged,
    required Function(String) onEssayChanged}) {
  switch (question.type) {
    case 'm_choice':
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
                    groupValue: selectedOption as String,
                    onChanged: onOptionChanged,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    case 'm_answer':
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
                  bool isChecked = selectedOption.contains(option);
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
    case 'essay':
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
              TextField(
                onChanged: onEssayChanged,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Type your answer here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      );
    default:
      return Container(); // Handle any other cases
  }
}
