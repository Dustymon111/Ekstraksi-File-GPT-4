import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:flutter/material.dart';

Widget buildQuestionCard(
    {required Question question,
    required int number,
    required String selectedOption,
    required Function(String?) onOptionChanged,
    Icon? secondary}) {
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
            children: question.options!.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue:
                    selectedOption, // Provide the selected answer here if implementing selection logic
                onChanged: onOptionChanged, // Handling the selected option
                secondary: secondary,
              );
            }).toList(),
          ),
        ],
      ),
    ),
  );
}
