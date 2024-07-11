import 'dart:async';

import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:flutter/material.dart';

class QuestionProvider extends ChangeNotifier {
  Map <int, String> _selectedOption = {}; // keep track of the selected question option
  List<Question> questions = [
      Question(
        text: 'What is your favorite color?',
        options: ['Red', 'Green', 'Blue', 'Yellow'],
        correctOption: "Red"
      ),
      Question(
        text: 'Which programming language do you prefer?',
        options: ['Dart', 'JavaScript', 'Python', 'Java'],
        correctOption: "Python"
      ),
      // Add more questions as needed
    ];

  final _questionController = StreamController<List<Question>>.broadcast();
  Stream<List<Question>> get questionStream => _questionController.stream;
  
  void initiateQuestion() {
    _questionController.sink.add(questions);
    notifyListeners();
  }


  // Stream<List<Question>> getQuestions() async* {
  //   // Replace this with your actual data fetching logic
  //   List<Question> questions = [
  //     Question(
  //       text: 'What is your favorite color?',
  //       options: ['Red', 'Green', 'Blue', 'Yellow'],
  //     ),
  //     Question(
  //       text: 'Which programming language do you prefer?',
  //       options: ['Dart', 'JavaScript', 'Python', 'Java'],
  //     ),
  //     // Add more questions as needed
  //   ];
  //   yield questions;
  // }

  
  Map<int, String> get selectedOption => _selectedOption;
  
  void setSelectedOption(int index, String option) {
    _selectedOption[index] = option;
    notifyListeners();
  }
}