import 'dart:async';
import '../models/question_model.dart'; // Import your question model

class QuestionStream {
  static Stream<List<Question>> getQuestions() async* {
    // Replace this with your actual data fetching logic
    List<Question> questions = [
      Question(
        text: 'What is your favorite color?',
        options: ['Red', 'Green', 'Blue', 'Yellow'],
      ),
      Question(
        text: 'Which programming language do you prefer?',
        options: ['Dart', 'JavaScript', 'Python', 'Java'],
      ),
      // Add more questions as needed
    ];

    yield questions;
  }
}